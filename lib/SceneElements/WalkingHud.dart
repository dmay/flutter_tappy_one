import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/src/gestures/tap.dart';

class WalkingHud{

  Size screenSize;

  Image gearClosedImage;
  double gearClosedRadius;
  Rect gearClosedRect;
  Rect gearClosedScreen;

  Image gearOpenImage;
  double gearOpenRadius;
  Rect gearOpenRect;
  Rect gearOpenScreen;

  double gearBottomOffset;

  Image closePanelImage;

  Paint imagePaint = BasicPalette.white.paint;

  Future initialize() async {
    // Load images
    //NOW 2D Partial Gear icon
    this.gearClosedImage = await Flame.images.load('hudSwitch.png');
    this.gearClosedRect  = Rect.fromLTWH(0.0, 0.0, gearClosedImage.width.toDouble(), gearClosedImage.height.toDouble());
    this.gearOpenImage   = await Flame.images.load('hudSwitch.png');
    this.gearOpenRect  = Rect.fromLTWH(0.0, 0.0, gearOpenImage.width.toDouble(), gearOpenImage.height.toDouble());
    this.closePanelImage = await Flame.images.load('quit.png');
  }

  void resize(Size screenSize) {
    this.screenSize = screenSize;
    if(screenSize == null) return;
    this.gearClosedRadius = min(screenSize.height * 0.08,  40.0);
    this.gearOpenRadius   = min(screenSize.height * 0.10,  50.0);
    this.gearBottomOffset = min(screenSize.height * 0.10,  50.0);
    this.gearClosedScreen = Rect.fromLTWH(0.0, screenSize.height-gearBottomOffset-gearClosedRadius, 
      gearClosedRadius*2*gearClosedImage.width/gearClosedImage.height, 
      gearClosedRadius*2);
    this.gearOpenScreen   = Rect.fromLTWH(0.0, screenSize.height-gearBottomOffset-gearOpenRadius, 
      gearOpenRadius*2*gearOpenImage.width/gearOpenImage.height, 
      gearOpenRadius*2);
  }

  bool panelIsOpen = false;

  bool onTap(TapDownDetails details) {
    if(screenSize == null) return false;
    //NOW onTap - switch state
    return false;
  }

  void update(double time) {
    if(screenSize == null) return;
  }

  void render(Canvas canvas) {
    //NOW render - pass 'debug' parameter, render tap areas
    if(screenSize == null) return;
    if(panelIsOpen){
      canvas.drawImageRect(gearOpenImage, gearOpenRect, gearOpenScreen, imagePaint);
    }
    else{
      canvas.drawImageRect(gearClosedImage, gearClosedRect, gearClosedScreen, imagePaint);
    }
  }
  
}