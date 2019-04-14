import 'dart:io';
import 'package:tiled/tiled.dart';

void  main() async {
    final mapXml = await File('assets/WalkingDemoScene.tmx').readAsString();
    final map = TileMapParser().parse(mapXml);
    //print(map.layers[3].name);
    print(map.layers[3].tileMatrix[0][0]);
    print(map.layers[3].tiles[0].tileId);
    print(map.tilesets[0].source);
}
