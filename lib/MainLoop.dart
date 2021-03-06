import 'dart:collection';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:tappy_one/ScenesBuilder.dart';

class MainLoop extends Game{

  Size screenSize;
  SceneBase activeScene;

  void initialize() {
    openScene(ScenesBuilder.getDefaultScene);
    // Something something load game state? Or load it on first touch of actual game scene?
  }

   /* Main methods */

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
    activeScene?.resize(size);
  }

  @override
  void render(Canvas canvas)
    => activeScene?.render(canvas);

  @override
  void update(double time)
    => activeScene?.update(time);

  /* Events 'routing' */

  TapDownDetails _lastTapDownDetails;

  void onTapDown(TapDownDetails details) {
    activeScene?.onTapDown(details);
    _lastTapDownDetails = details;
  }

  void onTap() => activeScene?.onTap(_lastTapDownDetails); 

  void onTapUp(TapUpDetails details) => activeScene?.onTapUp(details);

  void onTapCancel() => activeScene?.onTapCancel();

  void onPanStart(DragStartDetails details) => activeScene?.onPanStart(details);

  void onPanUpdate(DragUpdateDetails details) => activeScene?.onPanUpdate(details);

  void onPanEnd(DragEndDetails details) => activeScene?.onPanEnd(details);

  /* Scenes navigation */

  Queue scenesStack = Queue();

  Future switchSceneTo(Function buildNextScene) async {
    final scene = await buildAndSetupScene(buildNextScene);
    final previousScene = activeScene;
    previousScene?.setInactive();
    activeScene = scene;
    activeScene.setActive();
    previousScene?.destroy();
  }

  Future openScene(Function buildNewScene) async {
    final scene = await buildAndSetupScene(buildNewScene);
    if(activeScene != null){
        scenesStack.addLast(activeScene);
        activeScene.setInactive();
    }
    activeScene = scene;
    if(screenSize!=null && activeScene.screenSize == null)  // Happend when first scene.initialize is very long
      activeScene.resize(this.screenSize);
    activeScene.setActive();
  }

  void closeScene(SceneBase scene){
    if(scene == activeScene){
      scene.setInactive();
      if(scenesStack.isNotEmpty){
        activeScene = scenesStack.removeLast();
        activeScene.setActive();
      }
      scene.destroy();
    }
    else{
      if(scenesStack.contains(scene))
        scenesStack.remove(scene);
      scene.setInactive();
      scene.destroy();
    }
  }

  Future<SceneBase> buildAndSetupScene(Function buildScene) async{
    final SceneBase scene = buildScene();
    if(scene == null)
      throw Exception('scene builder delegate returned null');
    await scene.initialize();
    if(screenSize != null)
      scene.resize(screenSize);
    scene.switchSceneTo = this.switchSceneTo;
    scene.openScene = this.openScene;
    scene.closeScene = () => this.closeScene(scene);
    return scene;
  }
}
