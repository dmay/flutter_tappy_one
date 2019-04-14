import 'package:tappy_one/Scenes/MainMenuScene.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:tappy_one/Scenes/WalkingDemoScene.dart';

class ScenesBuilder {

  static SceneBase getDefaultScene() => getFirstPlayScene();

  static SceneBase getMainMenuScene()
    => MainMenuScene(
      getFirstPlayScene,
      getSettingsScene
    );

  static SceneBase getFirstPlayScene()
    => WalkingDemoScene(
      getMainMenuScene
    );

  static SceneBase getSettingsScene(){
    //TODO getSettingsScene
    return null;
  }
  
}