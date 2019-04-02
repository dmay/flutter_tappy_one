import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:tappy_one/MainLoop.dart';

void  main() async {
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  var mainLoop = MainLoop();

  runApp(mainLoop.widget);
}

