import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/home/views/home_page.dart';

void main() {
  Future<void> _pumpMaterialAppWithHomePage(WidgetTester tester) =>
      tester.pumpWidget(const MaterialApp(home: HomePage()));

  group('HomePage', () {
    test("has a route named '/home'", () {
      expect(HomePage.routeName, '/home');
    });

    testWidgets("displays an 'AppBar' with title 'Home'",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithHomePage(tester);
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });
  });

  group('HomePage/Navigate to App Settings Button', () {
    Finder _findNavigatetoAppSettingsButton(WidgetTester tester) {
      return find.ancestor(
        of: find.text('Navigate to App Settings'),
        matching: find.byType(ElevatedButton),
      );
    }

    testWidgets("is displayed with text 'Navigate to App Settings'",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithHomePage(tester);
      expect(_findNavigatetoAppSettingsButton(tester), findsOneWidget);
    });
  });
}
