import 'dart:ui';

class FpsCounter {
  static const String counterFontFamily = 'Alagard';
  static const Color counterTextColor = Color(0xffffffff);
  static const double counterTextSize = 26.0;

  Size screenSize;

  num thisSecondLeft = 1.0;
  int framesThisSecond = 0;
  int framesLastSecond = 0;

  void resize(Size size) {
    screenSize = size;
  }

  void update(double time) {
    if (framesLastSecond == 0 && time != 0.0)
      framesLastSecond = (1 / time).floor();
    thisSecondLeft -= time;
    if (thisSecondLeft < 0.0) {
      framesLastSecond = framesThisSecond;
      framesThisSecond = 0;
      thisSecondLeft = 1 + thisSecondLeft;
    }
  }

  void render(Canvas canvas) {
    framesThisSecond++;
    if(screenSize == null) return;
    var paragraph =
        new ParagraphBuilder(new ParagraphStyle(textAlign: TextAlign.left));
    paragraph.pushStyle(new TextStyle(
      fontFamily: counterFontFamily,
      color: counterTextColor,
      fontSize: counterTextSize,
    ));
    paragraph.addText('FPS $framesLastSecond');
    var p = paragraph.build()
        ..layout(new ParagraphConstraints(width: screenSize.width));
    final paragraphX = 0.0;
    final paragraphY = 0.0;
    canvas.restore();
    canvas.drawParagraph(p, new Offset(paragraphX, paragraphY));
    canvas.restore();
  }
}
