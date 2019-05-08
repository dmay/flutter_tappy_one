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
  int tilesetWidth;
  int tilesetHeight;
  double tilesetTileWidth;
  double tilesetTileHeight;

  Image spriteSheet;

  Map animationsIdle;
  Map animationsWalking;

  PlayerLookingDirection _currentDirection;
  Animation _currentAnimation;

  WalkingPlayer({this.x, this.y, this.speed = 64.0, this.pass, 
    this.tilesetHeight,this.tilesetWidth,
    this.tilesetTileWidth, this.tilesetTileHeight});

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
        final path = Offset(_currentWalkToTarget.dx - x, _currentWalkToTarget.dy - y);
        final distance = path.distance;
        if (distance <= walked) {
          x = _currentWalkToTarget.dx;
          y = _currentWalkToTarget.dy;
          completeCurrentAction();
        } else {
          final newX = x + path.dx * walked / distance;
          final newY = y + path.dy * walked / distance;
          if(canMoveTo(newX, newY)){
            x = newX;
            y = newY;
          }
          else{ // Can't move farther
            completeCurrentAction();
          }
        }
        break;
    }

    _currentAnimation?.update(time);
  }

  bool canMoveTo(double newX, double newY){
    // Find tile
    final mapX = (newX / tilesetTileWidth).floor();
    final mapY = (newY / tilesetTileHeight).floor();
    final tileId = pass.tileMatrix[mapY][mapX] - 1;
    
    // Simple cases - empty, and full
    if(tileId == -1) return true;
    if(tileId == 990) return false;
    
    // Find in-tile coords and quadrant
    final tileX = (newX % tilesetTileWidth).floor();
    final tileY = (newY % tilesetTileHeight).floor();
    final quadrant = getTileQuadrant(tileX, tileY);

    // Match cornered tiles
    if(tileId ==  894) return quadrant == 4;
    if(tileId ==  895) return quadrant == 3;
    if(tileId ==  926) return quadrant == 2;
    if(tileId ==  927) return quadrant == 1;

    if(tileId ==  957) return quadrant != 4;
    if(tileId ==  959) return quadrant != 3;
    if(tileId == 1021) return quadrant != 2;
    if(tileId == 1023) return quadrant != 1;

    // Match halves tiles
    if(tileId ==  958) return quadrant == 1 || quadrant == 2;
    if(tileId ==  989) return quadrant == 1 || quadrant == 3;
    if(tileId ==  991) return quadrant == 2 || quadrant == 4;
    if(tileId == 1022) return quadrant == 3 || quadrant == 4;
    
    return true;
  }

  int getTileQuadrant(int tileX, int tileY){
    final halfTileWidth = (tilesetTileWidth/2).floor();
    final halfTileHeight = (tilesetTileHeight/2).floor();
    if(tileX <  halfTileWidth && tileY <  halfTileHeight) return 1;
    if(tileX >= halfTileWidth && tileY <  halfTileHeight) return 2;
    if(tileX <  halfTileWidth && tileY >= halfTileHeight) return 3;
    return 4;
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
    //NOW+1 Path-finding. Limit radius for user input.
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
