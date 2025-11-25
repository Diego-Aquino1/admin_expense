import 'package:flutter/material.dart';
import '../theme/monea_colors.dart';
import '../theme/monea_theme.dart';

/// Variantes de botón estilo shadcn/ui
enum MoneaButtonVariant {
  /// Botón sólido con fondo
  solid,
  /// Botón con solo borde
  outline,
  /// Botón sin fondo ni borde (texto)
  ghost,
  /// Botón con fondo suave
  soft,
  /// Botón de enlace
  link,
}

/// Tamaños de botón
enum MoneaButtonSize {
  sm,
  md,
  lg,
  icon,
}

class MoneaButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final IconData? trailingIcon;
  final MoneaButtonVariant variant;
  final MoneaButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final Color? color;

  const MoneaButton({
    super.key,
    this.label,
    this.icon,
    this.trailingIcon,
    this.variant = MoneaButtonVariant.solid,
    this.size = MoneaButtonSize.md,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.color,
  }) : assert(label != null || icon != null, 'Must provide label or icon');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    // Dimensiones según tamaño
    EdgeInsetsGeometry padding;
    double iconSize;
    double fontSize;
    double height;

    switch (size) {
      case MoneaButtonSize.sm:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        iconSize = 16;
        fontSize = 13;
        height = 36;
        break;
      case MoneaButtonSize.md:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
        iconSize = 18;
        fontSize = 14;
        height = 42;
        break;
      case MoneaButtonSize.lg:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
        iconSize = 20;
        fontSize = 16;
        height = 50;
        break;
      case MoneaButtonSize.icon:
        padding = const EdgeInsets.all(10);
        iconSize = 20;
        fontSize = 14;
        height = 42;
        break;
    }

    // Colores según variante
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    final baseColor = color ?? (isDark ? MoneaColors.darkTextPrimary : MoneaColors.textPrimary);
    final softColor = color ?? MoneaColors.porcelain;

    switch (variant) {
      case MoneaButtonVariant.solid:
        backgroundColor = baseColor;
        foregroundColor = isDark ? MoneaColors.darkBackground : MoneaColors.parchment;
        borderColor = Colors.transparent;
        break;
      case MoneaButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = baseColor;
        borderColor = isDark ? MoneaColors.darkBorder : MoneaColors.softLinen;
        break;
      case MoneaButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = baseColor;
        borderColor = Colors.transparent;
        break;
      case MoneaButtonVariant.soft:
        backgroundColor = softColor.withOpacity(0.15);
        foregroundColor = softColor;
        borderColor = Colors.transparent;
        break;
      case MoneaButtonVariant.link:
        backgroundColor = Colors.transparent;
        foregroundColor = softColor;
        borderColor = Colors.transparent;
        break;
    }

    if (!isEnabled) {
      backgroundColor = backgroundColor.withOpacity(0.5);
      foregroundColor = foregroundColor.withOpacity(0.5);
      borderColor = borderColor.withOpacity(0.5);
    }

    // Contenido del botón
    Widget content;
    if (isLoading) {
      content = SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    } else if (size == MoneaButtonSize.icon && icon != null) {
      content = Icon(icon, size: iconSize, color: foregroundColor);
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: foregroundColor),
            if (label != null) const SizedBox(width: 8),
          ],
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
                decoration: variant == MoneaButtonVariant.link
                    ? TextDecoration.underline
                    : null,
              ),
            ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(trailingIcon, size: iconSize, color: foregroundColor),
          ],
        ],
      );
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
          splashColor: foregroundColor.withOpacity(0.1),
          highlightColor: foregroundColor.withOpacity(0.05),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
              border: borderColor != Colors.transparent
                  ? Border.all(color: borderColor, width: MoneaTheme.borderWidth)
                  : null,
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}

/// Botón de icono circular
class MoneaIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final MoneaButtonVariant variant;
  final MoneaButtonSize size;
  final Color? color;
  final String? tooltip;
  final bool isLoading;

  const MoneaIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = MoneaButtonVariant.ghost,
    this.size = MoneaButtonSize.md,
    this.color,
    this.tooltip,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = MoneaButton(
      icon: icon,
      variant: variant,
      size: MoneaButtonSize.icon,
      onPressed: onPressed,
      color: color,
      isLoading: isLoading,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Grupo de botones tipo segmented/toggle
class MoneaButtonGroup<T> extends StatelessWidget {
  final List<T> options;
  final T selectedValue;
  final String Function(T) labelBuilder;
  final IconData Function(T)? iconBuilder;
  final ValueChanged<T> onChanged;
  final bool isFullWidth;

  const MoneaButtonGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.labelBuilder,
    this.iconBuilder,
    required this.onChanged,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkSurface : MoneaColors.softLinen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        border: Border.all(
          color: isDark ? MoneaColors.darkBorder : MoneaColors.softLinen,
          width: MoneaTheme.borderWidth,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selectedValue;
          return Expanded(
            flex: isFullWidth ? 1 : 0,
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? MoneaColors.darkCard : MoneaColors.parchment)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                  boxShadow: isSelected ? MoneaTheme.shadowSm : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (iconBuilder != null) ...[
                      Icon(
                        iconBuilder!(option),
                        size: 16,
                        color: isSelected
                            ? (isDark ? MoneaColors.darkTextPrimary : MoneaColors.textPrimary)
                            : MoneaColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      labelBuilder(option),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? MoneaColors.darkTextPrimary : MoneaColors.textPrimary)
                            : MoneaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

