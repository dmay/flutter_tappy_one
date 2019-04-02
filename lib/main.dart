import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:tappy_one/MainLoop.dart';
import 'package:flutter/gestures.dart';

void  main() async {
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  var mainLoop = MainLoop();

  var tapRecognizer = TapGestureRecognizer();
  tapRecognizer.onTapDown = mainLoop.onTapDown;

  runApp(mainLoop.widget);

  flameUtil.addGestureRecognizer(tapRecognizer);
}

