import 'dart:ui';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/SceneElements/CameraFlythroughStep.dart';
import 'package:tappy_one/SceneElements/FpsCounter.dart';
import 'package:tappy_one/SceneElements/WalkingCamera.dart';
import 'package:tappy_one/SceneElements/WalkingPlayer.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:tiled/tiled.dart' as Tiled;
import 'package:flame/flame.dart';

class WalkingDemoScene extends SceneBase {

  /// delegate to navigate back to main menu
  Function goToMainMenu;

  WalkingDemoScene(this.goToMainMenu);

  String mapFileName() => 'WalkingDemoScene.tmx';
  String tilesetFileName() => 'terrain.png';
  static const num tilesetWidth = 32;
  static const num tilesetHeight = 32;
  static const num tilesetTileWidth = 32.0;
  static const num tilesetTileHeight = 32.0;
  static const int SpawnTileId = 926;

  static const bool __debug_show_grid = false;
  static const bool __debug_show_fps  = true;

  Tiled.TileMap map;
  Image tilesetImage;
  List<Tiled.TmxObject> objects;
  Tiled.Layer passLayer;

  WalkingPlayer player;
  WalkingCamera camera;
  FpsCounter fpsCounter;

  // State information
  Rect lastVisibleRect;  

  @override
  Future initialize() async {
    // Load map
    final mapXml = await Flame.assets.readFile(mapFileName());
    this.map = Tiled.TileMapParser().parse(mapXml);
    this.tilesetImage = await Flame.images.load(tilesetFileName());
    this.objects = map.objectGroups.expand((g)=>g.tmxObjects).toList();
    this.passLayer = map
        .layers
        .firstWhere((l) => l.name.toUpperCase() == 'PASS', orElse: () => null);
    if (passLayer == null) throw Exception('Map does not have "Pass" layer');

    // (16) Spawn actors

    // Spawn player
    var playerSpawn = locatePlayerOnSpawn(this.map, SpawnTileId);
    this.player = WalkingPlayer(
      playerSpawn[0], 
      playerSpawn[1]
      );

    // Position camera
    this.camera = WalkingCamera(
      sceneWidth:  (this.map.tileWidth * this.map.layers[0].width).toDouble(),
      sceneHeight: (this.map.tileHeight * this.map.layers[0].height).toDouble(),
      zoom: 0.25,
      x: this.player.x,
      y: this.player.y,
      screenProportions: screenSize,
    );

    // Camera.FlyTo target
    final targets = listTargets();
    this.camera.flyThrough(targets);

    if(__debug_show_fps){
      fpsCounter = FpsCounter();
      fpsCounter.resize(screenSize);
    }
  }

  @override
  void resize(Size size){
    super.resize(size);
    this.camera?.resize(size);
    this.fpsCounter?.resize(size);
  }

  @override
  void onTapDown(TapDownDetails d) {
    // Check if interaction enabled
    if(this.camera.isInAction) return;

    this.switchSceneTo(goToMainMenu);

    // (11) Detect target

    // (15) If HUD: react
    // (12) If target is floor: go to
    //      If target is actor:
    // (18)   If actor is too far away: go to
    // (19)   else: act
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if(screenSize == null) return;

    final visibleRect = this.camera.getVisibleRect();
    this.lastVisibleRect = visibleRect;

    renderMap(canvas, visibleRect);

    // (17) Visible actors

    // (10) Player

    // (14) HUD

    // FPS rate
    fpsCounter?.render(canvas);
  }

  void renderMap(Canvas canvas, Rect visibleRect) {
    final rowFrom = (visibleRect.top / map.tileHeight).floor();
    final rowTo = (visibleRect.bottom / map.tileHeight).ceil() -1;
    final screenRowHeight = screenSize.height * map.tileHeight / visibleRect.height;
    final rowScreenShift = visibleRect.top % map.tileHeight == 0 ? 0 : -((visibleRect.top % map.tileHeight)/ map.tileHeight) * screenRowHeight;
    final columnFrom = (visibleRect.left / map.tileWidth).floor();
    final columnTo = (visibleRect.right / map.tileWidth).ceil() -1;
    final screenColumnWidth = screenSize.width * map.tileWidth / visibleRect.width;
    final columnScreenShift = visibleRect.left % map.tileWidth == 0 ? 0 : -((visibleRect.left % map.tileWidth)/ map.tileWidth) * screenColumnWidth;
    final fullPaint = BasicPalette.white.paint;
    final gridPaint = Paint()..color = Color(0xFF000000)..style = PaintingStyle.stroke;
    for (var layerIndex = 0; layerIndex < map.layers.length; layerIndex++) {
      final layer = map.layers[layerIndex];
      if(layer.name.toUpperCase() == 'PASS') continue;
      for(var rowIndex = rowFrom; rowIndex <= rowTo; rowIndex++)
        for(var columnIndex = columnFrom; columnIndex <= columnTo; columnIndex++){
          final tileId = layer.tileMatrix[rowIndex][columnIndex] -1;
          final tilesetX = (tileId % tilesetWidth) * tilesetTileWidth;
          final tilesetY = (tileId / tilesetHeight).floor() * tilesetTileHeight;
          final tilesetPosition = Rect.fromLTWH(
            tilesetX, tilesetY, 
            tilesetTileWidth, tilesetTileHeight);
          final screenX = columnScreenShift + (columnIndex - columnFrom)*screenColumnWidth;
          final screenY = rowScreenShift + (rowIndex - rowFrom)*screenRowHeight;
          final screenPosition = Rect.fromLTWH(
            screenX, screenY, 
            screenColumnWidth, screenRowHeight);
          canvas.drawImageRect(tilesetImage, tilesetPosition, screenPosition, fullPaint);
          if(__debug_show_grid)
            canvas.drawRect(screenPosition, gridPaint);
        }
    }    
  }

  @override
  void update(double time) {
    super.update(time);
    if(!isActive) return;

    // (13) Player: going
    // (20) Actors: update
    
    // Camera: fly OR adjust to player
    this.camera.update(
      time:time, 
      targetX: player.x, 
      targetY: player.y);

      fpsCounter?.update(time);
  }

  List locatePlayerOnSpawn(Tiled.TileMap map, int spawnTileId) {
    final spawn = this.objects.firstWhere(
      (o)=>o.type == 'Spawn', 
      orElse: () => throw Exception('Map does not have "Spawn" object')
      );
    return [
      spawn.x + spawn.width/2,
      spawn.y - spawn.height/2
    ];
  }

  List<CameraFlythroughStep> listTargets(){
    final targets = 
      objects
      .where((o)=>
        o.properties.containsKey('ShowOnStart') && 
        o.properties['ShowOnStart']=='true')
      .toList()
      ..sort((a,b)=>int.parse(a.properties['ShowOnStartOrder']).compareTo(
        int.parse(b.properties['ShowOnStartOrder'])
      ));
      final result = List<CameraFlythroughStep>();
      result.add(CameraFlythroughStep(x:player.x, y:player.y, stayTimeSec: 0.5));
      result.addAll(targets.map((t)=>CameraFlythroughStep(
        flyTimeSec: 1.0,
        x: t.x + t.width/2,
        y: t.y - t.height/2,
        stayTimeSec: 0.5,
      )));
      result.add(CameraFlythroughStep(flyTimeSec: 1.0, x:player.x, y:player.y, stayTimeSec: 0.5));
      return result;
  }
}
