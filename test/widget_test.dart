import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/app/app.dart';

void main() {
  testWidgets('StudyFlow application starts correctly', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const StudyFlowApp());

    expect(find.text('StudyFlow'), findsWidgets);
  });
}