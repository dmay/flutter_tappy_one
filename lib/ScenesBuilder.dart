import 'package:tappy_one/Scenes/MainMenuScene.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';

class ScenesBuilder {

  static SceneBase getDefaultScene() {
    final scene = MainMenuScene(
      getFirstPlayScene,
      getSettingsScene
    );
    return scene;
  }

  static SceneBase getFirstPlayScene(){
    //NOW+1 getFirstPlayScene
    return null;
  }

  static SceneBase getSettingsScene(){
    //NOW+1 getSettingsScene
    return null;
  }
  
}