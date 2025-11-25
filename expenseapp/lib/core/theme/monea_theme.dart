import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'monea_colors.dart';
import 'monea_typography.dart';

/// Tema completo de Monea
/// Estilo shadcn/ui adaptado a Flutter
class MoneaTheme {
  MoneaTheme._();

  // Constantes de diseño
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 999.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;

  static const double borderWidth = 1.0;
  static const double borderWidthFocus = 2.0;

  // Sombras estilo shadcn
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: MoneaColors.shadow.withOpacity(0.04),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: MoneaColors.shadow.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: MoneaColors.shadow.withOpacity(0.04),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: MoneaColors.shadow.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: MoneaColors.shadow.withOpacity(0.05),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: MoneaTypography.fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: MoneaColors.porcelain,
        onPrimary: MoneaColors.textPrimary,
        primaryContainer: MoneaColors.parchmentLight,
        onPrimaryContainer: MoneaColors.textPrimary,
        secondary: MoneaColors.softLinen,
        onSecondary: MoneaColors.textPrimary,
        secondaryContainer: MoneaColors.parchment,
        onSecondaryContainer: MoneaColors.textPrimary,
        surface: MoneaColors.parchment,
        onSurface: MoneaColors.textPrimary,
        surfaceContainerHighest: MoneaColors.porcelainLight,
        error: MoneaColors.error,
        onError: MoneaColors.textInverse,
        outline: MoneaColors.softLinen,
        outlineVariant: MoneaColors.divider,
      ),

      scaffoldBackgroundColor: MoneaColors.porcelainLight,
      canvasColor: MoneaColors.parchment,
      cardColor: MoneaColors.parchment,
      dividerColor: MoneaColors.divider,

      // Text Theme
      textTheme: MoneaTypography.textTheme,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: MoneaColors.porcelainLight,
        foregroundColor: MoneaColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: MoneaTypography.headlineMedium,
        iconTheme: const IconThemeData(
          color: MoneaColors.textPrimary,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: MoneaColors.parchment,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(
            color: MoneaColors.softLinen,
            width: borderWidth,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme (Solid variant)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MoneaColors.textPrimary,
          foregroundColor: MoneaColors.textInverse,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: MoneaTypography.labelLarge,
        ),
      ),

      // Outlined Button Theme (Outline variant)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MoneaColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(
            color: MoneaColors.softLinen,
            width: borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: MoneaTypography.labelLarge,
        ),
      ),

      // Text Button Theme (Ghost variant)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MoneaColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: MoneaTypography.labelLarge,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: MoneaColors.textPrimary,
        foregroundColor: MoneaColors.textInverse,
        elevation: 2,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MoneaColors.parchment,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.softLinen, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.softLinen, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.porcelain, width: borderWidthFocus),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.error, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.error, width: borderWidthFocus),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: MoneaColors.softLinen.withOpacity(0.5), width: borderWidth),
        ),
        labelStyle: MoneaTypography.bodyMedium.copyWith(color: MoneaColors.textSecondary),
        hintStyle: MoneaTypography.bodyMedium.copyWith(color: MoneaColors.textMuted),
        errorStyle: MoneaTypography.bodySmall.copyWith(color: MoneaColors.error),
        prefixIconColor: MoneaColors.textSecondary,
        suffixIconColor: MoneaColors.textSecondary,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MoneaColors.parchment,
        selectedItemColor: MoneaColors.textPrimary,
        unselectedItemColor: MoneaColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: MoneaTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: MoneaTypography.labelSmall,
      ),

      // Bottom App Bar Theme
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: MoneaColors.parchment,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: MoneaColors.parchmentLight,
        labelStyle: MoneaTypography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
          side: const BorderSide(color: MoneaColors.softLinen, width: borderWidth),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: MoneaColors.parchment,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: MoneaColors.softLinen, width: borderWidth),
        ),
        titleTextStyle: MoneaTypography.headlineMedium,
        contentTextStyle: MoneaTypography.bodyMedium,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: MoneaColors.parchment,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
        showDragHandle: true,
        dragHandleColor: MoneaColors.softLinen,
        dragHandleSize: Size(40, 4),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: MoneaColors.textPrimary,
        contentTextStyle: MoneaTypography.bodyMedium.copyWith(color: MoneaColors.textInverse),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MoneaColors.porcelain,
        linearTrackColor: MoneaColors.softLinen,
        circularTrackColor: MoneaColors.softLinen,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: MoneaColors.divider,
        thickness: 1,
        space: 1,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        titleTextStyle: MoneaTypography.titleMedium,
        subtitleTextStyle: MoneaTypography.bodySmall,
        leadingAndTrailingTextStyle: MoneaTypography.bodyMedium,
        iconColor: MoneaColors.textSecondary,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: MoneaColors.textPrimary,
        unselectedLabelColor: MoneaColors.textSecondary,
        labelStyle: MoneaTypography.labelLarge,
        unselectedLabelStyle: MoneaTypography.labelLarge,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: MoneaColors.textPrimary,
              width: 2,
            ),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: MoneaColors.textSecondary,
        size: 24,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.textPrimary;
          }
          return MoneaColors.softLinen;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.porcelain;
          }
          return MoneaColors.divider;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.textPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(MoneaColors.textInverse),
        side: const BorderSide(color: MoneaColors.softLinen, width: borderWidthFocus),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.textPrimary;
          }
          return MoneaColors.softLinen;
        }),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: MoneaTypography.fontFamily,

      colorScheme: const ColorScheme.dark(
        primary: MoneaColors.porcelain,
        onPrimary: MoneaColors.darkBackground,
        primaryContainer: MoneaColors.darkCard,
        onPrimaryContainer: MoneaColors.darkTextPrimary,
        secondary: MoneaColors.softLinen,
        onSecondary: MoneaColors.darkBackground,
        secondaryContainer: MoneaColors.darkSurface,
        onSecondaryContainer: MoneaColors.darkTextPrimary,
        surface: MoneaColors.darkSurface,
        onSurface: MoneaColors.darkTextPrimary,
        surfaceContainerHighest: MoneaColors.darkCard,
        error: MoneaColors.error,
        onError: MoneaColors.darkBackground,
        outline: MoneaColors.darkBorder,
        outlineVariant: MoneaColors.darkBorder,
      ),

      scaffoldBackgroundColor: MoneaColors.darkBackground,
      canvasColor: MoneaColors.darkSurface,
      cardColor: MoneaColors.darkCard,
      dividerColor: MoneaColors.darkBorder,

      textTheme: MoneaTypography.darkTextTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: MoneaColors.darkBackground,
        foregroundColor: MoneaColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: MoneaTypography.headlineMedium.copyWith(
          color: MoneaColors.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: MoneaColors.darkTextPrimary,
          size: 24,
        ),
      ),

      cardTheme: CardThemeData(
        color: MoneaColors.darkCard,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(
            color: MoneaColors.darkBorder,
            width: borderWidth,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MoneaColors.darkTextPrimary,
          foregroundColor: MoneaColors.darkBackground,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: MoneaTypography.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MoneaColors.darkTextPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: const BorderSide(
            color: MoneaColors.darkBorder,
            width: borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: MoneaTypography.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MoneaColors.darkTextPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: MoneaTypography.labelLarge,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: MoneaColors.porcelain,
        foregroundColor: MoneaColors.darkBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MoneaColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.darkBorder, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.darkBorder, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.porcelain, width: borderWidthFocus),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: MoneaColors.error, width: borderWidth),
        ),
        labelStyle: MoneaTypography.bodyMedium.copyWith(color: MoneaColors.darkTextSecondary),
        hintStyle: MoneaTypography.bodyMedium.copyWith(color: MoneaColors.darkTextSecondary),
        prefixIconColor: MoneaColors.darkTextSecondary,
        suffixIconColor: MoneaColors.darkTextSecondary,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MoneaColors.darkSurface,
        selectedItemColor: MoneaColors.darkTextPrimary,
        unselectedItemColor: MoneaColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: MoneaTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: MoneaTypography.labelSmall,
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: MoneaColors.darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: MoneaColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: MoneaColors.darkBorder, width: borderWidth),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: MoneaColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
        showDragHandle: true,
        dragHandleColor: MoneaColors.darkBorder,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: MoneaColors.darkTextPrimary,
        contentTextStyle: MoneaTypography.bodyMedium.copyWith(color: MoneaColors.darkBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MoneaColors.porcelain,
        linearTrackColor: MoneaColors.darkBorder,
        circularTrackColor: MoneaColors.darkBorder,
      ),

      dividerTheme: const DividerThemeData(
        color: MoneaColors.darkBorder,
        thickness: 1,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        titleTextStyle: MoneaTypography.titleMedium.copyWith(color: MoneaColors.darkTextPrimary),
        subtitleTextStyle: MoneaTypography.bodySmall.copyWith(color: MoneaColors.darkTextSecondary),
        iconColor: MoneaColors.darkTextSecondary,
      ),

      iconTheme: const IconThemeData(
        color: MoneaColors.darkTextSecondary,
        size: 24,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.porcelain;
          }
          return MoneaColors.darkBorder;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.darkTextSecondary;
          }
          return MoneaColors.darkSurface;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MoneaColors.porcelain;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(MoneaColors.darkBackground),
        side: const BorderSide(color: MoneaColors.darkBorder, width: borderWidthFocus),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

