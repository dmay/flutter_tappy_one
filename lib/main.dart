import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:tappy_one/MainLoop.dart';
import 'package:flutter/gestures.dart';

/*

  Overall project structure:
  MainLoop extends Game - Main router of everything
    * Scene activeScene - active scene
    * GameContext activeContext - active GameContext (save, player state etc)
    ...
*/

void  main() async {
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  var mainLoop = MainLoop();
  mainLoop.initialize();

  var tapRecognizer = TapGestureRecognizer();
  tapRecognizer.onTapDown = mainLoop.onTapDown;
  tapRecognizer.onTap = mainLoop.onTap;
  tapRecognizer.onTapUp = mainLoop.onTapUp;
  tapRecognizer.onTapCancel = mainLoop.onTapCancel;
  var panRecognizer = PanGestureRecognizer();
  panRecognizer.onStart = mainLoop.onPanStart;
  panRecognizer.onUpdate = mainLoop.onPanUpdate;
  panRecognizer.onEnd = mainLoop.onPanEnd;

  runApp(mainLoop.widget);

  flameUtil.addGestureRecognizer(tapRecognizer);
  flameUtil.addGestureRecognizer(panRecognizer);

}

