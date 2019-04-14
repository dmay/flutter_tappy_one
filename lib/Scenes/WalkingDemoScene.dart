import 'dart:ui';
import 'package:flutter/gestures.dart';
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

    // (3)  Position camera
    // (4)  Camera.FlyTo target
  }

  @override
  void onTapDown(TapDownDetails d) {
    // (5)  Check if interaction enabled

    // (11) Detect target

    // (15) If HUD: react
    // (12) If target is floor: go to
    //      If target is actor:
    // (18)   If actor is too far away: go to
    // (19)   else: act
  }

  @override
  void render(Canvas canvas) {
    // (8) Visible tiles: floor
    // (9) Visible tiles: walls

    //final image = this.map.layers[0].tiles[0].image.;
    //canvas.drawImage(image, p, paint);

    // (17) Visible actors

    // (10) Player

    // (14) HUD
  }

  @override
  void update(double time) {
    // (13) Player: going
    // (6)  Camera: fly OR adjust to player
    // (7)  If camera is not flying and on player and interaction is disabled: enable interaction
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

  // List locatePlayerOnSpawn() {
  //   final passLayer = this
  //       .map
  //       .layers
  //       .firstWhere((l) => l.name.toUpperCase() == 'PASS', orElse: () => null);
  //   if (passLayer == null) throw Exception('Map does not have "Pass" layer');
  //   for (var row = 0; row < passLayer.tileMatrix.length; row++) {
  //     final column = passLayer.tileMatrix[row].indexOf(SpawnTileId);
  //     if (column >= 0) {
  //       final x = column * this.map.tileWidth + this.map.tileWidth / 2;
  //       final y = column * this.map.tileHeight + this.map.tileHeight / 2;
  //       return [x, y];
  //     }
  //   }
  //   throw Exception('Map does not have Spawn tile #$SpawnTileId in "Pass" layer');
  // }
}
