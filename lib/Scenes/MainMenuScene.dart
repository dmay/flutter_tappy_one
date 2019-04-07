import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';

class MainMenuButton extends SpriteComponent {
  static const String menuButtonFontFamily = 'Alagard';
  static const Color menuButtonTextColor = Color(0xff040B74);
  static const double menuButtonTextSize = 32.0;

  String text;
  Rect tapRectangle;

  Function handler;

  MainMenuButton(double x, double y, double width, double height, this.text,
      String imagePath, this.handler)
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

  void onTapDown(TapDownDetails d) {
    if (this.tapRectangle.contains(d.globalPosition))
      handler();
  }
}

class MainMenuScene extends SceneBase {
  List<MainMenuButton> mainButtons = List<MainMenuButton>();

  Function goToPlay;
  Function openSettings;

  MainMenuScene(this.goToPlay, this.openSettings){}

  @override
  void resize(Size size) {
    super.resize(size);
    _renderMenuButtons();
  }

  @override
  Future initialize() async {
    await super.initialize();
    _renderMenuButtons();
  }

  void _renderMenuButtons() {
    if(screenSize == null) return;  // Do not render buttons until we get screen size info

    mainButtons.clear();
    final tileWidth = screenSize.width / 8;
    final tileHeight = tileWidth * 1.1;
    final verticalCenter = screenSize.height / 2;
    final buttonWidth = tileWidth * 6;
    final buttonHeight = tileWidth * 2;
    mainButtons.add(MainMenuButton(
          tileWidth,  verticalCenter - tileHeight * 2,
          buttonWidth, buttonHeight, 
          'Play', 'mainMenuButton.png',
          () => switchSceneTo(goToPlay)
          ));
    mainButtons.add(MainMenuButton(
          tileWidth,  verticalCenter,
          buttonWidth, buttonHeight, 
          'Settings', 'mainMenuButton.png',
          () => openScene(openSettings)
          ));
  }

  void onTapDown(TapDownDetails d) {
    mainButtons.forEach((button) => button.onTapDown(d));
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
