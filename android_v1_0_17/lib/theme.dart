import 'package:flutter/material.dart';

class KfColors {
  static const ink = Color(0xFF111B2E);
  static const emerald = Color(0xFF087F83);
  static const teal = Color(0xFF12A89A);
  static const gold = Color(0xFFD8A635);
  static const coral = Color(0xFFE66A55);
  static const violet = Color(0xFF7157D9);
  static const blue = Color(0xFF3976D9);
  static const green = Color(0xFF2E9E61);
  static const rose = Color(0xFFD54B72);
  static const surface = Color(0xFFF3F6FB);
}

ThemeData buildKfTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: KfColors.emerald, brightness: Brightness.light);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: KfColors.surface,
    fontFamilyFallback: const ['Roboto','Noto Sans'],
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.black.withOpacity(.035))),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      foregroundColor: KfColors.ink,
      titleTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: KfColors.ink),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      elevation: 0,
      backgroundColor: Colors.white,
      indicatorColor: KfColors.emerald.withOpacity(.12),
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(fontWeight: states.contains(WidgetState.selected) ? FontWeight.w900 : FontWeight.w600, fontSize: 11)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide(color: Colors.black.withOpacity(.06))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: KfColors.emerald, width: 1.6)),
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.w900))),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.w900))),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
