import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'screens/home/home_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  final initialSettings = await storageService.loadSettings();

  await NotificationService.instance.init();
  await NotificationService.instance.requestPermission();

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => SettingsNotifier(ref, initialSettings),
        ),
      ],
      child: const AniverssaryApp(),
    ),
  );
}

class AniverssaryApp extends ConsumerWidget {
  const AniverssaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      settingsProvider.select((settings) => settings.themeMode),
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Aniverssary',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.light(dynamicScheme: lightDynamic),
          darkTheme: AppTheme.dark(dynamicScheme: darkDynamic),
          home: const HomeScreen(),
        );
      },
    );
  }
}
