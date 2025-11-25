import 'package:flutter/material.dart';

/// Paleta de colores Monea
/// Elegante, suave, minimalista - Nueva paleta luminosa y premium
class MoneaColors {
  MoneaColors._();

  // Nueva paleta principal - Tonos neutros cálidos y luminosos
  static const Color softLinen = Color(0xFFF0ECE4);      // Elementos secundarios, bordes
  static const Color parchment = Color(0xFFF4F0EA);      // Fondo de cards, superficies
  static const Color parchmentLight = Color(0xFFF7F5F0); // Fondos de secciones, estados hover
  static const Color porcelain = Color(0xFFFBF9F5);      // Fondos intermedios, acentos suaves
  static const Color porcelainLight = Color(0xFFFEFDFB);  // Fondo principal (más claro)

  // Colores de texto - Ajustados para contraste con paleta clara
  static const Color textPrimary = Color(0xFF2D2A26);    // Texto principal (casi negro cálido)
  static const Color textSecondary = Color(0xFF6B6560);  // Texto secundario
  static const Color textMuted = Color(0xFF9C9690);     // Texto deshabilitado
  static const Color textInverse = Color(0xFFFAF9F7);   // Texto sobre fondos oscuros

  // Colores semánticos suaves - Ajustados para armonía con nueva paleta
  static const Color success = Color(0xFF7CB69F);        // Verde suave
  static const Color successLight = Color(0xFFE8F4EE);   // Fondo success
  static const Color warning = Color(0xFFD4A574);        // Naranja/ámbar suave
  static const Color warningLight = Color(0xFFFFF4E8);   // Fondo warning
  static const Color error = Color(0xFFBF8B8B);          // Rojo rosado suave
  static const Color errorLight = Color(0xFFFCF0F0);     // Fondo error
  static const Color info = Color(0xFF8BA5BF);           // Azul grisáceo suave
  static const Color infoLight = Color(0xFFF0F4F8);      // Fondo info

  // Colores para transacciones
  static const Color income = Color(0xFF7CB69F);           // Verde suave para ingresos
  static const Color expense = Color(0xFFBF8B8B);         // Rojo suave para gastos
  static const Color transfer = Color(0xFF8BA5BF);       // Azul suave para transferencias

  // Sombras y overlays - Ajustadas para paleta clara
  static const Color shadow = Color(0x0F2D2A26);         // Sombra muy suave
  static const Color overlay = Color(0x802D2A26);        // Overlay para modals
  static const Color divider = Color(0xFFE5E0DA);        // Líneas divisorias (ajustado)

  // Dark Mode - Tonos cálidos oscuros (mantenidos)
  static const Color darkBackground = Color(0xFF1C1A18);
  static const Color darkSurface = Color(0xFF2A2724);
  static const Color darkCard = Color(0xFF363330);
  static const Color darkBorder = Color(0xFF4A4541);
  static const Color darkTextPrimary = Color(0xFFF5F2EF);
  static const Color darkTextSecondary = Color(0xFFB5B0A8);

  // Gradientes - Actualizados con nueva paleta
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [parchmentLight, porcelain],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [parchment, porcelainLight],
  );

  // Gradiente suave para elementos destacados
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [porcelain, parchmentLight],
  );

  // Color con opacidad
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Helpers para compatibilidad (deprecated - usar nuevos nombres)
  @Deprecated('Use softLinen instead')
  static const Color bone = softLinen;
  
  @Deprecated('Use parchment instead')
  static const Color linen = parchment;
  
  @Deprecated('Use parchmentLight instead')
  static const Color almondCream = parchmentLight;
  
  @Deprecated('Use porcelain instead')
  static const Color almondSilk = porcelain;
}
