import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:tappy_one/SceneElements/CameraFlythroughStep.dart';

enum CameraAction{
  none,
  flyTo,
  stareAt,
}

class WalkingCamera {
  double sceneWidth;
  double sceneHeight;
  double zoom;
  double walkingSection;
  double widthZoomFactor;
  double heightZoomFactor;
  double x;
  double y;
  bool isInAction = false;
  Size screenProportions;
  double visibleWidth;
  double visibleHeight;
  Rect visibleRectangle;

  CameraFlythroughStep _currentFlythroughTarget;
  CameraAction _currentAction = CameraAction.none;
  Completer _currentActionCompleter;
  num _currentTimeLeft = 0.0;

  double maxDistanceToTarget;


  WalkingCamera(
      {@required this.sceneWidth,
      @required this.sceneHeight,
      this.zoom = 1.0,
      this.x = 0.0,
      this.y = 0.0,
      this.screenProportions,
      this.walkingSection = 2/3,
      }) {
    updateFactors();
  }

  void resize(Size size) {
    screenProportions = size;
    updateFactors();
  }

  void update({@required double time, double targetX, double targetY}) {
    switch(_currentAction){
      case CameraAction.none:
        final dx = x - targetX;
        final dy = y - targetY;
        if(dx > maxDistanceToTarget) x = targetX +maxDistanceToTarget;
        else if(dx < -maxDistanceToTarget) x = targetX -maxDistanceToTarget;
        if(dy > maxDistanceToTarget) y = targetY +maxDistanceToTarget;
        else if(dy < -maxDistanceToTarget) y = targetY -maxDistanceToTarget;
        //TODO Camera: if target moves away for > 3 sec - aim on it when it stoped
      break;
      case CameraAction.flyTo:
        if(time < _currentTimeLeft){
          x += (_currentFlythroughTarget.x - x)*time / _currentTimeLeft;
          y += (_currentFlythroughTarget.y - y)*time / _currentTimeLeft;
          _currentTimeLeft -= time;
        }
        else{
          x = _currentFlythroughTarget.x;
          y = _currentFlythroughTarget.y;
          _currentAction = CameraAction.stareAt;
          _currentTimeLeft = _currentFlythroughTarget.stayTimeSec;
        }
        break;
      case CameraAction.stareAt:
        _currentTimeLeft -= time;
        if(_currentTimeLeft < 0.0)
          _completeCurrentAction();
        break;
    }
    visibleRectangle = _updateVisibleRectangle();
  }

  Rect _updateVisibleRectangle() {
    var visibleTop = y - visibleHeight / 2;
    if (visibleTop < 0.0)
      visibleTop = 0.0;
    else if (visibleTop > sceneHeight - visibleHeight)
      visibleTop = sceneHeight - visibleHeight;
    
    var visibleLeft = x - visibleWidth / 2;
    if (visibleLeft < 0.0)
      visibleLeft = 0.0;
    else if (visibleLeft > sceneWidth - visibleWidth)
      visibleLeft = sceneWidth - visibleWidth;

    return Rect.fromLTWH(visibleLeft, visibleTop, visibleWidth, visibleHeight);
  }

  void updateFactors(){
    if (this.screenProportions == null) return;

    _updateZoomFactors();
    
    this.visibleWidth = sceneWidth * zoom * widthZoomFactor;
    this.visibleHeight = sceneHeight * zoom * heightZoomFactor;
    
    this.maxDistanceToTarget = min(
      visibleWidth * walkingSection,
      visibleHeight * walkingSection
    ) / 2;
  }

  void _updateZoomFactors() {
    /*

       sceneWidth  * zoom * widthZoomFactor       screenProportions.width
      ---------------------------------------  = --------------------------
       sceneHeight * zoom * heightZoomFactor      screenProportions.height 

      
      widthZoomFactor = 1.0 =>

                          sceneWidth      screenProportions.height
      heightZoomFactor = ------------- * --------------------------
                          sceneHeight     screenProportions.width

    */

    widthZoomFactor = 1.0;
    heightZoomFactor = (sceneWidth / sceneHeight) *
        (screenProportions.height / screenProportions.width);
    if (heightZoomFactor > 1.0) {
      widthZoomFactor = 1 / heightZoomFactor;
      heightZoomFactor = 1.0;
    }
  }

  Future flyThrough(CameraFlythroughStep target){
    _completeCurrentAction();
    _currentAction = CameraAction.flyTo;
    _currentFlythroughTarget = target;
    _currentTimeLeft = _currentFlythroughTarget.flyTimeSec;
    isInAction = true;
    _currentActionCompleter = Completer();
    return _currentActionCompleter.future;
  }

  void _completeCurrentAction(){
    if(_currentActionCompleter!=null && !_currentActionCompleter.isCompleted)
      _currentActionCompleter.complete();
    _currentAction = CameraAction.none;
    _currentFlythroughTarget = null;
    _currentTimeLeft = null;
    isInAction = false;
    _currentActionCompleter = null;
  }
}
