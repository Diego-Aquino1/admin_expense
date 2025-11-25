import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Controla tus finanzas',
      description:
          'Registra tus ingresos y gastos de forma fácil y rápida. Ten el control total de tu dinero.',
    ),
    _OnboardingPage(
      icon: Icons.pie_chart_rounded,
      title: 'Presupuestos inteligentes',
      description:
          'Crea presupuestos por categoría y recibe alertas cuando estés cerca de tu límite.',
    ),
    _OnboardingPage(
      icon: Icons.flag_rounded,
      title: 'Alcanza tus metas',
      description:
          'Define objetivos financieros y observa tu progreso hacia la libertad financiera.',
    ),
    _OnboardingPage(
      icon: Icons.insights_rounded,
      title: 'Análisis detallado',
      description:
          'Visualiza tus patrones de gasto y toma mejores decisiones con datos reales.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/');
    }
  }

  void _skip() {
    context.go('/');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(MoneaTheme.spacingMd),
                child: MoneaButton(
                  label: 'Saltar',
                  variant: MoneaButtonVariant.ghost,
                  onPressed: _skip,
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),

            // Indicators and button
            Padding(
              padding: const EdgeInsets.all(MoneaTheme.spacingLg),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index, isDark),
                    ),
                  ),
                  const SizedBox(height: MoneaTheme.spacingLg),

                  // Continue button
                  MoneaButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Comenzar'
                        : 'Continuar',
                    variant: MoneaButtonVariant.solid,
                    isFullWidth: true,
                    trailingIcon: Icons.arrow_forward,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index, bool isDark) {
    final isActive = index == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? MoneaColors.porcelain
            : (isDark ? MoneaColors.darkBorder : MoneaColors.softLinen),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(MoneaTheme.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  MoneaColors.parchmentLight.withOpacity(0.5),
                  MoneaColors.parchmentLight.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: MoneaColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: MoneaTheme.shadowLg,
                ),
                child: Icon(
                  icon,
                  size: 50,
                  color:
                      isDark ? MoneaColors.darkBackground : MoneaColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: MoneaTheme.spacingXl),

          // Title
          Text(
            title,
            style: MoneaTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
