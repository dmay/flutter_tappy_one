import 'dart:ui';

import 'package:flame/game.dart';

class MainLoop extends Game{
  
  Size screenSize;

  @override
  void resize(Size size) {
    super.resize(size);
    screenSize = size;
  }

  @override
  void render(Canvas canvas) {
    
    // Background
    var bg_rectangle = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    var bg_paint = Paint();
    bg_paint.color = Color(0xff1c6ced);
    canvas.drawRect(bg_rectangle, bg_paint);

    // Target
    double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    Rect boxRect = Rect.fromLTWH(
      screenCenterX - 75,
      screenCenterY - 75,
      150,
      150
    );
    Paint boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    canvas.drawRect(boxRect, boxPaint);    

  }

  @override
  void update(double t) {
    // TODO: implement update
  }

}
