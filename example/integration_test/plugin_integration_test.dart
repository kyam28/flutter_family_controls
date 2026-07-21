// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_family_controls/flutter_family_controls.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isSupported returns without throwing', (
    WidgetTester tester,
  ) async {
    // Screen Time is only available on iOS 16+ real devices, so the value
    // depends on the host. Just assert the call completes with a bool.
    final bool supported = await FlutterFamilyControls.isSupported();
    expect(supported, isA<bool>());
  });
}
