import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../providers/account_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../config/constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../transactions/transactions_screen.dart';
import '../analytics/analytics_screen.dart';
import 'more_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    SizedBox(), // Placeholder para FAB
    AnalyticsScreen(),
    MoreMenuScreen(),
  ];

  final List<MoneaNavItem> _navItems = const [
    MoneaNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Inicio',
    ),
    MoneaNavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Movimientos',
    ),
    MoneaNavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Análisis',
    ),
    MoneaNavItem(
      icon: Icons.more_horiz,
      activeIcon: Icons.more_horiz,
      label: 'Más',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final accountProvider = context.read<AccountProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final analyticsProvider = context.read<AnalyticsProvider>();

    await Future.wait([
      accountProvider.loadAccounts(),
      transactionProvider.loadTransactions(limit: 50),
      analyticsProvider.loadDashboardSummary(),
    ]);
  }

  void _onItemTapped(int index) {
    // Ajustar índice porque el FAB está en el medio
    int actualIndex = index;
    if (index >= 2) {
      actualIndex = index + 1;
    }
    
    setState(() {
      _selectedIndex = actualIndex;
    });
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppConstants.animationDuration,
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: MoneaAddFab(
        onPressed: _showAddTransactionSheet,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? MoneaColors.darkSurface : MoneaColors.parchment,
        border: Border(
          top: BorderSide(
            color: isDark ? MoneaColors.darkBorder : MoneaColors.divider,
            width: MoneaTheme.borderWidth,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(minHeight: 60, maxHeight: 64),
          padding: const EdgeInsets.symmetric(
            horizontal: MoneaTheme.spacingSm,
            vertical: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Items izquierda
              _buildNavItem(0, isDark),
              _buildNavItem(1, isDark),

              // Espacio para FAB
              const SizedBox(width: 72),

              // Items derecha
              _buildNavItem(2, isDark),
              _buildNavItem(3, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark) {
    // Mapear índice de nav a índice real de pantalla
    int screenIndex = index;
    if (index >= 2) {
      screenIndex = index + 1;
    }

    final isSelected = _selectedIndex == screenIndex;
    final item = _navItems[index];
    final color = isSelected
        ? (isDark ? MoneaColors.darkTextPrimary : MoneaColors.textPrimary)
        : MoneaColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MoneaColors.parchmentLight.withOpacity(0.5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(MoneaTheme.radiusSm),
                ),
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal para agregar transacción rápida
class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'expense';
  int? _selectedAccountId;
  int? _selectedCategoryId;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty || _selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Completa los campos requeridos'),
          backgroundColor: MoneaColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
          ),
        ),
      );
      return;
    }

    final transactionProvider = context.read<TransactionProvider>();

    final success = await transactionProvider.createTransaction({
      'type': _type,
      'amount': double.parse(_amountController.text),
      'account_id': _selectedAccountId,
      'category_id': _selectedCategoryId,
      'date': DateTime.now().toIso8601String(),
      'currency': AppConstants.defaultCurrency,
      'notes': _noteController.text.isNotEmpty ? _noteController.text : null,
    });

    if (!mounted) return;

    if (success != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: MoneaColors.success, size: 20),
              const SizedBox(width: 12),
              const Text('Transacción guardada'),
            ],
          ),
          backgroundColor: MoneaColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MoneaTheme.radiusMd),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
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

            // Título
            Text(
              'Nueva Transacción',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            // Tipo de transacción
            MoneaButtonGroup<String>(
              options: const ['expense', 'income', 'transfer'],
              selectedValue: _type,
              labelBuilder: (type) {
                switch (type) {
                  case 'expense':
                    return 'Gasto';
                  case 'income':
                    return 'Ingreso';
                  case 'transfer':
                    return 'Traspaso';
                  default:
                    return type;
                }
              },
              iconBuilder: (type) {
                switch (type) {
                  case 'expense':
                    return Icons.arrow_upward;
                  case 'income':
                    return Icons.arrow_downward;
                  case 'transfer':
                    return Icons.swap_horiz;
                  default:
                    return Icons.help;
                }
              },
              onChanged: (value) {
                setState(() {
                  _type = value;
                });
              },
              isFullWidth: true,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Monto
            MoneaAmountInput(
              controller: _amountController,
              label: 'Monto',
              autofocus: true,
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Cuenta
            MoneaDropdown<int>(
              value: _selectedAccountId,
              label: 'Cuenta',
              hint: 'Selecciona una cuenta',
              prefixIcon: Icons.account_balance_wallet_outlined,
              items: accountProvider.accounts.map((a) => a.id).toList(),
              labelBuilder: (id) {
                final account =
                    accountProvider.accounts.firstWhere((a) => a.id == id);
                return account.name;
              },
              onChanged: (value) {
                setState(() {
                  _selectedAccountId = value;
                });
              },
            ),
            const SizedBox(height: MoneaTheme.spacingMd),

            // Nota (opcional)
            MoneaInput(
              controller: _noteController,
              label: 'Nota (opcional)',
              hint: 'Descripción del movimiento',
              prefixIcon: Icons.notes,
              maxLines: 2,
            ),
            const SizedBox(height: MoneaTheme.spacingLg),

            // Botones
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
                    label: 'Guardar',
                    variant: MoneaButtonVariant.solid,
                    onPressed: _saveTransaction,
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MoneaTheme.spacingSm),

            // Link a formulario completo
            Center(
              child: MoneaButton(
                label: 'Más opciones',
                variant: MoneaButtonVariant.ghost,
                size: MoneaButtonSize.sm,
                trailingIcon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/transactions/add');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
