import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'neon_themes.dart';

class AppColors {
  // All driven by the active theme so non-dark palettes (normal_light) work.
  static Color get primary => currentTheme.primary;
  static Color get secondary => currentTheme.secondary;
  static Color get accent => currentTheme.accent;

  static Color get income => currentTheme.income;
  static Color get expense => currentTheme.expense;
  static Color get warning => currentTheme.warning;
  static Color get info => currentTheme.accent;

  static Color get background => currentTheme.background;
  static Color get surface => currentTheme.surface;
  static Color get surfaceLight => currentTheme.surfaceLight;
  static Color get card => currentTheme.card;

  static Color get textPrimary => currentTheme.textPrimary;
  static Color get textSecondary => currentTheme.textSecondary;
  static Color get textMuted => currentTheme.textMuted;

  // Global theme state holder (internal use)
  static NeonTheme currentTheme = NeonThemes.blackshield;

  static List<BoxShadow> get primaryGlow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  static LinearGradient get neonGradient => LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Was const; now follows the active theme so light mode doesn't render on
  // a hardcoded dark gradient.
  static LinearGradient get spaceGradient {
    final isLight = currentTheme.brightness == Brightness.light;
    return LinearGradient(
      colors: [
        currentTheme.background,
        isLight ? currentTheme.surfaceLight : currentTheme.surface,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}

class AppTextStyles {
  static TextStyle get headlineMainframe => GoogleFonts.orbitron(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  static TextStyle get headlineTitle => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMain => GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get moneyLarge => GoogleFonts.orbitron(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelNeon => GoogleFonts.orbitron(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    color: AppColors.accent,
  );
}

class AppTheme {
  static ThemeData createTheme(NeonTheme neonTheme) {
    // Update the static holder for legacy code support
    AppColors.currentTheme = neonTheme;

    final isLight = neonTheme.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: neonTheme.brightness,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: isLight
          ? ColorScheme.light(
              primary: neonTheme.primary,
              secondary: neonTheme.accent,
              surface: AppColors.surface,
              error: neonTheme.expense,
            )
          : ColorScheme.dark(
              primary: neonTheme.primary,
              secondary: neonTheme.accent,
              surface: AppColors.surface,
              error: neonTheme.expense,
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineTitle,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.surfaceLight, width: 1),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: neonTheme.accent,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: neonTheme.primary.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.labelNeon.copyWith(fontSize: 10),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: neonTheme.accent);
          }
          return IconThemeData(color: AppColors.textMuted);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.surfaceLight,
        thickness: 0.5,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return neonTheme.accent;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return neonTheme.accent.withValues(alpha: 0.3);
          }
          return AppColors.surfaceLight;
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: neonTheme.accent,
        foregroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTextStyles.labelNeon.copyWith(fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: neonTheme.primary.withValues(alpha: 0.3)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.surfaceLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: neonTheme.accent.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        labelStyle: AppTextStyles.labelNeon.copyWith(
          fontSize: 8,
          color: AppColors.textMuted,
        ),
        hintStyle: TextStyle(color: AppColors.textMuted),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: neonTheme.accent,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.surfaceLight),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: neonTheme.primary.withValues(alpha: 0.3),
        headerForegroundColor: AppColors.textPrimary,
        dayStyle: AppTextStyles.bodyMain,
        weekdayStyle: AppTextStyles.labelNeon.copyWith(fontSize: 10),
        yearStyle: AppTextStyles.bodyMain,
        todayBackgroundColor: WidgetStateProperty.all(neonTheme.primary.withValues(alpha: 0.3)),
        todayForegroundColor: WidgetStateProperty.all(AppColors.textPrimary),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Legacy support
  static ThemeData get darkTheme => createTheme(NeonThemes.blackshield);
}
