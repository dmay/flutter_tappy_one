import 'dart:async';
import 'dart:ui';

enum PlayerAction{
  none,
  walkTo,
}

class WalkingPlayer{
  
  double x;
  double y;
  double speed;

  WalkingPlayer({this.x, this.y, this.speed = 64.0});

  Size screenSize;

  void resize(Size size) {
    screenSize = size;
  }

  void update(double time){
    switch(_currentAction){
      case PlayerAction.none:
        // Do nothing
        break;
      case PlayerAction.walkTo:
        // TODO: Handle this case.
        final walked = speed * time;
        final path = Offset(_currentWalkToTarget.dx-x, _currentWalkToTarget.dy-y);
        final distance = path.distance;
        if(distance <= walked){
          x = _currentWalkToTarget.dx;
          y = _currentWalkToTarget.dy;
          completeCurrentAction();
        }
        else{
          x += path.dx * walked / distance;
          y += path.dy * walked / distance;
        }
        break;
    }
  }

  void render(Canvas canvas, Rect visibleRect) {
    if(screenSize == null) return;
    // NOW (02) player.render with real sprites and animation

    final screenX = screenSize.width * (this.x-visibleRect.left)/visibleRect.width;
    final screenY = screenSize.height * (this.y-visibleRect.top)/visibleRect.height;
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

  Future walkTo(num targetX, num targetY){
    completeCurrentAction();
    _currentAction = PlayerAction.walkTo;
    _currentWalkToTarget = Offset(targetX, targetY);
    _currentTimeLeft = null;
    isInAction = true;
    _currentActionCompleter = Completer();
    return _currentActionCompleter.future;    
  }

  void completeCurrentAction(){
    if(_currentActionCompleter!=null && !_currentActionCompleter.isCompleted)
      _currentActionCompleter.complete();
    _currentAction = PlayerAction.none;
    _currentWalkToTarget = null;
    _currentTimeLeft = null;
    isInAction = false;
    _currentActionCompleter = null;
  }  
  
}