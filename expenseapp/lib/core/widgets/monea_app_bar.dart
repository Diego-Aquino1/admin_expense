import 'package:flutter/material.dart';
import '../theme/monea_colors.dart';
import '../theme/monea_theme.dart';
import 'monea_button.dart';

/// AppBar minimalista estilo shadcn para Monea
class MoneaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const MoneaAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = false,
    this.elevation = 0,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();

    return AppBar(
        backgroundColor: backgroundColor ??
          (isDark ? MoneaColors.darkBackground : MoneaColors.porcelainLight),
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: leading ??
          (showBackButton && canPop
              ? MoneaIconButton(
                  icon: Icons.arrow_back,
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  variant: MoneaButtonVariant.ghost,
                )
              : null),
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              : null),
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8),
            ]
          : null,
      bottom: bottom,
    );
  }
}

/// AppBar grande con saludo para dashboard
class MoneaLargeAppBar extends StatelessWidget {
  final String greeting;
  final String? userName;
  final String? subtitle;
  final Widget? avatar;
  final List<Widget>? actions;
  final Widget? bottom;

  const MoneaLargeAppBar({
    super.key,
    required this.greeting,
    this.userName,
    this.subtitle,
    this.avatar,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + MoneaTheme.spacingMd,
        left: MoneaTheme.spacingMd,
        right: MoneaTheme.spacingMd,
        bottom: MoneaTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkBackground : MoneaColors.porcelainLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: MoneaTheme.spacingSm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          greeting,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: MoneaColors.textSecondary,
                          ),
                        ),
                        if (userName != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            userName!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
          if (bottom != null) ...[
            const SizedBox(height: MoneaTheme.spacingMd),
            bottom!,
          ],
        ],
      ),
    );
  }
}

/// Header de sección con título y acción opcional
class MoneaSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final EdgeInsetsGeometry? padding;

  const MoneaSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: MoneaTheme.spacingMd,
        vertical: MoneaTheme.spacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (actionLabel != null || actionIcon != null)
            MoneaButton(
              label: actionLabel,
              icon: actionIcon,
              variant: MoneaButtonVariant.ghost,
              size: MoneaButtonSize.sm,
              onPressed: onAction,
              color: MoneaColors.porcelain,
            ),
        ],
      ),
    );
  }
}

