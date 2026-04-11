import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:people_browser/core/export.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return _buildTheme(Brightness.light);
  }

  static ThemeData dark() {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brightness == Brightness.dark
          ? AppColors.darkSeed
          : AppColors.seed,
      brightness: brightness,
    );
    final scaffoldBackground = AppColors.scaffoldBackgroundFor(brightness);
    final surface = brightness == Brightness.dark
        ? AppColors.darkSurface
        : AppColors.white;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillFor(brightness),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSizes.inputFocusBorderWidth,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBackground,
      ),
    );
  }
}
