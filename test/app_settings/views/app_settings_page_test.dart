import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

void main() {
  Future<void> _pumpMaterialAppWithAppSettingsPage(WidgetTester tester) =>
      tester.pumpWidget(const MaterialApp(home: AppSettingsPage()));

  group('AppSettingsPage', () {
    test("has a route named '/app-settings'", () {
      expect(AppSettingsPage.routeName, '/app-settings');
    });

    testWidgets("displays an 'AppBar' with title 'Application Settings'",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithAppSettingsPage(tester);
      expect(
          find.widgetWithText(AppBar, 'Application Settings'), findsOneWidget);
    });
  });
}
