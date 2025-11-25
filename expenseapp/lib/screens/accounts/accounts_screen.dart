import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/account_provider.dart';
import '../../config/constants.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.currencyDecimalDigits,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().loadAccounts();
    });
  }

  void _showAddAccountSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddAccountSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accounts = accountProvider.accounts;

    return Scaffold(
      appBar: MoneaAppBar(
        title: 'Cuentas',
        actions: [
          MoneaIconButton(
            icon: Icons.add,
            onPressed: _showAddAccountSheet,
            variant: MoneaButtonVariant.outline,
          ),
        ],
      ),
      body: accountProvider.isLoading && accounts.isEmpty
          ? _buildSkeleton()
          : RefreshIndicator(
              onRefresh: () => accountProvider.loadAccounts(),
              color: MoneaColors.porcelain,
              child: accounts.isEmpty
                  ? Center(
                      child: MoneaEmptyState(
                        title: 'Sin cuentas',
                        description: 'Agrega tu primera cuenta para comenzar',
                        icon: Icons.account_balance_wallet_outlined,
                        actionLabel: 'Agregar cuenta',
                        onAction: _showAddAccountSheet,
                      ),
                    )
                  : _buildAccountsList(accounts, isDark),
            ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(MoneaTheme.spacingMd),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: MoneaTheme.spacingSm),
        child: MoneaSkeleton.card(height: 90),
      ),
    );
  }

  Widget _buildAccountsList(List<dynamic> accounts, bool isDark) {
    // Calcular total
    final total = accounts.fold<double>(
      0,
      (sum, acc) => sum + acc.balance,
    );

    // Agrupar por tipo
    final byType = <String, List<dynamic>>{};
    for (final acc in accounts) {
      byType.putIfAbsent(acc.type, () => []).add(acc);
    }

    return CustomScrollView(
      slivers: [
        // Total card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(MoneaTheme.spacingMd),
            child: _buildTotalCard(total, isDark),
          ),
        ),

        // Por tipo
        ...byType.entries.expand((entry) => [
              SliverToBoxAdapter(
                child: MoneaSectionHeader(
                  title: _getTypeLabel(entry.key),
                  padding: const EdgeInsets.only(
                    left: MoneaTheme.spacingMd,
                    top: MoneaTheme.spacingSm,
                    bottom: MoneaTheme.spacingXs,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final account = entry.value[index];
                    return _buildAccountCard(account, isDark);
                  },
                  childCount: entry.value.length,
                ),
              ),
            ]),

        // Espacio final
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildTotalCard(double total, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(MoneaTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: MoneaColors.primaryGradient,
        borderRadius: BorderRadius.circular(MoneaTheme.radiusLg),
        border: Border.all(
          color: isDark ? MoneaColors.darkBorder : MoneaColors.softLinen,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance Total',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MoneaColors.textSecondary,
                ),
          ),
          const SizedBox(height: MoneaTheme.spacingXs),
          Text(
            _currencyFormat.format(total),
            style: MoneaTypography.amountLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(dynamic account, bool isDark) {
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
                color: MoneaColors.parchmentLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
              ),
              child: Icon(
                _getAccountIcon(account.type),
                color: MoneaColors.textPrimary,
              ),
            ),
            const SizedBox(width: MoneaTheme.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    account.institution ?? _getTypeLabel(account.type),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currencyFormat.format(account.balance),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: account.balance >= 0
                            ? MoneaColors.success
                            : MoneaColors.error,
                      ),
                ),
                if (account.includeInTotal == false)
                  Text(
                    'Excluida',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'checking':
        return 'Cuentas corrientes';
      case 'savings':
        return 'Ahorros';
      case 'cash':
        return 'Efectivo';
      case 'investment':
        return 'Inversiones';
      case 'credit':
        return 'Crédito';
      default:
        return type;
    }
  }

  IconData _getAccountIcon(String type) {
    switch (type) {
      case 'checking':
        return Icons.account_balance;
      case 'savings':
        return Icons.savings;
      case 'cash':
        return Icons.payments;
      case 'investment':
        return Icons.trending_up;
      case 'credit':
        return Icons.credit_card;
      default:
        return Icons.account_balance_wallet;
    }
  }
}

class _AddAccountSheet extends StatefulWidget {
  const _AddAccountSheet();

  @override
  State<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends State<_AddAccountSheet> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _institutionController = TextEditingController();
  String _type = 'checking';

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (_nameController.text.isEmpty) return;

    final provider = context.read<AccountProvider>();
    final success = await provider.createAccount({
      'name': _nameController.text,
      'type': _type,
      'currency': AppConstants.defaultCurrency,
      'initial_balance': double.tryParse(_balanceController.text) ?? 0,
      'institution': _institutionController.text.isNotEmpty
          ? _institutionController.text
          : null,
    });

    if (!mounted) return;

    if (success != null) {
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
              'Nueva Cuenta',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            MoneaInput(
              controller: _nameController,
              label: 'Nombre de la cuenta',
              hint: 'Ej: Cuenta principal',
              prefixIcon: Icons.edit,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaDropdown<String>(
              value: _type,
              label: 'Tipo de cuenta',
              items: const ['checking', 'savings', 'cash', 'investment'],
              labelBuilder: (type) {
                switch (type) {
                  case 'checking':
                    return 'Cuenta corriente';
                  case 'savings':
                    return 'Ahorros';
                  case 'cash':
                    return 'Efectivo';
                  case 'investment':
                    return 'Inversión';
                  default:
                    return type;
                }
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaAmountInput(
              controller: _balanceController,
              label: 'Saldo inicial',
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            MoneaInput(
              controller: _institutionController,
              label: 'Institución (opcional)',
              hint: 'Ej: BBVA, Banorte',
              prefixIcon: Icons.business,
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
                    label: 'Crear cuenta',
                    variant: MoneaButtonVariant.solid,
                    onPressed: _saveAccount,
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
