import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _boxName = 'settings_box';
  static const String _themeKey = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox(_boxName);
      final savedIndex = box.get(_themeKey, defaultValue: 2); // default Dark (index 2)
      if (savedIndex == 0) {
        state = ThemeMode.system;
      } else if (savedIndex == 1) {
        state = ThemeMode.light;
      } else {
        state = ThemeMode.dark;
      }
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final box = await Hive.openBox(_boxName);
      int index = 2;
      if (mode == ThemeMode.system) index = 0;
      if (mode == ThemeMode.light) index = 1;
      await box.put(_themeKey, index);
    } catch (_) {}
  }
}
