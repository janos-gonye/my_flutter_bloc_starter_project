import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

void main() {
  group('AppSettingsPage', () {
    test("has a route named '/app-settings'", () {
      expect(AppSettingsPage.routeName, '/app-settings');
    });
  });
}
