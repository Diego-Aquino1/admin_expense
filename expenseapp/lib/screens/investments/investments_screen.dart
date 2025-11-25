import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/investment_provider.dart';
import '../../config/constants.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  final _percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvestmentProvider>().loadInvestments();
    });
  }

  void _showAddInvestmentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddInvestmentSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvestmentProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final investments = provider.investments;

    return Scaffold(
      appBar: MoneaAppBar(
        title: 'Inversiones',
        actions: [
          MoneaIconButton(
            icon: Icons.add,
            onPressed: _showAddInvestmentSheet,
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
      body: provider.isLoading && investments.isEmpty
          ? _buildSkeleton()
          : RefreshIndicator(
              onRefresh: () => provider.loadInvestments(),
              color: MoneaColors.porcelain,
              child: investments.isEmpty
                  ? Center(
                      child: MoneaEmptyState(
                        title: 'Sin inversiones',
                        description: 'Registra tus inversiones para hacer seguimiento de tu portafolio',
                        icon: Icons.trending_up_outlined,
                        actionLabel: 'Agregar inversión',
                        onAction: _showAddInvestmentSheet,
                      ),
                    )
                  : _buildInvestmentsList(investments, isDark, provider),
            ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      children: [
        MoneaSkeleton.card(height: 140),
        const SizedBox(height: MoneaTheme.spacingMd),
        ...List.generate(3, (_) => Padding(
          padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
          child: MoneaSkeleton.card(height: 100),
        )),
      ],
    );
  }

  Widget _buildInvestmentsList(
    List<Map<String, dynamic>> investments,
    bool isDark,
    InvestmentProvider provider,
  ) {
    return CustomScrollView(
      slivers: [
        // Summary card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(MoneaTheme.spacingMd),
            child: _buildSummaryCard(isDark, provider),
          ),
        ),

        // Investments list
        SliverToBoxAdapter(
          child: MoneaSectionHeader(
            title: 'Portafolio',
            padding: const EdgeInsets.only(
              left: MoneaTheme.spacingMd,
              bottom: MoneaTheme.spacingSm,
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final investment = investments[index];
              return _buildInvestmentCard(investment, isDark);
            },
            childCount: investments.length,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(bool isDark, InvestmentProvider provider) {
    final totalValue = provider.totalMarketValue;
    final totalGain = provider.totalGain;
    final isPositive = totalGain >= 0;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor del Portafolio',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MoneaColors.textSecondary,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? MoneaColors.successLight : MoneaColors.errorLight,
                  borderRadius: BorderRadius.circular(MoneaTheme.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isPositive ? MoneaColors.success : MoneaColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${_currencyFormat.format(totalGain)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isPositive ? MoneaColors.success : MoneaColors.error,
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
            _currencyFormat.format(totalValue),
            style: MoneaTypography.amountLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(Map<String, dynamic> investment, bool isDark) {
    final name = investment['name'] ?? 'Inversión';
    final type = investment['type'] ?? 'other';
    final quantity = (investment['quantity'] ?? 0).toDouble();
    final purchasePrice = (investment['purchase_price'] ?? 0).toDouble();
    final currentPrice = (investment['current_price'] ?? 0).toDouble();
    final marketValue = quantity * currentPrice;
    final costBasis = quantity * purchasePrice;
    final gain = marketValue - costBasis;
    final gainPercent = costBasis > 0 ? (gain / costBasis) : 0.0;
    final isPositive = gain >= 0;

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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTypeColor(type).withOpacity(0.15),
                borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
              ),
              child: Icon(
                _getTypeIcon(type),
                color: _getTypeColor(type),
                size: 24,
              ),
            ),
            const SizedBox(width: MoneaTheme.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${quantity.toStringAsFixed(quantity == quantity.roundToDouble() ? 0 : 4)} unidades',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currencyFormat.format(marketValue),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 16,
                      color: isPositive ? MoneaColors.success : MoneaColors.error,
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${_percentFormat.format(gainPercent)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isPositive ? MoneaColors.success : MoneaColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'stock':
        return Icons.show_chart;
      case 'bond':
        return Icons.account_balance;
      case 'crypto':
        return Icons.currency_bitcoin;
      case 'fund':
        return Icons.pie_chart;
      case 'real_estate':
        return Icons.home_work;
      default:
        return Icons.trending_up;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'stock':
        return MoneaColors.info;
      case 'bond':
        return MoneaColors.success;
      case 'crypto':
        return MoneaColors.warning;
      case 'fund':
        return MoneaColors.porcelain;
      case 'real_estate':
        return const Color(0xFF9B8B7E);
      default:
        return MoneaColors.textSecondary;
    }
  }
}

class _AddInvestmentSheet extends StatefulWidget {
  const _AddInvestmentSheet();

  @override
  State<_AddInvestmentSheet> createState() => _AddInvestmentSheetState();
}

class _AddInvestmentSheetState extends State<_AddInvestmentSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String _type = 'stock';

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveInvestment() async {
    if (_nameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return;
    }

    final provider = context.read<InvestmentProvider>();
    final success = await provider.createInvestment({
      'name': _nameController.text,
      'type': _type,
      'quantity': double.tryParse(_quantityController.text) ?? 0,
      'purchase_price': double.tryParse(_priceController.text) ?? 0,
      'current_price': double.tryParse(_priceController.text) ?? 0,
      'purchase_date': DateTime.now().toIso8601String(),
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
              'Nueva Inversión',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            MoneaInput(
              controller: _nameController,
              label: 'Nombre',
              hint: 'Ej: Apple Inc, Bitcoin',
              prefixIcon: Icons.trending_up,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaDropdown<String>(
              value: _type,
              label: 'Tipo de inversión',
              items: const ['stock', 'bond', 'crypto', 'fund', 'real_estate', 'other'],
              labelBuilder: (type) {
                switch (type) {
                  case 'stock':
                    return 'Acciones';
                  case 'bond':
                    return 'Bonos';
                  case 'crypto':
                    return 'Criptomonedas';
                  case 'fund':
                    return 'Fondos';
                  case 'real_estate':
                    return 'Bienes raíces';
                  default:
                    return 'Otro';
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            Row(
              children: [
                Expanded(
                  child: MoneaInput(
                    controller: _quantityController,
                    label: 'Cantidad',
                    hint: '0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: MoneaTheme.spacingSm),
                Expanded(
                  child: MoneaAmountInput(
                    controller: _priceController,
                    label: 'Precio de compra',
                  ),
                ),
              ],
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
                    label: 'Agregar',
                    variant: MoneaButtonVariant.solid,
                    onPressed: _saveInvestment,
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
