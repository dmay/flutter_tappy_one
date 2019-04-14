import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/SceneElements/WalkingCamera.dart';
import 'package:tappy_one/SceneElements/WalkingPlayer.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:tiled/tiled.dart';
import 'package:flutter/services.dart' show rootBundle;

class WalkingDemoScene extends SceneBase {
  /// delegate to navigate back to main menu
  Function goToMainMenu;


  WalkingDemoScene(this.goToMainMenu);

  String mapFileName() => 'assets/WalkingDemoScene.tmx';
  static const int SpawnTileId = 926;

  TileMap map;
  WalkingPlayer player;
  WalkingCamera camera;

  // State information
  Rect lastVisibleRect;  

  @override
  Future initialize() async {
    // Load map
    final mapXml = await rootBundle.loadString(mapFileName());
    this.map = TileMapParser().parse(mapXml);

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

    // (7) Visible tiles: floor
    // (8) Visible tiles: walls
    renderMap(canvas, visibleRect);

    // (17) Visible actors

    // (10) Player

    // (14) HUD
  }

  void renderMap(Canvas canvas, Rect visibleRect) {
    final rowFrom = (visibleRect.top / map.tileHeight).floor();
    final rowTo = (visibleRect.bottom / map.tileHeight).ceil();
    final rowScreenHeight = screenSize.height * map.tileHeight / visibleRect.height;
    final rowScreenShift = visibleRect.top % map.tileHeight == 0 ? 0 : ((map.tileHeight - visibleRect.top % map.tileHeight)/ map.tileHeight) * rowScreenHeight;
    final columnFrom = (visibleRect.left / map.tileWidth).floor();
    final columnTo = (visibleRect.right / map.tileWidth).ceil();
    final columnScreenWidth = screenSize.width * map.tileWidth / visibleRect.width;
    final columnScreenShift = visibleRect.left % map.tileWidth == 0 ? 0 : ((map.tileWidth - visibleRect.left % map.tileWidth)/ map.tileWidth) * columnScreenWidth;
    final paint = Paint()
      ..color = Color(0xff00ff00)
      ..style = PaintingStyle.stroke;
    for (var layerIndex = 0; layerIndex < map.layers.length; layerIndex++) {
      final layer = map.layers[layerIndex];
      if(layer.name.toUpperCase() == 'PASS') continue;
      for(var rowIndex = rowFrom; rowIndex <= rowTo; rowIndex++)
        for(var columnIndex = columnFrom; columnIndex <= columnTo; columnIndex++){
          final tileId = layer.tileMatrix[rowIndex][columnIndex];
          //NOW Drop given tileId onto canvas    
          final screenX = columnScreenShift + (columnIndex - columnFrom)*columnScreenWidth;
          final screenY = rowScreenShift + (rowIndex - rowFrom)*rowScreenHeight;
          canvas.drawRect(
            Rect.fromLTWH(screenX, screenY, columnScreenWidth, rowScreenHeight)
            , paint);
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

  static List locatePlayerOnSpawn(TileMap map, int spawnTileId) {
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
