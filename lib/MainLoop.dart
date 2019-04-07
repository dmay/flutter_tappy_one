import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:tappy_one/ScenesBuilder.dart';

class MainLoop extends Game{

  SceneBase activeScene;

  void initialize() {
    activeScene = ScenesBuilder.getDefaultScene();
    activeScene.initialize();
    // Something something load game state? Or load it on first touch of actual game scene?
  }

  @override
  void resize(Size size) {
    super.resize(size);
    activeScene?.resize(size);
  }

  void onTapDown(TapDownDetails d) 
    => activeScene?.onTapDown(d);

  @override
  void render(Canvas canvas)
    => activeScene?.render(canvas);

  @override
  void update(double time)
    => activeScene?.update(time);

}
