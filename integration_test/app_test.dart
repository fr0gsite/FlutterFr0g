import 'package:fr0gsite/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Web devices are not supported for integration tests yet.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('first test group', () {
    testWidgets('first test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text('Android'), findsWidgets);
      expect(find.text('Apple'), findsWidgets);
      expect(find.text('Windows'), findsWidgets);

      //await getLocalizations(tester).then((AppLocalizations localizations) {
      //  expect(localizations.iagree, 'I agree');
      //});

      expect(find.text('I agree'), findsWidgets);
      await tester.tap(find.text('I agree'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text('I agree'), findsNothing);
    });
  });
}

Future<AppLocalizations> getLocalizations(WidgetTester t) async {
  late AppLocalizations result;
  await t.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Material(
        child: Builder(
          builder: (BuildContext context) {
            result = AppLocalizations.of(context)!;
            debugPrint("Language: ${Localizations.localeOf(context)}");
            return Container();
          },
        ),
      ),
    ),
  );
  return result;
}
