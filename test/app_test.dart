import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/home/views/home_page.dart';

void main() {
  Future<void> _pumpMaterialAppwithAppView(WidgetTester tester) {
    return tester.pumpWidget(const MaterialApp(home: HomePage()));
  }

  group("AppView", () {
    testWidgets("displays 'HomePage' as home page",
        (WidgetTester tester) async {
      await _pumpMaterialAppwithAppView(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
