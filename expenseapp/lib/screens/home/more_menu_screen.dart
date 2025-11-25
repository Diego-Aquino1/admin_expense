import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';

/// Pantalla "Más" con acceso a todas las funcionalidades
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con perfil
          SliverToBoxAdapter(
            child: _buildHeader(context, user, isDark),
          ),

          // Secciones del menú
          SliverPadding(
            padding: const EdgeInsets.all(MoneaTheme.spacingMd),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Finanzas
                _buildSection(
                  context,
                  'Finanzas',
                  [
                    _MenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Cuentas',
                      onTap: () => context.push('/accounts'),
                    ),
                    _MenuItem(
                      icon: Icons.credit_card_outlined,
                      label: 'Tarjetas de Crédito',
                      onTap: () => context.push('/credit-cards'),
                    ),
                    _MenuItem(
                      icon: Icons.pie_chart_outline,
                      label: 'Presupuestos',
                      onTap: () => context.push('/budgets'),
                    ),
                    _MenuItem(
                      icon: Icons.flag_outlined,
                      label: 'Metas Financieras',
                      onTap: () => context.push('/goals'),
                    ),
                    _MenuItem(
                      icon: Icons.trending_up_outlined,
                      label: 'Inversiones',
                      onTap: () => context.push('/investments'),
                    ),
                  ],
                ),
                const SizedBox(height: MoneaTheme.spacingMd),

                // Herramientas
                _buildSection(
                  context,
                  'Herramientas',
                  [
                    _MenuItem(
                      icon: Icons.help_outline,
                      label: '¿Puedo gastar esto?',
                      subtitle: 'Evalúa si puedes permitirte un gasto',
                      onTap: () => context.push('/can-spend'),
                    ),
                    _MenuItem(
                      icon: Icons.repeat_outlined,
                      label: 'Suscripciones',
                      onTap: () => context.push('/subscriptions'),
                    ),
                    _MenuItem(
                      icon: Icons.category_outlined,
                      label: 'Categorías',
                      onTap: () => context.push('/categories'),
                    ),
                  ],
                ),
                const SizedBox(height: MoneaTheme.spacingMd),

                // Configuración
                _buildSection(
                  context,
                  'Configuración',
                  [
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Alertas',
                      onTap: () => context.push('/alerts'),
                    ),
                    _MenuItem(
                      icon: Icons.file_download_outlined,
                      label: 'Exportar Datos',
                      onTap: () => context.push('/export'),
                    ),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Ajustes',
                      onTap: () => context.push('/settings'),
                    ),
                  ],
                ),
                const SizedBox(height: MoneaTheme.spacingMd),

                // Cerrar sesión
                MoneaCard(
                  variant: MoneaCardVariant.ghost,
                  onTap: () => _showLogoutDialog(context, authProvider),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MoneaColors.errorLight,
                          borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                        ),
                        child: Icon(
                          Icons.logout,
                          size: 20,
                          color: MoneaColors.error,
                        ),
                      ),
                      const SizedBox(width: MoneaTheme.spacingSm),
                      Text(
                        'Cerrar sesión',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: MoneaColors.error,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: MoneaTheme.spacingXl),

                // Versión de la app
                Center(
                  child: Text(
                    '${AppConstants.appName} v${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: MoneaTheme.spacingLg),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + MoneaTheme.spacingMd,
        left: MoneaTheme.spacingMd,
        right: MoneaTheme.spacingMd,
        bottom: MoneaTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkSurface : MoneaColors.parchmentLight.withOpacity(0.3),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: MoneaColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                user?.username?.substring(0, 1).toUpperCase() ?? 'U',
                style: MoneaTypography.headlineLarge.copyWith(
                  color: isDark ? MoneaColors.darkBackground : MoneaColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: MoneaTheme.spacingSm),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.username ?? 'Usuario',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Botón editar perfil
          MoneaIconButton(
            icon: Icons.edit_outlined,
            onPressed: () => context.push('/profile'),
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<_MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: MoneaTheme.spacingXs,
            bottom: MoneaTheme.spacingSm,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
          ),
        ),
        MoneaCard(
          variant: MoneaCardVariant.outlined,
          padding: EdgeInsets.zero,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.vertical(
                      top: index == 0
                          ? const Radius.circular(MoneaTheme.radiusMd)
                          : Radius.zero,
                      bottom: isLast
                          ? const Radius.circular(MoneaTheme.radiusMd)
                          : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MoneaColors.parchmentLight.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(MoneaTheme.radiusSm),
                            ),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: MoneaColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: MoneaTheme.spacingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.label,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                ),
                                if (item.subtitle != null)
                                  Text(
                                    item.subtitle!,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: MoneaColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: Theme.of(context).dividerColor,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          MoneaButton(
            label: 'Cancelar',
            variant: MoneaButtonVariant.ghost,
            onPressed: () => Navigator.pop(context),
          ),
          MoneaButton(
            label: 'Cerrar sesión',
            variant: MoneaButtonVariant.soft,
            color: MoneaColors.error,
            onPressed: () {
              Navigator.pop(context);
              authProvider.logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });
}

