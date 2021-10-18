import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/login/login.dart';

void main() {
  Future<void> _pumpMaterialAppWithLoginPage(WidgetTester tester) =>
      tester.pumpWidget(const MaterialApp(home: LoginPage()));

  group('LoginPage', () {
    test("has a route named '/login'", () {
      expect(LoginPage.routeName, '/login');
    });

    testWidgets("displays an 'AppBar' with title 'Login'",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithLoginPage(tester);
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    });
  });
}
