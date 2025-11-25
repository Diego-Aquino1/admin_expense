import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/transaction_provider.dart';
import '../../config/constants.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _filterType;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions(limit: 50);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Cargar más transacciones (paginación)
    }
  }

  Future<void> _refreshTransactions() async {
    await context.read<TransactionProvider>().loadTransactions(limit: 50);
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FiltersSheet(
        filterType: _filterType,
        startDate: _filterStartDate,
        endDate: _filterEndDate,
        onApply: (type, start, end) {
          setState(() {
            _filterType = type;
            _filterStartDate = start;
            _filterEndDate = end;
          });
          // Aplicar filtros
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transactions = transactionProvider.transactions;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // AppBar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: isDark ? MoneaColors.darkBackground : MoneaColors.porcelainLight,
            title: Text(
              'Movimientos',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            actions: [
              MoneaIconButton(
                icon: Icons.filter_list,
                onPressed: _showFilters,
                variant: MoneaButtonVariant.ghost,
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Barra de búsqueda
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                MoneaTheme.spacingMd,
                0,
                MoneaTheme.spacingMd,
                MoneaTheme.spacingSm,
              ),
              child: MoneaSearchInput(
                controller: _searchController,
                hint: 'Buscar por descripción, categoría...',
                onChanged: (value) {
                  // Filtrar transacciones
                },
                onClear: () {
                  _searchController.clear();
                },
              ),
            ),
          ),

          // Filtros activos
          if (_filterType != null || _filterStartDate != null)
            SliverToBoxAdapter(
              child: _buildActiveFilters(isDark),
            ),
        ],
        body: transactionProvider.isLoading && transactions.isEmpty
            ? ListView.builder(
                itemCount: 8,
                itemBuilder: (_, __) => const MoneaTransactionSkeleton(),
              )
            : RefreshIndicator(
                onRefresh: _refreshTransactions,
                color: MoneaColors.porcelain,
                child: transactions.isEmpty
                    ? Center(
                        child: MoneaEmptyState.transactions(
                          onAction: () => context.push('/transactions/add'),
                        ),
                      )
                    : _buildTransactionsList(transactions, isDark),
              ),
      ),
    );
  }

  Widget _buildActiveFilters(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: MoneaTheme.spacingMd,
        vertical: MoneaTheme.spacingXs,
      ),
      child: Row(
        children: [
          if (_filterType != null)
            _buildFilterChip(
              _getTypeLabel(_filterType!),
              () {
                setState(() => _filterType = null);
              },
              isDark,
            ),
          if (_filterStartDate != null) ...[
            const SizedBox(width: MoneaTheme.spacingXs),
            _buildFilterChip(
              'Desde: ${DateFormat(AppConstants.dateFormatShort).format(_filterStartDate!)}',
              () {
                setState(() => _filterStartDate = null);
              },
              isDark,
            ),
          ],
          if (_filterEndDate != null) ...[
            const SizedBox(width: MoneaTheme.spacingXs),
            _buildFilterChip(
              'Hasta: ${DateFormat(AppConstants.dateFormatShort).format(_filterEndDate!)}',
              () {
                setState(() => _filterEndDate = null);
              },
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MoneaColors.parchmentLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
        border: Border.all(
          color: MoneaColors.softLinen,
          width: MoneaTheme.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 16,
              color: MoneaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'expense':
        return 'Gastos';
      case 'income':
        return 'Ingresos';
      case 'transfer':
        return 'Traspasos';
      default:
        return type;
    }
  }

  Widget _buildTransactionsList(List<dynamic> transactions, bool isDark) {
    // Agrupar por fecha
    final grouped = <String, List<dynamic>>{};
    for (final tx in transactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(tx.date);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final dayTransactions = grouped[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de fecha
            _buildDateHeader(date, dayTransactions, isDark),
            // Transacciones del día
            ...dayTransactions.map((tx) => _buildTransactionItem(tx, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(
    DateTime date,
    List<dynamic> transactions,
    bool isDark,
  ) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final isYesterday = DateUtils.isSameDay(
      date,
      DateTime.now().subtract(const Duration(days: 1)),
    );

    String dateText;
    if (isToday) {
      dateText = 'Hoy';
    } else if (isYesterday) {
      dateText = 'Ayer';
    } else {
      dateText = DateFormat(AppConstants.dateFormatMedium, 'es').format(date);
    }

    // Calcular totales del día
    double dayTotal = 0;
    for (final tx in transactions) {
      if (tx.type == 'expense') {
        dayTotal -= tx.amount;
      } else if (tx.type == 'income') {
        dayTotal += tx.amount;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        MoneaTheme.spacingMd,
        MoneaTheme.spacingMd,
        MoneaTheme.spacingMd,
        MoneaTheme.spacingXs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
          ),
          Text(
            _currencyFormat.format(dayTotal),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dayTotal >= 0 ? MoneaColors.success : MoneaColors.error,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic transaction, bool isDark) {
    final type = transaction.type;
    final isExpense = type == 'expense';
    final isIncome = type == 'income';
    final amount = transaction.amount;

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
        variant: MoneaCardVariant.outlined,
        onTap: () {
          // Navegar a detalle
        },
        padding: const EdgeInsets.all(MoneaTheme.spacingSm),
        child: Row(
          children: [
            // Icono de categoría
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
                  if (transaction.notes != null &&
                      transaction.notes.isNotEmpty)
                    Text(
                      transaction.notes,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Monto
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix${_currencyFormat.format(amount)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: amountColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  transaction.accountName ?? '',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet de filtros
class _FiltersSheet extends StatefulWidget {
  final String? filterType;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String?, DateTime?, DateTime?) onApply;

  const _FiltersSheet({
    this.filterType,
    this.startDate,
    this.endDate,
    required this.onApply,
  });

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late String? _type;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _type = widget.filterType;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkCard : MoneaColors.parchment,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(MoneaTheme.radiusXl)),
      ),
      padding: const EdgeInsets.all(MoneaTheme.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
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
            'Filtros',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Tipo de transacción
          Text(
            'Tipo de movimiento',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          MoneaButtonGroup<String?>(
            options: const [null, 'expense', 'income', 'transfer'],
            selectedValue: _type,
            labelBuilder: (type) {
              switch (type) {
                case null:
                  return 'Todos';
                case 'expense':
                  return 'Gastos';
                case 'income':
                  return 'Ingresos';
                case 'transfer':
                  return 'Traspasos';
                default:
                  return type.toString();
              }
            },
            onChanged: (value) {
              setState(() => _type = value);
            },
            isFullWidth: true,
          ),
          const SizedBox(height: MoneaTheme.spacingLg),

          // Rango de fechas
          Text(
            'Rango de fechas',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: MoneaTheme.spacingSm),
          Row(
            children: [
              Expanded(
                child: MoneaButton(
                  label: _startDate != null
                      ? DateFormat(AppConstants.dateFormatShort)
                          .format(_startDate!)
                      : 'Desde',
                  icon: Icons.calendar_today_outlined,
                  variant: MoneaButtonVariant.outline,
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _startDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(width: MoneaTheme.spacingSm),
              Expanded(
                child: MoneaButton(
                  label: _endDate != null
                      ? DateFormat(AppConstants.dateFormatShort).format(_endDate!)
                      : 'Hasta',
                  icon: Icons.calendar_today_outlined,
                  variant: MoneaButtonVariant.outline,
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _endDate = date);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: MoneaTheme.spacingXl),

          // Botones
          Row(
            children: [
              Expanded(
                child: MoneaButton(
                  label: 'Limpiar',
                  variant: MoneaButtonVariant.ghost,
                  onPressed: () {
                    setState(() {
                      _type = null;
                      _startDate = null;
                      _endDate = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: MoneaTheme.spacingSm),
              Expanded(
                flex: 2,
                child: MoneaButton(
                  label: 'Aplicar',
                  variant: MoneaButtonVariant.solid,
                  onPressed: () {
                    widget.onApply(_type, _startDate, _endDate);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
