import 'package:flutter/material.dart';
import '../theme/monea_colors.dart';
import '../theme/monea_theme.dart';

/// Skeleton loader animado para estados de carga
class MoneaSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isCircle;

  const MoneaSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
  });

  /// Skeleton para texto
  const MoneaSkeleton.text({
    super.key,
    this.width = 100,
    this.height = 14,
  })  : borderRadius = 4,
        isCircle = false;

  /// Skeleton para títulos
  const MoneaSkeleton.title({
    super.key,
    this.width = 150,
    this.height = 20,
  })  : borderRadius = 4,
        isCircle = false;

  /// Skeleton para avatares
  const MoneaSkeleton.avatar({
    super.key,
    double size = 40,
  })  : width = size,
        height = size,
        borderRadius = null,
        isCircle = true;

  /// Skeleton para cards
  const MoneaSkeleton.card({
    super.key,
    this.width,
    this.height = 100,
  })  : borderRadius = 12,
        isCircle = false;

  @override
  State<MoneaSkeleton> createState() => _MoneaSkeletonState();
}

class _MoneaSkeletonState extends State<MoneaSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : BorderRadius.circular(
                    widget.borderRadius ?? MoneaTheme.radiusSm),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: isDark
                  ? [
                      MoneaColors.darkSurface,
                      MoneaColors.darkBorder.withOpacity(0.5),
                      MoneaColors.darkSurface,
                    ]
                  : [
                      MoneaColors.softLinen.withOpacity(0.3),
                      MoneaColors.softLinen.withOpacity(0.6),
                      MoneaColors.softLinen.withOpacity(0.3),
                    ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton para lista de transacciones
class MoneaTransactionSkeleton extends StatelessWidget {
  const MoneaTransactionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MoneaTheme.spacingMd,
        vertical: MoneaTheme.spacingSm,
      ),
      child: Row(
        children: [
          const MoneaSkeleton.avatar(size: 44),
          const SizedBox(width: MoneaTheme.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MoneaSkeleton.text(width: 120),
                const SizedBox(height: 6),
                MoneaSkeleton.text(width: 80, height: 12),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneaSkeleton.text(width: 70),
              const SizedBox(height: 6),
              MoneaSkeleton.text(width: 50, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton para card de estadísticas
class MoneaStatSkeleton extends StatelessWidget {
  const MoneaStatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: MoneaTheme.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const MoneaSkeleton(
                width: 36,
                height: 36,
                borderRadius: 8,
              ),
              const Spacer(),
              MoneaSkeleton(
                width: 60,
                height: 24,
                borderRadius: MoneaTheme.radiusFull,
              ),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          const MoneaSkeleton.text(width: 60, height: 12),
          const SizedBox(height: 4),
          const MoneaSkeleton.title(width: 100),
        ],
      ),
    );
  }
}

/// Skeleton para dashboard completo
class MoneaDashboardSkeleton extends StatelessWidget {
  const MoneaDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            children: [
              const MoneaSkeleton.avatar(size: 48),
              const SizedBox(width: MoneaTheme.spacingSm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoneaSkeleton.text(width: 100),
                  const SizedBox(height: 4),
                  MoneaSkeleton.text(width: 60, height: 12),
                ],
              ),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Balance card skeleton
          const MoneaSkeleton.card(height: 120),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Stats grid skeleton
          Row(
            children: [
              const Expanded(child: MoneaStatSkeleton()),
              const SizedBox(width: MoneaTheme.spacingSm),
              const Expanded(child: MoneaStatSkeleton()),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Section header skeleton
          MoneaSkeleton.title(width: 140),
          const SizedBox(height: MoneaTheme.spacingSm),

          // Transaction list skeleton
          ...List.generate(5, (index) => const MoneaTransactionSkeleton()),
        ],
      ),
    );
  }
}

