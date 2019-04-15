import 'dart:ui';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

  Tiled.TileMap map;
  Image tilesetImage;
  WalkingPlayer player;
  WalkingCamera camera;

  // State information
  Rect lastVisibleRect;  

  @override
  Future initialize() async {
    // Load map
    final mapXml = await Flame.assets.readFile(mapFileName());
    this.map = Tiled.TileMapParser().parse(mapXml);
    this.tilesetImage = await Flame.images.load(tilesetFileName());

    // (16) Spawn actors

    // Spawn player
    var playerSpawn = locatePlayerOnSpawn(this.map, SpawnTileId);
    this.player = WalkingPlayer(
      playerSpawn[0]*this.map.tileWidth  + this.map.tileWidth/2, 
      playerSpawn[1]*this.map.tileHeight + this.map.tileHeight/2
      );

    // Position camera
    this.camera = WalkingCamera(
      sceneWidth:  (this.map.tileWidth * this.map.layers[0].width).toDouble(),
      sceneHeight: (this.map.tileHeight * this.map.layers[0].height).toDouble(),
      zoom: 0.1,
      x: this.player.x,
      y: this.player.y,
      screenProportions: screenSize,
    );

    // (9)  Camera.FlyTo target
    // final targets = ListTargets(this.map);
    // this.camera.flyThrough(targets);
  }

  @override
  void resize(Size size){
    super.resize(size);
    this.camera?.resize(size);
  }

  @override
  void onTapDown(TapDownDetails d) {
    goToMainMenu();

    // Check if interaction enabled
    if(this.camera.isInAction) return;

    // (11) Detect target

    // (15) If HUD: react
    // (12) If target is floor: go to
    //      If target is actor:
    // (18)   If actor is too far away: go to
    // (19)   else: act
  }

  @override
  void render(Canvas canvas) {
    if(screenSize == null) return;

    final visibleRect = this.camera.getVisibleRect();
    this.lastVisibleRect = visibleRect;

    renderMap(canvas, visibleRect);

    // (17) Visible actors

    // (10) Player

    // (14) HUD

    // (9) FPS rate
  }

  void renderMap(Canvas canvas, Rect visibleRect) {
    final rowFrom = (visibleRect.top / map.tileHeight).floor();
    final rowTo = (visibleRect.bottom / map.tileHeight).ceil() -1;
    final screenRowHeight = screenSize.height * map.tileHeight / visibleRect.height;
    final rowScreenShift = visibleRect.top % map.tileHeight == 0 ? 0 : ((map.tileHeight - visibleRect.top % map.tileHeight)/ map.tileHeight) * screenRowHeight;
    final columnFrom = (visibleRect.left / map.tileWidth).floor();
    final columnTo = (visibleRect.right / map.tileWidth).ceil() -1;
    final screenColumnWidth = screenSize.width * map.tileWidth / visibleRect.width;
    final columnScreenShift = visibleRect.left % map.tileWidth == 0 ? 0 : ((map.tileWidth - visibleRect.left % map.tileWidth)/ map.tileWidth) * screenColumnWidth;
    final fullPaint = BasicPalette.white.paint;
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
  }

  static List locatePlayerOnSpawn(Tiled.TileMap map, int spawnTileId) {
    final passLayer = map
        .layers
        .firstWhere((l) => l.name.toUpperCase() == 'PASS', orElse: () => null);
    if (passLayer == null) throw Exception('Map does not have "Pass" layer');
    for (var row = 0; row < passLayer.tileMatrix.length; row++) {
      final column = passLayer.tileMatrix[row].indexOf(spawnTileId);
      if (column >= 0) {
        final x = column;
        final y = row;
        return [x, y];
      }
    }
    throw Exception('Map does not have Spawn tile #$spawnTileId in "Pass" layer');
  }
}
