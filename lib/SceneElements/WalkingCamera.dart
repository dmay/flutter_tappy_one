import 'dart:ui';
import 'package:meta/meta.dart';

class WalkingCamera{

  double sceneWidth;
  double sceneHeight;
  double zoom;
  double x;
  double y;
  bool isInAction;
  Size screenProportions;

  WalkingCamera({
    @required this.sceneWidth, @required this.sceneHeight, 
    this.zoom = 1.0, 
    this.x = 0.0, this.y = 0.0, 
    this.isInAction = false,
    this.screenProportions});

  void resize(Size size) {
    screenProportions = size;
  }

  void update({@required double time, double targetX, double targetY}) {

  }

  Rect getVisibleRect() {
    //NOW WalkingCamera.getVisibleRect
    return Rect.fromLTWH(0, 0, sceneWidth*zoom*5, sceneHeight);
  }



} 