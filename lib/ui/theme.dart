import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/constants.dart';

const colorScheme = ColorScheme.light(
  primary: MaterialColor(0xff92d14f, color),
  secondary: Color(0xffd8e4be),
  tertiary: Color(0xff5483be),
  background: Color(0xFFFCFCFC),
  surface: Color(0xFFe2e1f6),
  error: Color(0xff8b0000),
  onPrimary: Color(0xFFe2e1f6),
  onSecondary: Color(0xFFe2e1f6),
  onTertiary: Color(0xFFe2e1f6),
  onError: Color(0xFFFFFFFF),
);

const textTheme = TextTheme(
  titleSmall: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ),
  bodySmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ),
  bodyLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  ),
);

final theme = ThemeData(
  colorScheme: colorScheme,
  textTheme: textTheme,
  useMaterial3: true,
);
