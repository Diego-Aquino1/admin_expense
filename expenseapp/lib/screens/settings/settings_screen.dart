import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = authProvider.user;

    return Scaffold(
      appBar: const MoneaAppBar(
        title: 'Ajustes',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MoneaTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfil
            _buildSection(
              context,
              'Perfil',
              [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Información personal',
                  subtitle: user?.email ?? 'No configurado',
                  onTap: () => _showProfileSheet(context, authProvider),
                ),
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Cambiar contraseña',
                  onTap: () {
                    // TODO: Implementar cambio de contraseña
                  },
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Preferencias
            _buildSection(
              context,
              'Preferencias',
              [
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Apariencia',
                  subtitle: isDark ? 'Modo oscuro' : 'Modo claro',
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      // TODO: Cambiar tema
                    },
                  ),
                ),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () {
                    // TODO: Selector de idioma
                  },
                ),
                _SettingsTile(
                  icon: Icons.attach_money,
                  title: 'Moneda predeterminada',
                  subtitle: AppConstants.defaultCurrency,
                  onTap: () {
                    // TODO: Selector de moneda
                  },
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Notificaciones
            _buildSection(
              context,
              'Notificaciones',
              [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones push',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle notificaciones
                    },
                  ),
                ),
                _SettingsTile(
                  icon: Icons.email_outlined,
                  title: 'Resumen semanal por email',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Toggle email
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Datos
            _buildSection(
              context,
              'Datos',
              [
                _SettingsTile(
                  icon: Icons.file_download_outlined,
                  title: 'Exportar datos',
                  subtitle: 'CSV, Excel, PDF',
                  onTap: () => context.push('/export'),
                ),
                _SettingsTile(
                  icon: Icons.file_upload_outlined,
                  title: 'Importar datos',
                  onTap: () {
                    // TODO: Importar
                  },
                ),
                _SettingsTile(
                  icon: Icons.backup_outlined,
                  title: 'Respaldo automático',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle backup
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Información
            _buildSection(
              context,
              'Información',
              [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Ayuda y soporte',
                  onTap: () {
                    // TODO: Abrir ayuda
                  },
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Términos y condiciones',
                  onTap: () {
                    // TODO: Abrir términos
                  },
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de privacidad',
                  onTap: () {
                    // TODO: Abrir política
                  },
                ),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'Acerca de',
                  subtitle: '${AppConstants.appName} v${AppConstants.appVersion}',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: AppConstants.appVersion,
                      applicationLegalese: '© 2024 Monea. Todos los derechos reservados.',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            // Cerrar sesión
            MoneaButton(
              label: 'Cerrar sesión',
              icon: Icons.logout,
              variant: MoneaButtonVariant.outline,
              color: MoneaColors.error,
              isFullWidth: true,
              onPressed: () => _showLogoutDialog(context, authProvider),
            ),
            const SizedBox(height: MoneaTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
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
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Column(
                children: [
                  entry.value,
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

  void _showProfileSheet(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    final usernameController = TextEditingController(text: user?.username ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? MoneaColors.darkCard
              : MoneaColors.parchment,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(MoneaTheme.radiusXl)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MoneaTheme.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MoneaColors.softLinen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: MoneaTheme.spacingMd),

              Text(
                'Editar perfil',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: MoneaTheme.spacingLg),

              MoneaInput(
                controller: usernameController,
                label: 'Nombre de usuario',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: MoneaTheme.spacingMd),

              MoneaInput(
                controller: emailController,
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: MoneaTheme.spacingLg),

              Row(
                children: [
                  Expanded(
                    child: MoneaButton(
                      label: 'Cancelar',
                      variant: MoneaButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: MoneaTheme.spacingSm),
                  Expanded(
                    flex: 2,
                    child: MoneaButton(
                      label: 'Guardar cambios',
                      variant: MoneaButtonVariant.solid,
                      onPressed: () async {
                        await authProvider.updateProfile({
                          'username': usernameController.text,
                          'email': emailController.text,
                        });
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(MoneaTheme.spacingMd),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MoneaColors.parchmentLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: MoneaColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
