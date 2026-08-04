import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aniverssary/main.dart';
import 'package:aniverssary/models/relationship_settings.dart';
import 'package:aniverssary/providers/settings_provider.dart';

void main() {
  testWidgets('Home screen shows the day counter', (
    WidgetTester tester,
  ) async {
    final settings = RelationshipSettings(
      startDate: DateTime.now().subtract(const Duration(days: 100)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith(
            (ref) => SettingsNotifier(ref, settings),
          ),
        ],
        child: const AniverssaryApp(),
      ),
    );
    await tester.pumpAndSettle();

    // "100 Days" legitimately appears twice: the big counter and the
    // milestone chip for the 100-day milestone, which is reached exactly.
    expect(find.textContaining('100 Days'), findsWidgets);
    expect(find.text('Together for'), findsOneWidget);
  });
}
