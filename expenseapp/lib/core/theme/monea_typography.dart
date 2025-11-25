import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'monea_colors.dart';

/// Sistema tipográfico Monea
/// Basado en Plus Jakarta Sans - Moderna, legible, elegante
class MoneaTypography {
  MoneaTypography._();

  // Base font family
  static String get fontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  // Display styles - Para títulos grandes
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.2,
    color: MoneaColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: MoneaColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
    color: MoneaColors.textPrimary,
  );

  // Headline styles - Para secciones
  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
    color: MoneaColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: MoneaColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: MoneaColors.textPrimary,
  );

  // Title styles - Para cards y elementos
  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    color: MoneaColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: MoneaColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: MoneaColors.textPrimary,
  );

  // Body styles - Para contenido
  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.55,
    color: MoneaColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.55,
    color: MoneaColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.5,
    color: MoneaColors.textSecondary,
  );

  // Label styles - Para botones y etiquetas
  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: MoneaColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 1.4,
    color: MoneaColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.4,
    color: MoneaColors.textSecondary,
  );

  // Estilos especiales para números/montos
  static TextStyle amountLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: MoneaColors.textPrimary,
  );

  static TextStyle amountMedium = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.25,
    color: MoneaColors.textPrimary,
  );

  static TextStyle amountSmall = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: MoneaColors.textPrimary,
  );

  // TextTheme para Material
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  // Dark mode text theme
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: displayLarge.copyWith(color: MoneaColors.darkTextPrimary),
    displayMedium: displayMedium.copyWith(color: MoneaColors.darkTextPrimary),
    displaySmall: displaySmall.copyWith(color: MoneaColors.darkTextPrimary),
    headlineLarge: headlineLarge.copyWith(color: MoneaColors.darkTextPrimary),
    headlineMedium: headlineMedium.copyWith(color: MoneaColors.darkTextPrimary),
    headlineSmall: headlineSmall.copyWith(color: MoneaColors.darkTextPrimary),
    titleLarge: titleLarge.copyWith(color: MoneaColors.darkTextPrimary),
    titleMedium: titleMedium.copyWith(color: MoneaColors.darkTextPrimary),
    titleSmall: titleSmall.copyWith(color: MoneaColors.darkTextPrimary),
    bodyLarge: bodyLarge.copyWith(color: MoneaColors.darkTextPrimary),
    bodyMedium: bodyMedium.copyWith(color: MoneaColors.darkTextPrimary),
    bodySmall: bodySmall.copyWith(color: MoneaColors.darkTextSecondary),
    labelLarge: labelLarge.copyWith(color: MoneaColors.darkTextPrimary),
    labelMedium: labelMedium.copyWith(color: MoneaColors.darkTextPrimary),
    labelSmall: labelSmall.copyWith(color: MoneaColors.darkTextSecondary),
  );
}

