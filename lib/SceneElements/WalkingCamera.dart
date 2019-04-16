import 'dart:ui';
import 'package:meta/meta.dart';

class WalkingCamera {
  double sceneWidth;
  double sceneHeight;
  double zoom;
  double widthZoomFactor;
  double heightZoomFactor;
  double x;
  double y;
  bool isInAction;
  Size screenProportions;

  WalkingCamera(
      {@required this.sceneWidth,
      @required this.sceneHeight,
      this.zoom = 1.0,
      this.x = 0.0,
      this.y = 0.0,
      this.isInAction = false,
      this.screenProportions}) {
    updateZoomFactors();
  }

  void resize(Size size) {
    screenProportions = size;
    updateZoomFactors();
  }

  void update({@required double time, double targetX, double targetY}) {
    //NOW WalkingCamera.update
    //  keep target in the center box, shift own
    //  position only when target moves away
    //  if target moves away for > 3 sec - aim on it when it stoped
  }

  Rect getVisibleRect() {
    final visibleWidth = sceneWidth * zoom * widthZoomFactor;
    final visibleHeight = sceneHeight * zoom * heightZoomFactor;

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

  /*

     sceneWidth  * zoom * widthZoomFactor       screenProportions.width
    ---------------------------------------  = --------------------------
     sceneHeight * zoom * heightZoomFactor      screenProportions.height 

    
    widthZoomFactor = 1.0 =>

                        sceneWidth      screenProportions.height
    heightZoomFactor = ------------- * --------------------------
                        sceneHeight     screenProportions.width

  */

  void updateZoomFactors() {
    if (this.screenProportions == null) return;
    widthZoomFactor = 1.0;
    heightZoomFactor = (sceneWidth / sceneHeight) *
        (screenProportions.height / screenProportions.width);
    if (heightZoomFactor > 1.0) {
      widthZoomFactor = 1 / heightZoomFactor;
      heightZoomFactor = 1.0;
    }
  }
}
