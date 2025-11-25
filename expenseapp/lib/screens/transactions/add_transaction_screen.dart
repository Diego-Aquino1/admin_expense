import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/account_provider.dart';
import '../../providers/category_provider.dart';
import '../../config/constants.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = 'expense';
  int? _accountId;
  int? _destinationAccountId;
  int? _categoryId;
  DateTime _date = DateTime.now();
  bool _isRecurring = false;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    if (_accountId == null) {
      _showError('Selecciona una cuenta');
      return;
    }

    final transactionProvider = context.read<TransactionProvider>();

    final data = {
      'type': _type,
      'amount': double.parse(_amountController.text),
      'account_id': _accountId,
      'category_id': _categoryId,
      'date': _date.toIso8601String(),
      'currency': AppConstants.defaultCurrency,
      'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
    };

    if (_type == 'transfer' && _destinationAccountId != null) {
      data['destination_account_id'] = _destinationAccountId;
    }

    final success = await transactionProvider.createTransaction(data);

    if (!mounted) return;

    if (success != null) {
      _showSuccess('Transacción guardada');
      context.pop();
    } else {
      _showError(transactionProvider.error ?? 'Error al guardar');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: MoneaColors.errorLight, size: 20),
            const SizedBox(width: 12),
            Text(message),
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: MoneaColors.success, size: 20),
            const SizedBox(width: 12),
            Text(message),
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

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: MoneaAppBar(
        title: 'Nueva Transacción',
        actions: [
          MoneaButton(
            label: 'Guardar',
            variant: MoneaButtonVariant.solid,
            size: MoneaButtonSize.sm,
            isLoading: transactionProvider.isLoading,
            onPressed: _saveTransaction,
          ),
          const SizedBox(width: MoneaTheme.spacingSm),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MoneaTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    if (value != 'transfer') {
                      _destinationAccountId = null;
                    }
                  });
                },
                isFullWidth: true,
              ),
              const SizedBox(height: MoneaTheme.spacingLg),

              // Monto
              MoneaCard(
                variant: MoneaCardVariant.outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: MoneaTheme.spacingSm),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: MoneaTypography.amountLarge.copyWith(
                        color: _type == 'expense'
                            ? MoneaColors.error
                            : _type == 'income'
                                ? MoneaColors.success
                                : MoneaColors.info,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: MoneaTypography.amountLarge.copyWith(
                          color: MoneaColors.textMuted,
                        ),
                        prefixText: '${AppConstants.currencySymbol} ',
                        prefixStyle: MoneaTypography.amountLarge.copyWith(
                          color: MoneaColors.textSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un monto';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Monto inválido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: MoneaTheme.spacingMd),

              // Cuenta origen
              MoneaDropdown<int>(
                value: _accountId,
                label: _type == 'transfer' ? 'Cuenta origen' : 'Cuenta',
                hint: 'Selecciona una cuenta',
                prefixIcon: Icons.account_balance_wallet_outlined,
                items: accountProvider.accounts.map((a) => a.id).toList(),
                labelBuilder: (id) {
                  final account = accountProvider.accounts.firstWhere((a) => a.id == id);
                  return account.name;
                },
                onChanged: (value) {
                  setState(() => _accountId = value);
                },
              ),
              const SizedBox(height: MoneaTheme.spacingMd),

              // Cuenta destino (solo para transferencias)
              if (_type == 'transfer') ...[
                MoneaDropdown<int>(
                  value: _destinationAccountId,
                  label: 'Cuenta destino',
                  hint: 'Selecciona cuenta destino',
                  prefixIcon: Icons.account_balance_wallet_outlined,
                  items: accountProvider.accounts
                      .where((a) => a.id != _accountId)
                      .map((a) => a.id)
                      .toList(),
                  labelBuilder: (id) {
                    final account = accountProvider.accounts.firstWhere((a) => a.id == id);
                    return account.name;
                  },
                  onChanged: (value) {
                    setState(() => _destinationAccountId = value);
                  },
                ),
                const SizedBox(height: MoneaTheme.spacingMd),
              ],

              // Categoría (no para transferencias)
              if (_type != 'transfer') ...[
                MoneaDropdown<int>(
                  value: _categoryId,
                  label: 'Categoría',
                  hint: 'Selecciona una categoría',
                  prefixIcon: Icons.category_outlined,
                  items: categoryProvider.categories
                      .where((c) => c.type == _type || c.type == 'both')
                      .map((c) => c.id)
                      .toList(),
                  labelBuilder: (id) {
                    final category = categoryProvider.categories.firstWhere((c) => c.id == id);
                    return category.name;
                  },
                  onChanged: (value) {
                    setState(() => _categoryId = value);
                  },
                ),
                const SizedBox(height: MoneaTheme.spacingMd),
              ],

              // Fecha
              MoneaButton(
                label: DateFormat(AppConstants.dateFormatMedium).format(_date),
                icon: Icons.calendar_today_outlined,
                variant: MoneaButtonVariant.outline,
                isFullWidth: true,
                onPressed: _selectDate,
              ),
              const SizedBox(height: MoneaTheme.spacingMd),

              // Notas
              MoneaInput(
                controller: _notesController,
                label: 'Notas (opcional)',
                hint: 'Descripción del movimiento',
                prefixIcon: Icons.notes,
                maxLines: 3,
              ),
              const SizedBox(height: MoneaTheme.spacingMd),

              // Opciones adicionales
              MoneaCard(
                variant: MoneaCardVariant.ghost,
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Switch(
                      value: _isRecurring,
                      onChanged: (value) {
                        setState(() => _isRecurring = value);
                      },
                    ),
                    const SizedBox(width: MoneaTheme.spacingSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transacción recurrente',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            'Se repetirá automáticamente',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: MoneaTheme.spacingXl),

              // Botón guardar (alternativo al del AppBar)
              MoneaButton(
                label: 'Guardar transacción',
                variant: MoneaButtonVariant.solid,
                isFullWidth: true,
                isLoading: transactionProvider.isLoading,
                onPressed: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
