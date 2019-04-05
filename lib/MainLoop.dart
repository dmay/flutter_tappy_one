import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

class MainLoop extends Game{

  void initialize() {
    // (1)  Load map
    // (16) Spawn actors
    // (2)  Spawn player
    // (3)  Position camera
    // (4)  Camera.FlyTo target
  }

  Size screenSize;

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
  }

  void onTapDown(TapDownDetails d) {
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

