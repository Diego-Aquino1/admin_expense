import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/goal_provider.dart';
import '../../config/constants.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoalProvider>().loadGoals();
    });
  }

  void _showAddGoalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddGoalSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goals = goalProvider.goals;

    return Scaffold(
      appBar: MoneaAppBar(
        title: 'Metas Financieras',
        actions: [
          MoneaIconButton(
            icon: Icons.add,
            onPressed: _showAddGoalSheet,
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
      body: goalProvider.isLoading && goals.isEmpty
          ? _buildSkeleton()
          : RefreshIndicator(
              onRefresh: () => goalProvider.loadGoals(),
              color: MoneaColors.porcelain,
              child: goals.isEmpty
                  ? Center(
                      child: MoneaEmptyState.goals(
                        onAction: _showAddGoalSheet,
                      ),
                    )
                  : _buildGoalsList(goals, isDark),
            ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
        child: MoneaSkeleton.card(height: 160),
      ),
    );
  }

  Widget _buildGoalsList(List<Map<String, dynamic>> goals, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return _buildGoalCard(goal, isDark);
      },
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal, bool isDark) {
    final target = (goal['target_amount'] ?? 0).toDouble();
    final current = (goal['current_amount'] ?? 0).toDouble();
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final isCompleted = progress >= 1.0;

    final targetDate = goal['target_date'] != null
        ? DateTime.parse(goal['target_date'])
        : null;

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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isCompleted
                        ? LinearGradient(
                            colors: [MoneaColors.success, MoneaColors.success.withOpacity(0.7)],
                          )
                        : MoneaColors.primaryGradient,
                    borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.flag_outlined,
                    color: isDark ? MoneaColors.darkBackground : MoneaColors.textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: MoneaTheme.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal['name'] ?? 'Meta',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (targetDate != null)
                        Text(
                          'Meta: ${DateFormat(AppConstants.dateFormatMedium).format(targetDate)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MoneaColors.successLight,
                      borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 14, color: MoneaColors.success),
                        const SizedBox(width: 4),
                        Text(
                          'Completada',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: MoneaColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Progreso visual
            Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: MoneaColors.softLinen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: isCompleted
                          ? LinearGradient(
                              colors: [MoneaColors.success, MoneaColors.success.withOpacity(0.7)],
                            )
                          : MoneaColors.primaryGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
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
                      'Ahorrado',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(current),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: MoneaColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Objetivo',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(target),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),

            if (!isCompleted) ...[
              const SizedBox(height: MoneaTheme.spacingMd),
              MoneaButton(
                label: 'Agregar aporte',
                icon: Icons.add,
                variant: MoneaButtonVariant.soft,
                isFullWidth: true,
                onPressed: () {
                  _showContributeDialog(goal);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showContributeDialog(Map<String, dynamic> goal) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar aporte'),
        content: MoneaAmountInput(
          controller: controller,
          label: 'Monto a aportar',
        ),
        actions: [
          MoneaButton(
            label: 'Cancelar',
            variant: MoneaButtonVariant.ghost,
            onPressed: () => Navigator.pop(context),
          ),
          MoneaButton(
            label: 'Aportar',
            variant: MoneaButtonVariant.solid,
            onPressed: () async {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                await context.read<GoalProvider>().addContribution(
                      goal['id'],
                      amount,
                      null,
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _targetDate;
  String _type = 'savings';

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    final provider = context.read<GoalProvider>();
    final success = await provider.createGoal({
      'name': _nameController.text,
      'type': _type,
      'target_amount': double.tryParse(_amountController.text) ?? 0,
      'target_date': _targetDate?.toIso8601String(),
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
              'Nueva Meta',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            MoneaInput(
              controller: _nameController,
              label: 'Nombre de la meta',
              hint: 'Ej: Fondo de emergencia',
              prefixIcon: Icons.flag_outlined,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaAmountInput(
              controller: _amountController,
              label: 'Monto objetivo',
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaButton(
              label: _targetDate != null
                  ? DateFormat(AppConstants.dateFormatMedium).format(_targetDate!)
                  : 'Fecha objetivo (opcional)',
              icon: Icons.calendar_today_outlined,
              variant: MoneaButtonVariant.outline,
              isFullWidth: true,
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 90)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                );
                if (date != null) {
                  setState(() => _targetDate = date);
                }
              },
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
                    label: 'Crear meta',
                    variant: MoneaButtonVariant.solid,
                    onPressed: _saveGoal,
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
