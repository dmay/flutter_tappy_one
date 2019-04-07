import 'package:tappy_one/Scenes/MainMenuScene.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';

class ScenesBuilder {

  static SceneBase getDefaultScene() {
    final scene = MainMenuScene();
    return scene;
  }
  
}