import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:flutter/foundation.dart';

class MainMenuButton extends SpriteComponent {
  static const String menuButtonFontFamily = 'Alagard';
  static const Color menuButtonTextColor = Color(0xff040B74);
  static const double menuButtonTextSize = 32.0;

  String text;
  Rect tapRectangle;

  MainMenuButton(double x, double y, double width, double height, this.text,
      String imagePath)
      : super.rectangle(width, height, imagePath) {
    this.angle = 0.0;
    this.x = x;
    this.y = y;
    this.tapRectangle = Rect.fromLTWH(this.x, this.y, this.width, this.height);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (this.text != null && this.text != '') {
      var paragraph = new ParagraphBuilder(new ParagraphStyle(textAlign: TextAlign.center));
      paragraph.pushStyle(new TextStyle(
          fontFamily: menuButtonFontFamily,
          color: menuButtonTextColor,
          fontSize: menuButtonTextSize,));
      paragraph.addText(this.text);
      var p = paragraph.build()
        ..layout(new ParagraphConstraints(width: this.width));
      final paragraphX = (this.width - p.width) / 2;
      final paragraphY = (this.height - p.height) / 2;
      canvas.drawParagraph(p, new Offset(paragraphX, paragraphY));
      canvas.restore();
    }
  }

  void OnTapDown(TapDownDetails d) {
    if (this.tapRectangle.contains(d.globalPosition)) {
      debugPrint('tap match!');
      //NOW Handle button click
    }
  }
}

class MainMenuScene extends SceneBase {
  List<MainMenuButton> mainButtons = List<MainMenuButton>();

  @override
  void resize(Size size) {
    super.resize(size);
    _renderMenuButtons();
  }

  @override
  void initialize() {
    super.initialize();
  }

  void _renderMenuButtons() {
    mainButtons.clear();
    final tileWidth = screenSize.width / 8;
    final tileHeight = tileWidth * 1.1;
    final verticalCenter = screenSize.height / 2;
    final buttonWidth = tileWidth * 6;
    final buttonHeight = tileWidth * 2;
    mainButtons.add(MainMenuButton(
          tileWidth,  verticalCenter - tileHeight * 2,
          buttonWidth, buttonHeight, 
          'Play', 'mainMenuButton.png'));
    mainButtons.add(MainMenuButton(
          tileWidth,  verticalCenter,
          buttonWidth, buttonHeight, 
          'Reset', 'mainMenuButton.png'));
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
