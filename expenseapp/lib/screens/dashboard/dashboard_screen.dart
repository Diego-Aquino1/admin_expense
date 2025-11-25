import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/account_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  Future<void> _refreshData() async {
    final analyticsProvider = context.read<AnalyticsProvider>();
    final accountProvider = context.read<AccountProvider>();
    final transactionProvider = context.read<TransactionProvider>();

    await Future.wait([
      analyticsProvider.loadDashboardSummary(),
      accountProvider.loadAccounts(),
      transactionProvider.loadTransactions(limit: 10),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final analyticsProvider = context.watch<AnalyticsProvider>();
    final accountProvider = context.watch<AccountProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isLoading = analyticsProvider.isLoading;
    final summary = analyticsProvider.dashboardSummary;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: MoneaColors.porcelain,
        child: isLoading && summary == null
            ? const MoneaDashboardSkeleton()
            : CustomScrollView(
                slivers: [
                  // Header con saludo
                  SliverToBoxAdapter(
                    child: _buildHeader(authProvider.user, isDark),
                  ),

                  // Balance total
                  SliverToBoxAdapter(
                    child: _buildBalanceCard(
                      accountProvider.totalBalance,
                      summary,
                      isDark,
                    ),
                  ),

                  // Estadísticas rápidas
                  SliverToBoxAdapter(
                    child: _buildQuickStats(summary, isDark),
                  ),

                  // Acciones rápidas
                  SliverToBoxAdapter(
                    child: _buildQuickActions(isDark),
                  ),

                  // Transacciones recientes
                  SliverToBoxAdapter(
                    child: MoneaSectionHeader(
                      title: 'Movimientos Recientes',
                      actionLabel: 'Ver todos',
                      onAction: () => context.push('/transactions'),
                    ),
                  ),

                  // Lista de transacciones
                  _buildTransactionsList(
                    transactionProvider.transactions,
                    isDark,
                  ),

                  // Espacio final
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + MoneaTheme.spacingMd,
        left: MoneaTheme.spacingMd,
        right: MoneaTheme.spacingMd,
        bottom: MoneaTheme.spacingSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MoneaColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.username ?? 'Usuario',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          MoneaIconButton(
            icon: Icons.notifications_outlined,
            onPressed: () => context.push('/alerts'),
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    double balance,
    Map<String, dynamic>? summary,
    bool isDark,
  ) {
    final monthBalance = summary?['month_balance'] ?? 0.0;
    final isPositive = monthBalance >= 0;

    return Padding(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Container(
        padding: const EdgeInsets.all(MoneaTheme.spacingLg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [MoneaColors.darkCard, MoneaColors.darkSurface]
                : [MoneaColors.parchmentLight, MoneaColors.porcelain.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(MoneaTheme.radiusLg),
          border: Border.all(
            color: isDark ? MoneaColors.darkBorder : MoneaColors.softLinen,
            width: MoneaTheme.borderWidth,
          ),
          boxShadow: MoneaTheme.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saldo Total',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? MoneaColors.darkTextSecondary
                            : MoneaColors.textSecondary,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? MoneaColors.successLight
                        : MoneaColors.errorLight,
                    borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color:
                            isPositive ? MoneaColors.success : MoneaColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Este mes',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isPositive
                                  ? MoneaColors.success
                                  : MoneaColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingSm),
            Text(
              _currencyFormat.format(balance),
              style: MoneaTypography.amountLarge.copyWith(
                color: isDark
                    ? MoneaColors.darkTextPrimary
                    : MoneaColors.textPrimary,
              ),
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Balance del mes
            Row(
              children: [
                Expanded(
                  child: _buildBalanceIndicator(
                    'Ingresos',
                    summary?['month_incomes']?.toDouble() ?? 0.0,
                    MoneaColors.success,
                    Icons.arrow_downward,
                    isDark,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: isDark ? MoneaColors.darkBorder : MoneaColors.softLinen,
                ),
                Expanded(
                  child: _buildBalanceIndicator(
                    'Gastos',
                    summary?['month_expenses']?.toDouble() ?? 0.0,
                    MoneaColors.error,
                    Icons.arrow_upward,
                    isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceIndicator(
    String label,
    double amount,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MoneaTheme.spacingSm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? MoneaColors.darkTextSecondary
                            : MoneaColors.textSecondary,
                      ),
                ),
                Text(
                  _currencyFormat.format(amount),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic>? summary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MoneaTheme.spacingMd),
      child: Row(
        children: [
          Expanded(
            child: MoneaStatCard(
              label: 'Presupuestos',
              value: '${summary?['budget_count'] ?? 0} activos',
              icon: Icons.pie_chart_outline,
              iconColor: MoneaColors.info,
              onTap: () => context.push('/budgets'),
            ),
          ),
          const SizedBox(width: MoneaTheme.spacingSm),
          Expanded(
            child: MoneaStatCard(
              label: 'Metas',
              value: '${summary?['goal_count'] ?? 0} en progreso',
              icon: Icons.flag_outlined,
              iconColor: MoneaColors.warning,
              onTap: () => context.push('/goals'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Row(
        children: [
          _buildQuickAction(
            icon: Icons.help_outline,
            label: '¿Puedo gastar?',
            onTap: () => context.push('/can-spend'),
            isDark: isDark,
          ),
          const SizedBox(width: MoneaTheme.spacingSm),
          _buildQuickAction(
            icon: Icons.credit_card_outlined,
            label: 'Tarjetas',
            onTap: () => context.push('/credit-cards'),
            isDark: isDark,
          ),
          const SizedBox(width: MoneaTheme.spacingSm),
          _buildQuickAction(
            icon: Icons.trending_up_outlined,
            label: 'Inversiones',
            onTap: () => context.push('/investments'),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: MoneaCard(
        variant: MoneaCardVariant.outlined,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(
          vertical: MoneaTheme.spacingSm,
          horizontal: MoneaTheme.spacingXs,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MoneaColors.parchmentLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark
                    ? MoneaColors.darkTextPrimary
                    : MoneaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<dynamic> transactions, bool isDark) {
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: MoneaEmptyState.transactions(
          compact: true,
          onAction: () {
            // Abrir modal de agregar
          },
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= transactions.length) return null;
          final transaction = transactions[index];
          return _buildTransactionItem(transaction, isDark);
        },
        childCount: transactions.length > 5 ? 5 : transactions.length,
      ),
    );
  }

  Widget _buildTransactionItem(dynamic transaction, bool isDark) {
    final type = transaction.type;
    final isExpense = type == 'expense';
    final isIncome = type == 'income';
    final amount = transaction.amount;
    final date = transaction.date;

    Color amountColor;
    String prefix;
    IconData icon;

    if (isExpense) {
      amountColor = MoneaColors.expense;
      prefix = '-';
      icon = Icons.arrow_upward;
    } else if (isIncome) {
      amountColor = MoneaColors.income;
      prefix = '+';
      icon = Icons.arrow_downward;
    } else {
      amountColor = MoneaColors.transfer;
      prefix = '';
      icon = Icons.swap_horiz;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MoneaTheme.spacingMd,
        vertical: MoneaTheme.spacingXs,
      ),
      child: MoneaCard(
        variant: MoneaCardVariant.ghost,
        onTap: () {
          // Navegar al detalle
        },
        padding: const EdgeInsets.all(MoneaTheme.spacingSm),
        child: Row(
          children: [
            // Icono
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
              ),
              child: Icon(icon, size: 20, color: amountColor),
            ),
            const SizedBox(width: MoneaTheme.spacingSm),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.categoryName ?? 'Sin categoría',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat(AppConstants.dateFormatShort).format(date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Monto
            Text(
              '$prefix${_currencyFormat.format(amount)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
