import 'dart:ui';
import 'package:meta/meta.dart';

class WalkingCamera{

  double sceneWidth;
  double sceneHeight;
  double zoom;
  double x;
  double y;
  bool isInAction;
  Size screenSize;

  WalkingCamera({
    @required this.sceneWidth, @required this.sceneHeight, 
    this.zoom = 1.0, 
    this.x = 0.0, this.y = 0.0, 
    this.isInAction = false,
    this.screenSize});

  void resize(Size size) {
    screenSize = size;
  }

  void update({@required double time, double targetX, double targetY}) {
    
  }



} 