import 'dart:ui';
import 'package:flutter/gestures.dart';

abstract class SceneBase{
  
  Size screenSize;

  void resize(Size size) {
    screenSize = size;
  }

  void initialize() {
  }

  void onTapDown(TapDownDetails d) {
  }

  void render(Canvas canvas) {
  }

  void update(double time) {
  }

  /* Scenes navigation */

  void switchSceneTo(Function buildNextScene){
    //NOW switchSceneTo
  }

  void openScene(Function buildNextScene){
    //NOW openScene
  }

  void closeScene(){
    //NOW closeScene
  }

}