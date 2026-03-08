import 'package:flutter_test/flutter_test.dart';
import 'package:tasknest/main.dart';

void main() {
  testWidgets('TaskNest smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskNestApp());
    expect(find.byType(TaskNestApp), findsOneWidget);
  });
}
