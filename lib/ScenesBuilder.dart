import 'package:tappy_one/Scenes/MainMenuScene.dart';
import 'package:tappy_one/Scenes/SceneBase.dart';
import 'package:tappy_one/Scenes/WalkingDemoScene.dart';

class ScenesBuilder {

  static SceneBase getDefaultScene() => getMainMenuScene();

  static SceneBase getMainMenuScene()
    => MainMenuScene(
      getFirstPlayScene,
      getSettingsScene
    );

  static SceneBase getFirstPlayScene()
    => WalkingDemoScene(
    );

  static SceneBase getSettingsScene(){
    //NOW+1 getSettingsScene
    return null;
  }
  
}