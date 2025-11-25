import 'package:flutter/material.dart';
import '../theme/monea_colors.dart';
import '../theme/monea_theme.dart';

/// Item de navegación
class MoneaNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? badge;

  const MoneaNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badge,
  });
}

/// Bottom Navigation Bar estilo Monea
/// Diseño limpio con FAB central opcional
class MoneaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<MoneaNavItem> items;
  final bool showLabels;
  final Widget? floatingActionButton;
  final bool hasNotch;

  const MoneaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showLabels = true,
    this.floatingActionButton,
    this.hasNotch = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasFab = floatingActionButton != null;

    // Si hay FAB, dividimos los items en dos grupos
    final itemCount = items.length;
    final leftItems = hasFab ? items.sublist(0, itemCount ~/ 2) : items;
    final rightItems = hasFab ? items.sublist(itemCount ~/ 2) : <MoneaNavItem>[];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkSurface : MoneaColors.parchment,
        border: Border(
          top: BorderSide(
            color: isDark ? MoneaColors.darkBorder : MoneaColors.divider,
            width: MoneaTheme.borderWidth,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: MoneaTheme.spacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Items de la izquierda
              ...leftItems.asMap().entries.map((entry) {
                return _buildNavItem(
                  context,
                  entry.value,
                  entry.key,
                  isDark,
                );
              }),

              // Espacio para FAB
              if (hasFab)
                const SizedBox(width: 72),

              // Items de la derecha
              ...rightItems.asMap().entries.map((entry) {
                return _buildNavItem(
                  context,
                  entry.value,
                  entry.key + leftItems.length,
                  isDark,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    MoneaNavItem item,
    int index,
    bool isDark,
  ) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? (isDark ? MoneaColors.darkTextPrimary : MoneaColors.textPrimary)
        : MoneaColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MoneaColors.parchmentLight.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                    ),
                    child: Icon(
                      isSelected
                          ? (item.activeIcon ?? item.icon)
                          : item.icon,
                      size: 22,
                      color: color,
                    ),
                  ),
                  if (item.badge != null)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: MoneaColors.error,
                          borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// FAB para agregar transacciones
class MoneaAddFab extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isExtended;
  final String? label;

  const MoneaAddFab({
    super.key,
    required this.onPressed,
    this.isExtended = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: isDark ? MoneaColors.porcelain : MoneaColors.textPrimary,
        foregroundColor: isDark ? MoneaColors.darkBackground : MoneaColors.parchment,
        elevation: 2,
        icon: const Icon(Icons.add, size: 20),
        label: Text(label!),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: isDark ? MoneaColors.porcelain : MoneaColors.textPrimary,
      foregroundColor: isDark ? MoneaColors.darkBackground : MoneaColors.parchment,
      elevation: 2,
      child: const Icon(Icons.add, size: 24),
    );
  }
}

