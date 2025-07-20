import 'package:fr0gsite/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('web disclaimer test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Android'), findsWidgets);
    expect(find.text('Apple'), findsWidgets);
    expect(find.text('Windows'), findsWidgets);
    expect(find.text('I agree'), findsWidgets);

    await tester.tap(find.text('I agree'));
    await tester.pumpAndSettle();

    expect(find.text('I agree'), findsNothing);
  });
}
