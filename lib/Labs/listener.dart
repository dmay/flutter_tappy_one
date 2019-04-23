import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';

void  main() async {
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  var game = ListenGame();

  runApp(MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (e) { 
              /* => NEVER HIT */ debugPrint('pointerDown!');
              },                          
            onPointerMove: (e) { 
              /* => NEVER HIT */ debugPrint('onPointerMove!'); 
              },
            onPointerUp: (e) { 
              /* => NEVER HIT */ debugPrint('onPointerUp!'); 
              },
            //child: game.widget,
            child: Text('But Text child would pop(?) events up to Listener (when tapped on Text itself)'),
          ),
        ],
      )
    ),
  ));
}

class ListenGame extends Game{

  @override
  void render(Canvas canvas) {
  }

  @override
  void update(double t) {
  }

}