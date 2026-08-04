import 'package:flutter/material.dart';

/// App-wide theme definitions. Falls back to a pink/red seed color when
/// Material You dynamic color is unavailable on the device.
class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFFE91E63);
  static const Color darkBackground = Color(0xFF121212);

  static ThemeData light({ColorScheme? dynamicScheme}) {
    final scheme = (dynamicScheme ??
            ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.light,
            ))
        .copyWith(brightness: Brightness.light);

    return _buildTheme(scheme, background: Colors.white);
  }

  static ThemeData dark({ColorScheme? dynamicScheme}) {
    final scheme = (dynamicScheme ??
            ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.dark,
            ))
        .copyWith(brightness: Brightness.dark);

    return _buildTheme(scheme, background: darkBackground);
  }

  static ThemeData _buildTheme(ColorScheme scheme, {required Color background}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w500),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
