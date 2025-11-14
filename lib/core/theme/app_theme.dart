import 'package:flutter/material.dart';
part 'light_theme.dart';
part 'dark_theme.dart';

class AppThemes{
  static ThemeData theme(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? _DarkTheme.theme() : _LightTheme.theme();
  }
}