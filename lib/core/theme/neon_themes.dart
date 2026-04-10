import 'package:flutter/material.dart';

class NeonTheme {
  final String name;
  final String displayName;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color income;
  final Color expense;
  final Color warning;
  final String unlockRank;
  final String description;

  const NeonTheme({
    required this.name,
    required this.displayName,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.income,
    required this.expense,
    required this.warning,
    required this.unlockRank,
    required this.description,
  });
}

class NeonThemes {
  static const NeonTheme synthwave = NeonTheme(
    name: 'synthwave',
    displayName: 'SYNTHWAVE',
    primary: Color(0xFF9D50BB),
    secondary: Color(0xFF6E48AA),
    accent: Color(0xFF00F2FE),
    income: Color(0xFF00FFB2),
    expense: Color(0xFFFF0055),
    warning: Color(0xFFFFD700),
    unlockRank: 'NEW_USER',
    description: 'The classic neon grid aesthetic',
  );

  static const NeonTheme outrun = NeonTheme(
    name: 'outrun',
    displayName: 'OUTRUN_SUNSET',
    primary: Color(0xFFFF6B6B),
    secondary: Color(0xFFFF8E53),
    accent: Color(0xFFFFFF66),
    income: Color(0xFF4ECDC4),
    expense: Color(0xFFFF1744),
    warning: Color(0xFFFFAB40),
    unlockRank: 'GRID_RUNNER',
    description: 'Chrome and sunsets, the original 80s vibe',
  );

  static const NeonTheme matrix = NeonTheme(
    name: 'matrix',
    displayName: 'MATRIX_GREEN',
    primary: Color(0xFF00FF41),
    secondary: Color(0xFF008F11),
    accent: Color(0xFF003B00),
    income: Color(0xFF00FF41),
    expense: Color(0xFFFF0000),
    warning: Color(0xFFFFFF00),
    unlockRank: 'GRID_RUNNER',
    description: 'Follow the white rabbit into the code',
  );

  static const NeonTheme cyberpunk = NeonTheme(
    name: 'cyberpunk',
    displayName: 'CYBERPUNK_YELLOW',
    primary: Color(0xFFFCEE0A),
    secondary: Color(0xFFFF2A6D),
    accent: Color(0xFF05D9E8),
    income: Color(0xFF00F0FF),
    expense: Color(0xFFFF003C),
    warning: Color(0xFFFFD300),
    unlockRank: 'MAINFRAME_MASTER',
    description: 'High tech, low life, maximum neon',
  );

  static const NeonTheme midnight = NeonTheme(
    name: 'midnight',
    displayName: 'MIDNIGHT_PURPLE',
    primary: Color(0xFF4A148C),
    secondary: Color(0xFF6A1B9A),
    accent: Color(0xFF7C4DFF),
    income: Color(0xFF69F0AE),
    expense: Color(0xFFFF5252),
    warning: Color(0xFFE040FB),
    unlockRank: 'MAINFRAME_MASTER',
    description: 'Deep purple shadows and ethereal glow',
  );

  static const NeonTheme vaporwave = NeonTheme(
    name: 'vaporwave',
    displayName: 'VAPORWAVE_PINK',
    primary: Color(0xFFFF71CE),
    secondary: Color(0xFFB967FF),
    accent: Color(0xFF01CDFE),
    income: Color(0xFF05FFA1),
    expense: Color(0xFFFF0097),
    warning: Color(0xFFFFF4F0),
    unlockRank: 'THE_ARCHITECT',
    description: 'A e s t h e t i c dreams in pink and cyan',
  );

  static const List<NeonTheme> all = [
    synthwave,
    outrun,
    matrix,
    cyberpunk,
    midnight,
    vaporwave,
  ];

  static NeonTheme byName(String name) {
    return all.firstWhere(
      (t) => t.name == name,
      orElse: () => synthwave,
    );
  }
}
