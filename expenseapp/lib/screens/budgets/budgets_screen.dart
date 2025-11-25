import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/budget_provider.dart';
import '../../config/constants.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetProvider>().loadBudgets();
    });
  }

  void _showAddBudgetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddBudgetSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final budgets = budgetProvider.budgets;

    return Scaffold(
      appBar: MoneaAppBar(
        title: 'Presupuestos',
        actions: [
          MoneaIconButton(
            icon: Icons.add,
            onPressed: _showAddBudgetSheet,
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
      body: budgetProvider.isLoading && budgets.isEmpty
          ? _buildSkeleton()
          : RefreshIndicator(
              onRefresh: () => budgetProvider.loadBudgets(),
              color: MoneaColors.porcelain,
              child: budgets.isEmpty
                  ? Center(
                      child: MoneaEmptyState.budgets(
                        onAction: _showAddBudgetSheet,
                      ),
                    )
                  : _buildBudgetsList(budgets, isDark),
            ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
        child: MoneaSkeleton.card(height: 120),
      ),
    );
  }

  Widget _buildBudgetsList(List<Map<String, dynamic>> budgets, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        return _buildBudgetCard(budget, isDark);
      },
    );
  }

  Widget _buildBudgetCard(Map<String, dynamic> budget, bool isDark) {
    final limit = (budget['amount'] ?? 0).toDouble();
    final spent = (budget['spent'] ?? 0).toDouble();
    final remaining = limit - spent;
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = spent > limit;

    Color progressColor;
    if (progress < 0.7) {
      progressColor = MoneaColors.success;
    } else if (progress < 0.9) {
      progressColor = MoneaColors.warning;
    } else {
      progressColor = MoneaColors.error;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
      child: MoneaCard(
        variant: MoneaCardVariant.outlined,
        onTap: () {
          // Navegar a detalle
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
                  ),
                  child: Icon(
                    Icons.pie_chart_outline,
                    color: progressColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: MoneaTheme.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget['category_name'] ?? 'Sin categoría',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        budget['period'] == 'monthly' ? 'Mensual' : budget['period'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOverBudget ? MoneaColors.errorLight : MoneaColors.successLight,
                    borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
                  ),
                  child: Text(
                    isOverBudget ? 'Excedido' : 'En curso',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isOverBudget ? MoneaColors.error : MoneaColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: MoneaColors.softLinen.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation(progressColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: MoneaTheme.spacingSm),

            // Montos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gastado',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(spent),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: progressColor,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Límite',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(limit),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),

            if (!isOverBudget) ...[
              const SizedBox(height: MoneaTheme.spacingSm),
              Container(
                padding: const EdgeInsets.all(MoneaTheme.spacingSm),
                decoration: BoxDecoration(
                  color: MoneaColors.parchmentLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: MoneaColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Te quedan ${_currencyFormat.format(remaining)} por gastar',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddBudgetSheet extends StatefulWidget {
  const _AddBudgetSheet();

  @override
  State<_AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<_AddBudgetSheet> {
  final _amountController = TextEditingController();
  int? _categoryId;
  String _period = 'monthly';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    if (_amountController.text.isEmpty) return;

    final provider = context.read<BudgetProvider>();
    final success = await provider.createBudget({
      'category_id': _categoryId,
      'amount': double.tryParse(_amountController.text) ?? 0,
      'period': _period,
      'start_date': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkCard : MoneaColors.parchment,
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
              'Nuevo Presupuesto',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            MoneaAmountInput(
              controller: _amountController,
              label: 'Límite de gasto',
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            Text(
              'Período',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingSm),
            MoneaButtonGroup<String>(
              options: const ['weekly', 'monthly', 'yearly'],
              selectedValue: _period,
              labelBuilder: (period) {
                switch (period) {
                  case 'weekly':
                    return 'Semanal';
                  case 'monthly':
                    return 'Mensual';
                  case 'yearly':
                    return 'Anual';
                  default:
                    return period;
                }
              },
              onChanged: (value) {
                setState(() => _period = value);
              },
              isFullWidth: true,
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
                    label: 'Crear presupuesto',
                    variant: MoneaButtonVariant.solid,
                    onPressed: _saveBudget,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
