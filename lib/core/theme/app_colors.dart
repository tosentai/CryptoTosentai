import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand emerald palette
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFF34D399);
  static const Color emeraldDark = Color(0xFF047857);
  static const Color emeraldGlow = Color(0xFF6EE7B7);

  // Backgrounds (dark first)
  static const Color bgDark = Color(0xFF0A0F0D);
  static const Color surfaceDark = Color(0xFF12181A);
  static const Color elevatedDark = Color(0xFF1A2226);
  static const Color glassDark = Color(0x1AFFFFFF);

  // Light backgrounds
  static const Color bgLight = Color(0xFFF6FAF8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color elevatedLight = Color(0xFFEFF5F2);

  // Text
  static const Color textPrimaryDark = Color(0xFFEAFBF3);
  static const Color textSecondaryDark = Color(0xFF8FA3A0);
  static const Color textPrimaryLight = Color(0xFF0B1410);
  static const Color textSecondaryLight = Color(0xFF55695F);

  // Status
  static const Color positive = Color(0xFF10B981);
  static const Color negative = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Borders
  static const Color borderDark = Color(0x1F34D399);
  static const Color borderLight = Color(0x14047857);

  // Gradients
  static const Gradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emeraldLight, emerald, emeraldDark],
  );

  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF152422), Color(0xFF0F1817)],
  );

  static const Gradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F7F0), Color(0xFFD3EFE0)],
  );

  static const Gradient glowGradient = RadialGradient(
    radius: 0.85,
    colors: [Color(0x4010B981), Color(0x0010B981)],
  );
}
