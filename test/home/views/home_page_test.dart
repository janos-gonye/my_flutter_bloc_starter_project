import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/home/views/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets("has an AppBar", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
  group('HomePage/AppBar', () {
    testWidgets("has a title 'Home'", (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });
  });
}
