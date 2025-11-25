import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/analytics_provider.dart';
import '../../config/constants.dart';

class CanSpendScreen extends StatefulWidget {
  const CanSpendScreen({super.key});

  @override
  State<CanSpendScreen> createState() => _CanSpendScreenState();
}

class _CanSpendScreenState extends State<CanSpendScreen> {
  final _amountController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  bool _hasAnalyzed = false;
  String _recommendation = '';
  Map<String, dynamic>? _analysis;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _analyze() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    // Obtener datos para análisis
    final analyticsProvider = context.read<AnalyticsProvider>();

    final summary = analyticsProvider.dashboardSummary;

    // Simular análisis (en producción vendría del backend)
    final monthIncome = (summary?['month_incomes'] ?? 0).toDouble();
    final monthExpenses = (summary?['month_expenses'] ?? 0).toDouble();
    final currentBalance = monthIncome - monthExpenses;
    final projectedExpenses = monthExpenses + amount;

    // Calcular recomendación
    String rec = '';
    String level = 'danger';

    if (amount <= currentBalance * 0.1) {
      level = 'safe';
      rec = 'Este gasto representa menos del 10% de tu balance disponible. ¡Puedes hacerlo sin problemas!';
    } else if (amount <= currentBalance * 0.3) {
      level = 'caution';
      rec = 'Este gasto es significativo pero manejable. Considera si es realmente necesario.';
    } else if (amount <= currentBalance * 0.5) {
      level = 'warning';
      rec = 'Este gasto consumiría gran parte de tu presupuesto disponible. Te recomendamos esperar o buscar alternativas.';
    } else {
      level = 'danger';
      rec = 'Este gasto excede lo que puedes permitirte ahora. Considera ahorrar más primero o buscar un precio menor.';
    }

    setState(() {
      _hasAnalyzed = true;
      _recommendation = rec;
      _analysis = {
        'amount': amount,
        'current_balance': currentBalance,
        'month_income': monthIncome,
        'month_expenses': monthExpenses,
        'projected_expenses': projectedExpenses,
        'level': level,
        'percentage_of_balance': currentBalance > 0 ? (amount / currentBalance * 100) : 100,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const MoneaAppBar(
        title: '¿Puedo gastar esto?',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MoneaTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(isDark),
            const SizedBox(height: MoneaTheme.spacingLg),

            // Input de monto
            MoneaCard(
              variant: MoneaCardVariant.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Cuánto quieres gastar?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: MoneaTheme.spacingMd),
                  MoneaAmountInput(
                    controller: _amountController,
                    autofocus: true,
                  ),
                  const SizedBox(height: MoneaTheme.spacingMd),
                  MoneaButton(
                    label: 'Analizar',
                    icon: Icons.search,
                    variant: MoneaButtonVariant.solid,
                    isFullWidth: true,
                    onPressed: _analyze,
                  ),
                ],
              ),
            ),

            // Resultados
            if (_hasAnalyzed) ...[
              const SizedBox(height: MoneaTheme.spacingLg),
              _buildResultCard(isDark),
              const SizedBox(height: MoneaTheme.spacingMd),
              _buildAnalysisDetails(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: MoneaColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: MoneaTheme.shadowMd,
          ),
          child: Icon(
            Icons.help_outline,
            size: 40,
            color: isDark ? MoneaColors.darkBackground : MoneaColors.textPrimary,
          ),
        ),
        const SizedBox(height: MoneaTheme.spacingMd),
        Text(
          'Evalúa tu gasto',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: MoneaTheme.spacingXs),
        Text(
          'Te ayudamos a decidir si puedes permitirte un gasto basado en tu situación financiera actual',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResultCard(bool isDark) {
    final level = _analysis?['level'] ?? 'danger';

    Color resultColor;
    IconData resultIcon;
    String resultTitle;

    switch (level) {
      case 'safe':
        resultColor = MoneaColors.success;
        resultIcon = Icons.check_circle;
        resultTitle = '¡Sí puedes!';
        break;
      case 'caution':
        resultColor = MoneaColors.warning;
        resultIcon = Icons.info;
        resultTitle = 'Con precaución';
        break;
      case 'warning':
        resultColor = MoneaColors.warning;
        resultIcon = Icons.warning_amber;
        resultTitle = 'No recomendado';
        break;
      default:
        resultColor = MoneaColors.error;
        resultIcon = Icons.cancel;
        resultTitle = 'No es buen momento';
    }

    return MoneaCard(
      variant: MoneaCardVariant.outlined,
      borderColor: resultColor.withOpacity(0.5),
      backgroundColor: resultColor.withOpacity(0.05),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              resultIcon,
              size: 32,
              color: resultColor,
            ),
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          Text(
            resultTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: resultColor,
                ),
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          Text(
            _recommendation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisDetails(bool isDark) {
    if (_analysis == null) return const SizedBox();

    return MoneaCard(
      variant: MoneaCardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análisis detallado',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MoneaTheme.spacingMd),

          _buildAnalysisRow(
            'Monto a gastar',
            _currencyFormat.format(_analysis!['amount']),
            null,
          ),
          const Divider(height: MoneaTheme.spacingMd),
          _buildAnalysisRow(
            'Balance disponible',
            _currencyFormat.format(_analysis!['current_balance']),
            MoneaColors.success,
          ),
          const Divider(height: MoneaTheme.spacingMd),
          _buildAnalysisRow(
            'Ingresos del mes',
            _currencyFormat.format(_analysis!['month_income']),
            null,
          ),
          const Divider(height: MoneaTheme.spacingMd),
          _buildAnalysisRow(
            'Gastos del mes',
            _currencyFormat.format(_analysis!['month_expenses']),
            MoneaColors.error,
          ),
          const Divider(height: MoneaTheme.spacingMd),
          _buildAnalysisRow(
            '% del balance',
            '${(_analysis!['percentage_of_balance'] as double).toStringAsFixed(1)}%',
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MoneaColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
