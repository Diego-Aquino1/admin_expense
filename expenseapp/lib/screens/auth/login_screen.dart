import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/');
    } else {
      _showErrorSnackbar(authProvider.error ?? 'Error al iniciar sesión');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: MoneaColors.errorLight, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: MoneaColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        ),
        margin: const EdgeInsets.all(MoneaTheme.spacingMd),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(MoneaTheme.spacingLg),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo y marca
                      _buildBranding(isDark),
                      const SizedBox(height: MoneaTheme.spacing2xl),

                      // Formulario en card
                      _buildLoginForm(authProvider, isDark),
                      const SizedBox(height: MoneaTheme.spacingLg),

                      // Link a registro
                      _buildRegisterLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(bool isDark) {
    return Column(
      children: [
        // Logo animado
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MoneaColors.parchmentLight,
                      MoneaColors.porcelain,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: MoneaTheme.shadowMd,
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 44,
                  color: isDark
                      ? MoneaColors.darkBackground
                      : MoneaColors.textPrimary,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: MoneaTheme.spacingMd),

        // Nombre de la app
        Text(
          AppConstants.appName,
          style: MoneaTypography.displayMedium.copyWith(
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: MoneaTheme.spacingXs),

        // Tagline
        Text(
          AppConstants.appTagline,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthProvider authProvider, bool isDark) {
    return MoneaCard(
      variant: MoneaCardVariant.outlined,
      padding: const EdgeInsets.all(MoneaTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Iniciar Sesión',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: MoneaTheme.spacingXs),
          Text(
            'Ingresa tus credenciales para continuar',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Campo de usuario
          MoneaInput(
            controller: _usernameController,
            label: 'Usuario o email',
            hint: 'tu@email.com',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu usuario o email';
              }
              return null;
            },
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Campo de contraseña
          MoneaInput(
            controller: _passwordController,
            label: 'Contraseña',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon:
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
            onSuffixIconTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: MoneaTheme.spacingSm),

          // Olvidé contraseña
          Align(
            alignment: Alignment.centerRight,
            child: MoneaButton(
              label: '¿Olvidaste tu contraseña?',
              variant: MoneaButtonVariant.link,
              size: MoneaButtonSize.sm,
              onPressed: () {
                // TODO: Implementar recuperación
              },
            ),
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Botón de login
          MoneaButton(
            label: 'Continuar',
            variant: MoneaButtonVariant.solid,
            isFullWidth: true,
            isLoading: authProvider.isLoading,
            onPressed: _handleLogin,
            trailingIcon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.textSecondary,
              ),
        ),
        MoneaButton(
          label: 'Regístrate',
          variant: MoneaButtonVariant.link,
          size: MoneaButtonSize.sm,
          onPressed: () => context.go('/register'),
        ),
      ],
    );
  }
}
