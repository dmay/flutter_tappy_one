import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';

class MainMenuButton extends SpriteComponent{
  
  String text;
  Rect tapRectangle;

  //NOW mainMenuButton.png
  MainMenuButton(num x, num y, this.text):super.rectangle(100, 20, 'mainMenuButton.png'){
    this.angle = 0.0;
    this.x = x;
    this.y = y;
    this.tapRectangle = Rect.fromLTWH(this.x, this.y, this.width, this.height);
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
    mainButtons.add(MainMenuButton(10,20, 'Start'));
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
