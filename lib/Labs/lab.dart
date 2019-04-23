import 'dart:io';
import 'package:tiled/tiled.dart';
//import 'dart:async';

void main() async{
  //final c = Completer();
  //c.
}


void  mapTiled() async {
    final mapXml = await File('assets/WalkingDemoScene.tmx').readAsString();
    final map = TileMapParser().parse(mapXml);
    //print(map.layers[3].name);
    print(map.layers[3].tileMatrix[0][0]);
    print(map.layers[3].tileMatrix[0][1]);
    print(map.layers[3].tileMatrix[1][0]);
    //print(map.layers[3].tiles[0].tileId);
    //print(map.tilesets[0].source);
    var location = locatePlayerOnSpawn(map, 926);
    print('spawn: ${location[0]}x${location[1]}');
}

  List locatePlayerOnSpawn(TileMap map, int spawnTileId) {
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
