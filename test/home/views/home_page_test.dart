import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/home/views/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets("displays an AppBar with title 'Home'",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });

    testWidgets(
        "displays an 'ElevatedButton' with text 'Navigate to App Settings'",
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(
        find.ancestor(
          of: find.text('Navigate to App Settings'),
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );
    });
  });
}
