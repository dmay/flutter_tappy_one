import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';

class MainMenuButton extends SpriteComponent{
  
  String text;
  Rect tapRectangle;

  MainMenuButton(num x, num y, num width, num height, this.text, String imagePath)
    :super.rectangle(width, height, imagePath){
    this.angle = 0.0;
    this.x = x;
    this.y = y;
    this.tapRectangle = Rect.fromLTWH(this.x, this.y, this.width, this.height);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);
    //NOW Button - Daw text, if present
  }

  void OnTapDown(TapDownDetails d) {
    if(this.tapRectangle.contains(d.globalPosition)){
      //NOW Handle button click
    }
  }
  
}
  
class MainMenuScene extends SceneBase{

  List<MainMenuButton> mainButtons = List<MainMenuButton>();

  @override
  void initialize() {
    super.initialize();
    //NOW mainMenuButton.png
    mainButtons.add(
      MainMenuButton(10, 20, 100, 20, 'Start', 'mainMenuButton.png')
      );
  }

  void onTapDown(TapDownDetails d) {
    mainButtons.forEach((button) => button.OnTapDown(d));
  }

  void render(Canvas canvas) {
    // Background

    // Menu entries
    mainButtons.forEach((button) => button.render(canvas));

    // Random events
  }

  void update(double time) {
    // Random events
  }

}
