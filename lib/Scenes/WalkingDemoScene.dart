import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';

class WalkingDemoScene extends SceneBase{

  Function goToMainMenu;

  WalkingDemoScene(this.goToMainMenu){}

  @override
  void initialize() {
    // (1)  Load map
    // (16) Spawn actors
    // (2)  Spawn player
    // (3)  Position camera
    // (4)  Camera.FlyTo target
  }
  bool hasWon = false;

  @override
  void onTapDown(TapDownDetails d) {
     double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    final newHasWon = d.globalPosition.dx >= screenCenterX - 75
      && d.globalPosition.dx <= screenCenterX + 75
      && d.globalPosition.dy >= screenCenterY - 75
      && d.globalPosition.dy <= screenCenterY + 75;
    if(hasWon && newHasWon)
      switchSceneTo(goToMainMenu);
    hasWon = newHasWon;
    // (5)  Check if interaction enabled

    // (11) Detect target

    // (15) If HUD: react
    // (12) If target is floor: go to
    //      If target is actor:
    // (18)   If actor is too far away: go to
    // (19)   else: act
  }

  @override
  void render(Canvas canvas) {
      var bg_rectangle = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    var bg_paint = Paint();
    bg_paint.color = Color(0xff1c6ced);
    canvas.drawRect(bg_rectangle, bg_paint);
  double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    Rect boxRect = Rect.fromLTWH(
      screenCenterX - 75,
      screenCenterY - 75,
      150,
      150
    );
    Paint boxPaint = Paint();
    boxPaint.color = hasWon
      ? Color(0xff00ff00)
      : Color(0xffffffff);
    canvas.drawRect(boxRect, boxPaint); 
    // (8) Visible tiles: floor
    // (9) Visible tiles: walls

    // (17) Visible actors

    // (10) Player

    // (14) HUD

  }

  @override
  void update(double time) {
    // (13) Player: going
    // (6)  Camera: fly OR adjust to player
    // (7)  If camera is not flying and on player and interaction is disabled: enable interaction
  }
}

