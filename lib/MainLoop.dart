import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

class MainLoop extends Game{
  
  Size screenSize;

  bool hasWon = false;

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
  }

  void onTapDown(TapDownDetails d) {
    // Detect target

    // If HUD: react
    // If target is floor: go to
    // If target is actor:
    //    If actor is too far away: go to
    //    else: act
  }

  @override
  void render(Canvas canvas) {
    
    // Visible tiles: floor
    // Visible tiles: walls

    // Visible actors

    // Player

    // HUD

  }

  @override
  void update(double time) {
    // Player: going
    // Camera: adjust to player
  }
}

