import 'dart:ui';
import 'package:flutter/gestures.dart';

abstract class SceneBase{

  /* Control interfqace */

  Size screenSize;
  bool isActive = false;

  Future initialize() {}

  void setActive(){
    this.isActive = true;
  }

  void setInactive(){
    this.isActive = false;
  }

  void destroy(){}

  /* Main loop methods */

  void resize(Size size) {
    screenSize = size;
  }

  void render(Canvas canvas) {}

  void update(double time) {}

  /* Events handlers */

  void onTapDown(TapDownDetails details) {}

  void onTap(TapDownDetails details) {}

  void onDoubleTap(TapDownDetails details) {}

  onPanStart(DragStartDetails details) {}

  void onPanUpdate(DragUpdateDetails details) {}

  void onPanEnd(DragEndDetails details) {}
  
  /*
      Scenes navigation. 
      Actual implementations assigned by MainLoop.buildAndSetupScene method
  */

  Function switchSceneTo = (Function buildNextScene) 
    => throw Exception('!!! [SceneBase] call to default switchSceneTo');

  Function openScene = (Function buildNewScene)
    => throw Exception('!!! [SceneBase] call to default openScene');

  Function closeScene = ()
    => throw Exception('!!! [SceneBase] call to default closeScene');

}