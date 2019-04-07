import 'dart:ui';
import 'package:flutter/gestures.dart';

abstract class SceneBase{
  
  Size screenSize;
  bool isActive = false;

  void resize(Size size) {
    screenSize = size;
  }

  Future initialize() {
  }

  void setActive(){
    this.isActive = true;
  }

  void setInactive(){
    this.isActive = false;
  }

  void onTapDown(TapDownDetails d) {
  }

  void render(Canvas canvas) {
  }

  void update(double time) {
  }

  void destroy(){
  }

  /* Scenes navigation */

  Function switchSceneTo = (Function buildNextScene) 
    => throw Exception('!!! [SceneBase] call to default switchSceneTo');

  Function openScene = (Function buildNewScene)
    => throw Exception('!!! [SceneBase] call to default openScene');

  Function closeScene = ()
    => throw Exception('!!! [SceneBase] call to default closeScene');

}