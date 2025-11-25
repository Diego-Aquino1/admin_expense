import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/core.dart';
import '../../providers/analytics_provider.dart';
import '../../config/constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0; // 0: Este mes, 1: Último mes, 2: 3 meses, 3: 6 meses

  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<AnalyticsProvider>();
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = now;

    await Future.wait([
      provider.loadExpensesByCategory(startDate, endDate),
      provider.loadMonthlyTrend(months: 6),
      provider.loadNetWorth(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: isDark ? MoneaColors.darkBackground : MoneaColors.porcelainLight,
            title: Text(
              'Análisis',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _buildPeriodSelector(isDark),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(isDark),
            _buildCategoriesTab(isDark),
            _buildTrendsTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MoneaTheme.spacingMd),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Resumen'),
          Tab(text: 'Categorías'),
          Tab(text: 'Tendencias'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark) {
    final provider = context.watch<AnalyticsProvider>();
    final netWorth = provider.netWorth;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Net Worth Card
          _buildNetWorthCard(netWorth, isDark),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Periodo selector
          _buildPeriodChips(isDark),
          const SizedBox(height: MoneaTheme.spacingMd),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: MoneaStatCard(
                  label: 'Ingresos',
                  value: _currencyFormat.format(netWorth?['total_income'] ?? 0),
                  icon: Icons.arrow_downward,
                  iconColor: MoneaColors.success,
                  valueColor: MoneaColors.success,
                ),
              ),
              const SizedBox(width: MoneaTheme.spacingSm),
              Expanded(
                child: MoneaStatCard(
                  label: 'Gastos',
                  value: _currencyFormat.format(netWorth?['total_expenses'] ?? 0),
                  icon: Icons.arrow_upward,
                  iconColor: MoneaColors.error,
                  valueColor: MoneaColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Gráfico de tendencia mini
          MoneaSectionHeader(
            title: 'Balance Mensual',
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          _buildMiniTrendChart(provider.monthlyTrend, isDark),
        ],
      ),
    );
  }

  Widget _buildNetWorthCard(Map<String, dynamic>? netWorth, bool isDark) {
    final total = netWorth?['net_worth'] ?? 0.0;
    final assets = netWorth?['total_assets'] ?? 0.0;
    final liabilities = netWorth?['total_liabilities'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(MoneaTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [MoneaColors.darkCard, MoneaColors.darkSurface]
              : [MoneaColors.parchmentLight, MoneaColors.porcelain.withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(MoneaTheme.radiusLg),
        border: Border.all(
          color: isDark ? MoneaColors.darkBorder : MoneaColors.softLinen,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patrimonio Neto',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
          ),
          const SizedBox(height: MoneaTheme.spacingXs),
          Text(
            _currencyFormat.format(total),
            style: MoneaTypography.amountLarge,
          ),
          const SizedBox(height: MoneaTheme.spacingMd),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activos',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(assets),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: MoneaColors.success,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasivos',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(liabilities),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: MoneaColors.error,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChips(bool isDark) {
    final periods = ['Este mes', 'Último mes', '3 meses', '6 meses'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.asMap().entries.map((entry) {
          final isSelected = _selectedPeriod == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: MoneaTheme.spacingXs),
            child: FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (value) {
                setState(() => _selectedPeriod = entry.key);
                _loadData();
              },
              backgroundColor: isDark ? MoneaColors.darkSurface : MoneaColors.parchment,
              selectedColor: MoneaColors.parchmentLight,
              checkmarkColor: MoneaColors.textPrimary,
              side: BorderSide(
                color: isSelected ? MoneaColors.porcelain : MoneaColors.softLinen,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMiniTrendChart(List<Map<String, dynamic>> data, bool isDark) {
    if (data.isEmpty) {
      return const MoneaSkeleton.card(height: 150);
    }

    return MoneaCard(
      variant: MoneaCardVariant.outlined,
      child: SizedBox(
        height: 150,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((e) {
                  return FlSpot(
                    e.key.toDouble(),
                    (e.value['balance'] ?? 0).toDouble(),
                  );
                }).toList(),
                isCurved: true,
                color: MoneaColors.porcelain,
                barWidth: 3,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: MoneaColors.porcelain.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(bool isDark) {
    final provider = context.watch<AnalyticsProvider>();
    final categories = provider.expensesByCategory;

    if (categories.isEmpty) {
      return Center(
        child: MoneaEmptyState(
          title: 'Sin datos',
          description: 'No hay gastos en este período',
          icon: Icons.pie_chart_outline,
        ),
      );
    }

    // Calcular total
    final total = categories.fold<double>(
      0,
      (sum, cat) => sum + (cat['amount'] ?? 0).toDouble(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Column(
        children: [
          // Donut Chart
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: categories.asMap().entries.map((entry) {
                      final cat = entry.value;
                      final amount = (cat['amount'] ?? 0).toDouble();
                      final percentage = total > 0 ? (amount / total * 100) : 0;
                      
                      return PieChartSectionData(
                        value: amount,
                        color: _getCategoryColor(entry.key),
                        radius: 40,
                        title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                        titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      _currencyFormat.format(total),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Lista de categorías
          ...categories.asMap().entries.map((entry) {
            final cat = entry.value;
            final amount = (cat['amount'] ?? 0).toDouble();
            final percentage = total > 0 ? (amount / total * 100) : 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
              child: MoneaCard(
                variant: MoneaCardVariant.outlined,
                padding: const EdgeInsets.all(MoneaTheme.spacingSm),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(entry.key),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: MoneaTheme.spacingSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat['category_name'] ?? 'Sin categoría',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: MoneaColors.softLinen.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation(
                                _getCategoryColor(entry.key),
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: MoneaTheme.spacingSm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _currencyFormat.format(amount),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrendsTab(bool isDark) {
    final provider = context.watch<AnalyticsProvider>();
    final trend = provider.monthlyTrend;

    if (trend.isEmpty) {
      return Center(
        child: MoneaEmptyState(
          title: 'Sin datos históricos',
          description: 'Registra transacciones para ver tendencias',
          icon: Icons.show_chart,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gráfico de barras
          MoneaSectionHeader(
            title: 'Ingresos vs Gastos',
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          MoneaCard(
            variant: MoneaCardVariant.outlined,
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(trend),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= trend.length) return const SizedBox();
                          final month = trend[value.toInt()]['month'] ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              month.toString().substring(5, 7),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: trend.asMap().entries.map((entry) {
                    final data = entry.value;
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: (data['income'] ?? 0).toDouble(),
                          color: MoneaColors.success,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: (data['expenses'] ?? 0).toDouble(),
                          color: MoneaColors.error,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: MoneaTheme.spacingSm),

          // Leyenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Ingresos', MoneaColors.success),
              const SizedBox(width: MoneaTheme.spacingMd),
              _buildLegendItem('Gastos', MoneaColors.error),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Resumen mensual
          MoneaSectionHeader(
            title: 'Detalle por Mes',
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: MoneaTheme.spacingSm),

          ...trend.reversed.map((month) {
            final income = (month['income'] ?? 0).toDouble();
            final expenses = (month['expenses'] ?? 0).toDouble();
            final balance = income - expenses;

            return Padding(
              padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
              child: MoneaCard(
                variant: MoneaCardVariant.outlined,
                padding: const EdgeInsets.all(MoneaTheme.spacingSm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        month['month'] ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _currencyFormat.format(balance),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: balance >= 0
                                    ? MoneaColors.success
                                    : MoneaColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Balance',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    double max = 0;
    for (final month in data) {
      final income = (month['income'] ?? 0).toDouble();
      final expenses = (month['expenses'] ?? 0).toDouble();
      if (income > max) max = income;
      if (expenses > max) max = expenses;
    }
    return max * 1.1;
  }

  Color _getCategoryColor(int index) {
    final colors = [
      MoneaColors.porcelain,
      MoneaColors.success,
      MoneaColors.info,
      MoneaColors.warning,
      MoneaColors.error,
      MoneaColors.softLinen,
      const Color(0xFF9B8B7E),
      const Color(0xFF7E9B8B),
      const Color(0xFF8B7E9B),
      const Color(0xFF9B7E8B),
    ];
    return colors[index % colors.length];
  }
}
