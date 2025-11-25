import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/credit_card_provider.dart';
import '../../config/constants.dart';

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({super.key});

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreditCardProvider>().loadCreditCards();
    });
  }

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddCreditCardSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreditCardProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cards = provider.creditCards;

    return Scaffold(
      appBar: MoneaAppBar(
        title: 'Tarjetas de Crédito',
        actions: [
          MoneaIconButton(
            icon: Icons.add,
            onPressed: _showAddCardSheet,
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
      body: provider.isLoading && cards.isEmpty
          ? _buildSkeleton()
          : RefreshIndicator(
              onRefresh: () => provider.loadCreditCards(),
              color: MoneaColors.porcelain,
              child: cards.isEmpty
                  ? Center(
                      child: MoneaEmptyState(
                        title: 'Sin tarjetas',
                        description: 'Agrega tus tarjetas de crédito para llevar un mejor control',
                        icon: Icons.credit_card_outlined,
                        actionLabel: 'Agregar tarjeta',
                        onAction: _showAddCardSheet,
                      ),
                    )
                  : _buildCardsList(cards, isDark),
            ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
        child: MoneaSkeleton.card(height: 200),
      ),
    );
  }

  Widget _buildCardsList(List<Map<String, dynamic>> cards, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return _buildCreditCard(card, isDark);
      },
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> card, bool isDark) {
    final limit = (card['credit_limit'] ?? 0).toDouble();
    final used = (card['current_balance'] ?? 0).toDouble();
    final available = limit - used;
    final usage = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;

    Color usageColor;
    if (usage < 0.3) {
      usageColor = MoneaColors.success;
    } else if (usage < 0.7) {
      usageColor = MoneaColors.warning;
    } else {
      usageColor = MoneaColors.error;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: MoneaTheme.spacingMd),
      child: MoneaCard(
        variant: MoneaCardVariant.outlined,
        onTap: () {
          // Navegar a detalle
        },
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Header de tarjeta
            Container(
              padding: const EdgeInsets.all(MoneaTheme.spacingMd),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MoneaColors.textPrimary,
                    MoneaColors.textPrimary.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MoneaTheme.radiusMd),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card['name'] ?? 'Tarjeta',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: MoneaColors.parchment,
                            ),
                      ),
                      Icon(
                        Icons.credit_card,
                        color: MoneaColors.parchment.withOpacity(0.7),
                      ),
                    ],
                  ),
                  const SizedBox(height: MoneaTheme.spacingMd),
                  Text(
                    '**** **** **** ${card['last_four'] ?? '0000'}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: MoneaColors.parchment,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: MoneaTheme.spacingSm),
                  Text(
                    card['bank'] ?? 'Banco',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MoneaColors.parchment.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),

            // Info de uso
            Padding(
              padding: const EdgeInsets.all(MoneaTheme.spacingMd),
              child: Column(
                children: [
                  // Barra de uso
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crédito utilizado',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: usage,
                                backgroundColor: MoneaColors.softLinen.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation(usageColor),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: MoneaTheme.spacingSm),
                      Text(
                        '${(usage * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: usageColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MoneaTheme.spacingMd),

                  // Montos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardStat(
                        'Usado',
                        _currencyFormat.format(used),
                        usageColor,
                      ),
                      _buildCardStat(
                        'Disponible',
                        _currencyFormat.format(available),
                        MoneaColors.success,
                      ),
                      _buildCardStat(
                        'Límite',
                        _currencyFormat.format(limit),
                        null,
                      ),
                    ],
                  ),
                  const SizedBox(height: MoneaTheme.spacingMd),

                  // Fechas de corte
                  Container(
                    padding: const EdgeInsets.all(MoneaTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: MoneaColors.parchmentLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDateInfo(
                          'Corte',
                          'Día ${card['cutoff_day'] ?? 0}',
                          Icons.calendar_today_outlined,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: MoneaColors.softLinen,
                        ),
                        _buildDateInfo(
                          'Pago',
                          'Día ${card['payment_day'] ?? 0}',
                          Icons.payment_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStat(String label, String value, Color? color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MoneaColors.textSecondary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _AddCreditCardSheet extends StatefulWidget {
  const _AddCreditCardSheet();

  @override
  State<_AddCreditCardSheet> createState() => _AddCreditCardSheetState();
}

class _AddCreditCardSheetState extends State<_AddCreditCardSheet> {
  final _nameController = TextEditingController();
  final _limitController = TextEditingController();
  final _bankController = TextEditingController();
  int _cutoffDay = 15;
  int _paymentDay = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    if (_nameController.text.isEmpty || _limitController.text.isEmpty) return;

    final provider = context.read<CreditCardProvider>();
    final success = await provider.createCreditCard({
      'name': _nameController.text,
      'bank': _bankController.text.isNotEmpty ? _bankController.text : null,
      'credit_limit': double.tryParse(_limitController.text) ?? 0,
      'cutoff_day': _cutoffDay,
      'payment_day': _paymentDay,
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
              'Nueva Tarjeta',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            MoneaInput(
              controller: _nameController,
              label: 'Nombre de la tarjeta',
              hint: 'Ej: BBVA Oro',
              prefixIcon: Icons.credit_card,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaInput(
              controller: _bankController,
              label: 'Banco (opcional)',
              hint: 'Ej: BBVA',
              prefixIcon: Icons.business,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaAmountInput(
              controller: _limitController,
              label: 'Límite de crédito',
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Día de corte',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: MoneaTheme.spacingXs),
                      MoneaDropdown<int>(
                        value: _cutoffDay,
                        items: List.generate(28, (i) => i + 1),
                        labelBuilder: (day) => 'Día $day',
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _cutoffDay = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: MoneaTheme.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Día de pago',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: MoneaTheme.spacingXs),
                      MoneaDropdown<int>(
                        value: _paymentDay,
                        items: List.generate(28, (i) => i + 1),
                        labelBuilder: (day) => 'Día $day',
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _paymentDay = value);
                          }
                        },
                      ),
                    ],
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
                    label: 'Agregar tarjeta',
                    variant: MoneaButtonVariant.solid,
                    onPressed: _saveCard,
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
