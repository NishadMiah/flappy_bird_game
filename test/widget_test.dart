import 'package:flame/game.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flappy Bird Pro game widget smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our GameWidget is loaded.
    expect(find.byType(GameWidget<FlappyBirdGame>), findsOneWidget);
  });
}
