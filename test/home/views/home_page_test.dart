import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/login/login.dart';

void main() {
  Future<void> _pumpMaterialAppWithHomePage(WidgetTester tester) =>
      tester.pumpWidget(const MaterialApp(home: HomePage()));

  group('HomePage', () {
    test("has a route named '/'", () {
      expect(HomePage.routeName, '/');
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

    testWidgets("navigates to 'AppSettingsPage' after pushed",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithHomePage(tester);
      final finder = _findNavigatetoAppSettingsButton(tester);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(AppSettingsPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });
  });

  group('HomePage/Navigate to Login Page Button', () {
    Finder _findNavigatetoLoginButton(WidgetTester tester) {
      return find.ancestor(
        of: find.text('Navigate to Login Page'),
        matching: find.byType(ElevatedButton),
      );
    }

    testWidgets("is displayed with text 'Navigate to Login Page'",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithHomePage(tester);
      expect(_findNavigatetoLoginButton(tester), findsOneWidget);
    });

    testWidgets("navigates to 'LoginPage' after pushed",
        (WidgetTester tester) async {
      await _pumpMaterialAppWithHomePage(tester);
      final finder = _findNavigatetoLoginButton(tester);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(find.byType(AppSettingsPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });
  });
}
