import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/app.dart';

void main() {
  testWidgets('Perch app builds', (tester) async {
    await tester.pumpWidget(const PerchTodaySceneApp());
    await tester.pump();

    expect(find.byType(PerchTodaySceneApp), findsOneWidget);
  });
}
