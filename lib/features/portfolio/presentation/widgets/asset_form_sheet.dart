import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../home/domain/coin.dart';
import '../../domain/portfolio_asset.dart';
import '../portfolio_providers.dart';

class AssetFormSheet extends ConsumerStatefulWidget {
  const AssetFormSheet({
    super.key,
    this.coin,
    this.existing,
  });

  final Coin? coin;
  final PortfolioAsset? existing;

  @override
  ConsumerState<AssetFormSheet> createState() => _AssetFormSheetState();
}

class _AssetFormSheetState extends ConsumerState<AssetFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _amountCtrl = TextEditingController(
      text: e == null ? '' : e.amount.toString(),
    );
    _priceCtrl = TextEditingController(
      text: e == null
          ? widget.coin?.currentPrice.toString() ?? ''
          : e.buyPrice.toString(),
    );
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.parse(_amountCtrl.text.replaceAll(',', '.'));
    final price = double.parse(_priceCtrl.text.replaceAll(',', '.'));
    final notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text;

    final controller = ref.read(portfolioProvider.notifier);
    if (widget.existing != null) {
      await controller.update(widget.existing!.copyWith(
        amount: amount,
        buyPrice: price,
        notes: notes,
      ));
    } else {
      final coin = widget.coin!;
      final asset = PortfolioAsset(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        coinId: coin.id,
        symbol: coin.symbol,
        name: coin.name,
        image: coin.image,
        amount: amount,
        buyPrice: price,
        notes: notes,
      );
      await controller.add(asset);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isEdit = widget.existing != null;
    final title = isEdit
        ? '${t.editAsset} • ${widget.existing!.symbol}'
        : '${t.addAsset} • ${widget.coin!.symbol}';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: t.amount),
                  validator: (v) => _numValidator(v, t.validationRequired),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: t.buyPrice),
                  validator: (v) => _numValidator(v, t.validationRequired),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: t.notes),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  onPressed: _submit,
                  label: t.save,
                  icon: Icons.check_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _numValidator(String? v, String required) {
    if (v == null || v.trim().isEmpty) return required;
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) return required;
    return null;
  }
}
