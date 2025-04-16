import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class JumpstartGame extends FlameGame with TapDetector {
  late SpriteComponent background;
  late SpriteComponent bunny;

  Vector2 worldPosition = Vector2.zero();
  @override
  Future<void> onLoad() async {
    super.onLoad();

    background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(3500, 2000)
      ..position = Vector2.zero();
    add(background);

    bunny = SpriteComponent()
      ..sprite = await loadSprite('bunny.png')
      ..size = Vector2(230, 230)
      ..position = size / 2;
    add(bunny);

    addNavigationButtons();
  }

  void moveWorld(String direction) {
    const double moveDistance = 50;

    switch (direction) {
      case 'up':
        worldPosition.y += moveDistance;
        break;
      case 'down':
        worldPosition.y -= moveDistance;
        break;
      case 'left':
        worldPosition.x += moveDistance;
        break;
      case 'right':
        worldPosition.x -= moveDistance;
        break;
    }

    worldPosition.x = worldPosition.x.clamp(size.x - background.size.x, 0);
    worldPosition.y = worldPosition.y.clamp(size.y - background.size.y, 0);

    background.position = worldPosition;
  }

  void addNavigationButtons() {
    const double buttonSize = 60;
    const double padding = 10;

    void addButton(
        IconData arrowIcon, Vector2 position, void Function() onPressed) {
      add(ButtonWithIcon(
        size: Vector2(buttonSize, buttonSize),
        position: position,
        paint: Paint()..color = Colors.white.withOpacity(0.3),
        icon: arrowIcon,
        onPressed: onPressed,
      ));
    }

    addButton(
      Icons.keyboard_arrow_up,
      Vector2(size.x - buttonSize - padding * 5,
          size.y - buttonSize * 3 - padding * 2),
      () => moveWorld('up'),
    );

    addButton(
      Icons.keyboard_arrow_down,
      Vector2(size.x - buttonSize - padding * 5, size.y - buttonSize - padding),
      () => moveWorld('down'),
    );

    addButton(
      Icons.keyboard_arrow_left,
      Vector2(size.x - buttonSize * 2 - padding * 3,
          size.y - buttonSize * 2 - padding * 1.5),
      () => moveWorld('left'),
    );

    addButton(
      Icons.keyboard_arrow_right,
      Vector2(size.x - buttonSize - padding,
          size.y - buttonSize * 2 - padding * 1.5),
      () => moveWorld('right'),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    bunny.position = size / 2;
  }
}

class ButtonWithIcon extends HudButtonComponent {
  final IconData icon;

  ButtonWithIcon({
    required Vector2 size,
    required Vector2 position,
    required Paint paint,
    required this.icon,
    required VoidCallback onPressed,
  }) : super(
          position: position,
          button: CircleComponent(size: size, paint: paint),
          onPressed: onPressed,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the arrow icon
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size.x * 0.6,
          fontFamily: icon.fontFamily,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.x / 2 - textPainter.width / 2,
          size.y / 2 - textPainter.height / 2),
    );
  }
}

class CircleComponent extends PositionComponent {
  final Paint paint; // Paint for the circle

  CircleComponent({
    required Vector2 size,
    required this.paint,
  }) : super(size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}
