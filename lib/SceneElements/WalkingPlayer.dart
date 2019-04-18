import 'dart:ui';

class WalkingPlayer{
  
  double x;
  double y;

  WalkingPlayer(this.x, this.y);

  Size screenSize;

  void resize(Size size) {
    screenSize = size;
  }

  void render(Canvas canvas, Rect visibleRect) {
    if(screenSize == null) return;
    // NOW player.render

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
  
}