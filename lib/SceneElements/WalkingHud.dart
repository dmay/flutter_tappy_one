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
  Offset gearClosedCenter;

  Image gearOpenImage;
  double gearOpenRadius;
  Rect gearOpenRect;
  Rect gearOpenScreen;
  Offset gearOpenCenter;

  double gearBottomOffset;

  Image closePanelImage;

  Paint imagePaint = BasicPalette.white.paint;
  Paint debugPaint = Paint()
      ..color = Color(0xFFDE1FCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

  Future initialize() async {
    // Load images
    this.gearClosedImage = await Flame.images.load('hudSwitch.png');
    this.gearClosedRect  = Rect.fromLTWH(0.0, 0.0, gearClosedImage.width.toDouble(), gearClosedImage.height.toDouble());
    this.gearOpenImage   = await Flame.images.load('hudSwitch.png');
    this.gearOpenRect  = Rect.fromLTWH(0.0, 0.0, gearOpenImage.width.toDouble(), gearOpenImage.height.toDouble());
    this.closePanelImage = await Flame.images.load('quit.png');
  }

  void resize(Size screenSize) {
    this.screenSize = screenSize;
    if(screenSize == null) return;
    
    // Update gears positions
    this.gearClosedRadius = min(screenSize.height * 0.08,  40.0);
    this.gearOpenRadius   = min(screenSize.height * 0.10,  50.0);
    this.gearBottomOffset = min(screenSize.height * 0.10,  50.0);
    this.gearClosedScreen = Rect.fromLTWH(0.0, screenSize.height-gearBottomOffset-gearClosedRadius, 
      gearClosedRadius*2*gearClosedImage.width/gearClosedImage.height, 
      gearClosedRadius*2);
    this.gearOpenScreen   = Rect.fromLTWH(0.0, screenSize.height-gearBottomOffset-gearOpenRadius, 
      gearOpenRadius*2*gearOpenImage.width/gearOpenImage.height, 
      gearOpenRadius*2);
    this.gearClosedCenter = Offset(gearClosedScreen.right-gearClosedRadius, gearClosedScreen.top+gearClosedRadius);
    this.gearOpenCenter = Offset(gearOpenScreen.right-gearOpenRadius, gearOpenScreen.top+gearOpenRadius);
    
    // Update panel position
  }

  bool panelIsOpen = false;

  bool onTap(TapDownDetails details) {
    if(screenSize == null) return false;
    if(panelIsOpen){
      // Open panel
      // Open Gear
      if(distanceIsBelow(details.globalPosition, gearOpenCenter, gearOpenRadius)){
        panelIsOpen = false;
        // NEXT Launch closing animation
        return true;
      }
      // panelButtons.first((button) => button.onTap(details));
      // NOW 'Go to menu' button tap
      // Panel back
    }
    else{
      // Closed gear
      if(distanceIsBelow(details.globalPosition, gearClosedCenter, gearClosedRadius)){
        panelIsOpen = true;
        // NEXT Launch opening animation
        return true;
      }
    }
    return false;
  }

  bool distanceIsBelow(Offset a, Offset b, double radius) {
    return (a-b).distanceSquared < radius*radius;
  }

  void update(double time) {
    if(screenSize == null) return;
  }

  void render(Canvas canvas, bool debug) {
    if(screenSize == null) return;
    if(panelIsOpen){
      canvas.drawImageRect(gearOpenImage, gearOpenRect, gearOpenScreen, imagePaint);
      //NOW HUD - Render open panel with 'Go to menu' button
      // canvas.save();
      // canvas.translate(panelOffset.dx, panelOffset.dy);
      // canvas.drawRRect(panelRRect, panelBackgroundPaint);
      // canvas.drawRRect(panelRRect, panelBorderPaint);
      // panelButtons.forEach((button) => button.render(canvas));
      // canvas.restore();
      if(debug)
        canvas.drawCircle(gearOpenCenter, gearOpenRadius, debugPaint);
    }
    else{
      canvas.drawImageRect(gearClosedImage, gearClosedRect, gearClosedScreen, imagePaint);
      if(debug)
        canvas.drawCircle(gearClosedCenter, gearClosedRadius, debugPaint);
    }
  }
  
}
