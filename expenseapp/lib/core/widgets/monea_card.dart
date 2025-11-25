import 'package:flutter/material.dart';
import '../theme/monea_colors.dart';
import '../theme/monea_theme.dart';

/// Card estilo shadcn/ui para Monea
/// Variantes: default, outlined, elevated, ghost
enum MoneaCardVariant {
  /// Card con fondo y borde sutil
  outlined,
  /// Card con sombra suave
  elevated,
  /// Card sin borde ni sombra (solo padding)
  ghost,
  /// Card con gradiente suave
  gradient,
}

class MoneaCard extends StatelessWidget {
  final Widget child;
  final MoneaCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;

  const MoneaCard({
    super.key,
    required this.child,
    this.variant = MoneaCardVariant.outlined,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectivePadding = padding ?? const EdgeInsets.all(MoneaTheme.spacingMd);
    final effectiveRadius = borderRadius ?? MoneaTheme.radiusMd;

    Color bgColor;
    Color border;
    List<BoxShadow>? shadows;

    switch (variant) {
      case MoneaCardVariant.outlined:
        bgColor = backgroundColor ?? (isDark ? MoneaColors.darkCard : MoneaColors.parchment);
        border = borderColor ?? (isDark ? MoneaColors.darkBorder : MoneaColors.softLinen);
        shadows = null;
        break;
      case MoneaCardVariant.elevated:
        bgColor = backgroundColor ?? (isDark ? MoneaColors.darkCard : MoneaColors.parchment);
        border = Colors.transparent;
        shadows = isDark ? null : MoneaTheme.shadowMd;
        break;
      case MoneaCardVariant.ghost:
        bgColor = Colors.transparent;
        border = Colors.transparent;
        shadows = null;
        break;
      case MoneaCardVariant.gradient:
        bgColor = Colors.transparent;
        border = borderColor ?? (isDark ? MoneaColors.darkBorder : MoneaColors.softLinen);
        shadows = null;
        break;
    }

    if (isSelected) {
      border = MoneaColors.porcelain;
    }

    if (isDisabled) {
      bgColor = bgColor.withOpacity(0.5);
    }

    Widget cardContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: variant == MoneaCardVariant.gradient ? null : bgColor,
        gradient: variant == MoneaCardVariant.gradient
            ? (isDark ? null : MoneaColors.cardGradient)
            : null,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: border != Colors.transparent
            ? Border.all(
                color: border,
                width: isSelected ? MoneaTheme.borderWidthFocus : MoneaTheme.borderWidth,
              )
            : null,
        boxShadow: shadows,
      ),
      child: child,
    );

    if (margin != null) {
      cardContent = Padding(padding: margin!, child: cardContent);
    }

    if (onTap != null && !isDisabled) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(effectiveRadius),
          splashColor: MoneaColors.parchmentLight.withOpacity(0.3),
          highlightColor: MoneaColors.parchmentLight.withOpacity(0.1),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// Card con título y acciones opcionales
class MoneaCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const MoneaCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: MoneaTheme.spacingSm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Stat card para métricas
class MoneaStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final String? trend;
  final bool isTrendPositive;
  final VoidCallback? onTap;

  const MoneaStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.trend,
    this.isTrendPositive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MoneaCard(
      variant: MoneaCardVariant.outlined,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? MoneaColors.porcelain).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor ?? MoneaColors.porcelain,
                  ),
                ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTrendPositive
                        ? MoneaColors.successLight
                        : MoneaColors.errorLight,
                    borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTrendPositive ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isTrendPositive ? MoneaColors.success : MoneaColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isTrendPositive ? MoneaColors.success : MoneaColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: valueColor ?? (isDark ? MoneaColors.darkTextPrimary : MoneaColors.textPrimary),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

