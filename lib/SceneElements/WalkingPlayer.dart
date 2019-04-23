import 'dart:async';
import 'dart:ui';
import 'package:flame/animation.dart';
import 'package:flame/flame.dart';
import 'package:tiled/tiled.dart' as Tiled;

enum PlayerAction {
  none,
  walkTo,
}

enum PlayerLookingDirection {
  up,
  down,
  left,
  right,
}

class WalkingPlayer {
  static const String spriteSheetFile = 'player.png';

  double x;
  double y;
  double speed;

  Tiled.Layer pass;

  Image spriteSheet;

  Map animationsIdle;
  Map animationsWalking;

  PlayerLookingDirection _currentDirection;
  Animation _currentAnimation;

  WalkingPlayer({this.x, this.y, this.speed = 64.0, this.pass});

  Future initialize() async {
    this.spriteSheet = await Flame.images.load(spriteSheetFile);

    this.animationsIdle = {
      PlayerLookingDirection.up: Animation.sequenced(spriteSheetFile, 1,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 24,
          textureY: 0,
          stepTime: 0.2),
      PlayerLookingDirection.right: Animation.sequenced(spriteSheetFile, 1,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 24,
          textureY: 32,
          stepTime: 0.2),
      PlayerLookingDirection.down: Animation.sequenced(spriteSheetFile, 1,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 24,
          textureY: 64,
          stepTime: 0.2),
      PlayerLookingDirection.left: Animation.sequenced(spriteSheetFile, 1,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 24,
          textureY: 96,
          stepTime: 0.2),
    };

    this.animationsWalking = {
      PlayerLookingDirection.up: Animation.sequenced(spriteSheetFile, 3,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 0,
          textureY: 0,
          stepTime: 0.2),
      PlayerLookingDirection.right: Animation.sequenced(spriteSheetFile, 3,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 0,
          textureY: 32,
          stepTime: 0.2),
      PlayerLookingDirection.down: Animation.sequenced(spriteSheetFile, 3,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 0,
          textureY: 64,
          stepTime: 0.2),
      PlayerLookingDirection.left: Animation.sequenced(spriteSheetFile, 3,
          textureWidth: 24,
          textureHeight: 32,
          textureX: 0,
          textureY: 96,
          stepTime: 0.2),
    };

    this._currentDirection = PlayerLookingDirection.down;
    this._currentAnimation = animationsIdle[_currentDirection];
  }

  Size screenSize;

  void resize(Size size) {
    screenSize = size;
  }

  void update(double time) {
    switch (_currentAction) {
      case PlayerAction.none:
        // Do nothing
        break;
      case PlayerAction.walkTo:
        final walked = speed * time;
        final path =
            Offset(_currentWalkToTarget.dx - x, _currentWalkToTarget.dy - y);
        final distance = path.distance;
        if (distance <= walked) {
          x = _currentWalkToTarget.dx;
          y = _currentWalkToTarget.dy;
          completeCurrentAction();
        } else {
          x += path.dx * walked / distance;
          y += path.dy * walked / distance;
        }
        break;
    }

    _currentAnimation?.update(time);
  }

  void render(Canvas canvas, Rect visibleRect) {
    if (screenSize == null) return;
    final sprite = _currentAnimation?.getSprite();
    if (sprite == null) return;

    final factorX = screenSize.width / visibleRect.width;
    final factorY = screenSize.height / visibleRect.height;

    final screenX = (this.x - visibleRect.left) * factorX;
    final screenY = (this.y - visibleRect.top) * factorY;

    final screenWidth = sprite.size.x * factorX;
    final screenHeight = sprite.size.y * factorY;
    canvas.translate(screenX - screenWidth / 2, screenY - screenHeight);
    sprite.render(canvas, screenWidth, screenHeight);
    final markerPaint = Paint()
      ..color = Color(0xFFDE431F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.restore();
    canvas.drawCircle(Offset(screenX, screenY), 20, markerPaint);
    canvas.restore();
  }

  PlayerAction _currentAction = PlayerAction.none;
  Offset _currentWalkToTarget;
  Completer _currentActionCompleter;
  num _currentTimeLeft = 0.0;

  bool isInAction = false;

  Future walkTo(num targetX, num targetY) {
    goTo(targetX, targetY);
    _currentActionCompleter = Completer();
    return _currentActionCompleter.future;
  }

  void goTo(num targetX, num targetY) {
    completeCurrentAction();
    _currentAction = PlayerAction.walkTo;
    _currentWalkToTarget = Offset(targetX, targetY);
    _currentTimeLeft = null;
    isInAction = true;
    _currentDirection = getDirection(this.x, this.y, targetX, targetY);
    _currentAnimation = animationsWalking[_currentDirection];
    _currentActionCompleter = null;
  }

  void stopWalking() {
    if(_currentAction == PlayerAction.walkTo)
      completeCurrentAction();
  }

  void completeCurrentAction() {
    if (_currentActionCompleter != null && !_currentActionCompleter.isCompleted)
      _currentActionCompleter.complete();
    _currentAction = PlayerAction.none;
    _currentWalkToTarget = null;
    _currentTimeLeft = null;
    isInAction = false;
    _currentAnimation = animationsIdle[_currentDirection];
    _currentActionCompleter = null;
  }

  static PlayerLookingDirection getDirection(double fromX, double fromY, num toX, num toY) {
    final dx = toX - fromX;
    final dy = toY - fromY;
    if (dx > dy && dx >= -dy) return PlayerLookingDirection.right;
    if (dx < dy && dx >= -dy) return PlayerLookingDirection.down;
    if (dx < dy && dx <= -dy) return PlayerLookingDirection.left;
    return PlayerLookingDirection.up;
  }
}
