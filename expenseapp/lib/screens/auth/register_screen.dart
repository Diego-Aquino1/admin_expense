import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

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
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      _showErrorSnackbar('Debes aceptar los términos y condiciones');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _emailController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/onboarding');
    } else {
      _showErrorSnackbar(authProvider.error ?? 'Error al registrarse');
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
                      // Header
                      _buildHeader(isDark),
                      const SizedBox(height: MoneaTheme.spacingXl),

                      // Formulario
                      _buildRegisterForm(authProvider, isDark),
                      const SizedBox(height: MoneaTheme.spacingLg),

                      // Link a login
                      _buildLoginLink(),
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

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        // Logo pequeño
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: MoneaColors.primaryGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: MoneaTheme.shadowSm,
          ),
          child: Icon(
            Icons.person_add_rounded,
            size: 32,
            color: isDark ? MoneaColors.darkBackground : MoneaColors.textPrimary,
          ),
        ),
        const SizedBox(height: MoneaTheme.spacingMd),

        Text(
          'Crear Cuenta',
          style: MoneaTypography.displaySmall,
        ),
        const SizedBox(height: MoneaTheme.spacingXs),

        Text(
          'Comienza a tomar control de tus finanzas',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm(AuthProvider authProvider, bool isDark) {
    return MoneaCard(
      variant: MoneaCardVariant.outlined,
      padding: const EdgeInsets.all(MoneaTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email
          MoneaInput(
            controller: _emailController,
            label: 'Email',
            hint: 'tu@email.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Ingresa un email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Username
          MoneaInput(
            controller: _usernameController,
            label: 'Nombre de usuario',
            hint: 'johndoe',
            prefixIcon: Icons.alternate_email,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa un nombre de usuario';
              }
              if (value.length < AppConstants.minUsernameLength) {
                return 'Mínimo ${AppConstants.minUsernameLength} caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Password
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
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa una contraseña';
              }
              if (value.length < AppConstants.minPasswordLength) {
                return 'Mínimo ${AppConstants.minPasswordLength} caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Confirm Password
          MoneaInput(
            controller: _confirmPasswordController,
            label: 'Confirmar contraseña',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: _obscureConfirmPassword
                ? Icons.visibility_off
                : Icons.visibility,
            onSuffixIconTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleRegister(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirma tu contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Terms checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: MoneaTheme.spacingSm),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _acceptTerms = !_acceptTerms;
                    });
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Acepto los ',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Términos de Servicio',
                          style: TextStyle(
                            color: MoneaColors.porcelain,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' y la '),
                        TextSpan(
                          text: 'Política de Privacidad',
                          style: TextStyle(
                            color: MoneaColors.porcelain,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Register button
          MoneaButton(
            label: 'Crear cuenta',
            variant: MoneaButtonVariant.solid,
            isFullWidth: true,
            isLoading: authProvider.isLoading,
            onPressed: _handleRegister,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes cuenta?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.textSecondary,
              ),
        ),
        MoneaButton(
          label: 'Inicia sesión',
          variant: MoneaButtonVariant.link,
          size: MoneaButtonSize.sm,
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }
}
