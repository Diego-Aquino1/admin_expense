import 'package:flutter/material.dart';
import '../theme/monea_colors.dart';
import '../theme/monea_theme.dart';
import 'monea_button.dart';

/// Empty state elegante para Monea
/// Ilustraciones suaves y mensajes claros
class MoneaEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customIllustration;
  final bool compact;

  const MoneaEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.customIllustration,
    this.compact = false,
  });

  /// Empty state para transacciones
  const MoneaEmptyState.transactions({
    super.key,
    this.actionLabel = 'Agregar transacción',
    this.onAction,
    this.compact = false,
  })  : title = 'Sin transacciones',
        description = 'Comienza a registrar tus movimientos financieros',
        icon = Icons.receipt_long_outlined,
        customIllustration = null;

  /// Empty state para búsquedas
  const MoneaEmptyState.search({
    super.key,
    String? query,
    this.compact = false,
  })  : title = 'Sin resultados',
        description = 'No encontramos coincidencias para tu búsqueda',
        icon = Icons.search_off_outlined,
        actionLabel = null,
        onAction = null,
        customIllustration = null;

  /// Empty state para errores
  const MoneaEmptyState.error({
    super.key,
    String? message,
    this.actionLabel = 'Reintentar',
    this.onAction,
    this.compact = false,
  })  : title = 'Algo salió mal',
        description = message ?? 'Ocurrió un error inesperado',
        icon = Icons.error_outline,
        customIllustration = null;

  /// Empty state para metas
  const MoneaEmptyState.goals({
    super.key,
    this.actionLabel = 'Crear meta',
    this.onAction,
    this.compact = false,
  })  : title = 'Sin metas financieras',
        description = 'Establece objetivos para alcanzar tus sueños',
        icon = Icons.flag_outlined,
        customIllustration = null;

  /// Empty state para presupuestos
  const MoneaEmptyState.budgets({
    super.key,
    this.actionLabel = 'Crear presupuesto',
    this.onAction,
    this.compact = false,
  })  : title = 'Sin presupuestos',
        description = 'Controla tus gastos con presupuestos mensuales',
        icon = Icons.pie_chart_outline,
        customIllustration = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (compact) {
      return _buildCompact(context, isDark);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MoneaTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustración
            customIllustration ?? _buildDefaultIllustration(isDark),
            const SizedBox(height: MoneaTheme.spacingLg),

            // Título
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            // Descripción
            if (description != null) ...[
              const SizedBox(height: MoneaTheme.spacingSm),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Botón de acción
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: MoneaTheme.spacingLg),
              MoneaButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: MoneaButtonVariant.soft,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MoneaColors.parchmentLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
            ),
            child: Icon(
              icon,
              size: 24,
              color: MoneaColors.textSecondary,
            ),
          ),
          const SizedBox(width: MoneaTheme.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (description != null)
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            MoneaButton(
              label: actionLabel!,
              onPressed: onAction,
              variant: MoneaButtonVariant.ghost,
              size: MoneaButtonSize.sm,
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultIllustration(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            MoneaColors.parchmentLight.withOpacity(0.4),
            MoneaColors.parchmentLight.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculos decorativos
          Positioned(
            top: 10,
            right: 20,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: MoneaColors.porcelain.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: MoneaColors.softLinen.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Icono principal
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? MoneaColors.darkCard
                  : MoneaColors.parchment,
                shape: BoxShape.circle,
                border: Border.all(
                  color: MoneaColors.softLinen,
                width: MoneaTheme.borderWidth,
              ),
            ),
            child: Icon(
              icon,
              size: 40,
              color: MoneaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar mensajes de error elegantes
class MoneaErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const MoneaErrorWidget({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(MoneaTheme.spacingMd),
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      decoration: BoxDecoration(
        color: MoneaColors.errorLight,
        borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        border: Border.all(
          color: MoneaColors.error.withOpacity(0.3),
          width: MoneaTheme.borderWidth,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: MoneaColors.error,
            size: 20,
          ),
          const SizedBox(width: MoneaTheme.spacingSm),
          Expanded(
            child: Text(
              message ?? 'Ocurrió un error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.error,
              ),
            ),
          ),
          if (onRetry != null)
            MoneaIconButton(
              icon: Icons.refresh,
              onPressed: onRetry,
              variant: MoneaButtonVariant.ghost,
              color: MoneaColors.error,
            ),
        ],
      ),
    );
  }
}

