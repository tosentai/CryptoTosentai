import 'package:flutter/material.dart';

import '../../../../core/constants/app_currency.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../portfolio_providers.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({
    super.key,
    required this.summary,
    required this.currency,
    this.hideBalances = false,
  });

  final PortfolioSummary summary;
  final AppCurrency currency;
  final bool hideBalances;

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  bool _revealed = false;

  @override
  void didUpdateWidget(covariant SummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If user disables incognito globally, drop the local override.
    if (!widget.hideBalances && _revealed) _revealed = false;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final summary = widget.summary;
    final currency = widget.currency;
    final positive = summary.pnl >= 0;
    final masked = widget.hideBalances && !_revealed;

    // Card stays dark on both themes — keep text light for contrast.
    const balanceColor = AppColors.textPrimaryDark;
    const labelColor = AppColors.textSecondaryDark;

    String fmt(double v) =>
        masked ? '••••••' : Formatters.price(v, currency);

    return GestureDetector(
      onTap: widget.hideBalances
          ? () => setState(() => _revealed = !_revealed)
          : null,
      child: GlassCard(
        glow: positive,
        gradient: AppColors.cardGradient,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.totalBalance,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: labelColor,
                          letterSpacing: 0.4,
                        ),
                  ),
                ),
                if (widget.hideBalances)
                  Icon(
                    masked
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: labelColor,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  fmt(summary.currentValue),
                  key: ValueKey(
                    masked ? 'masked' : summary.currentValue.toStringAsFixed(2),
                  ),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: balanceColor,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: t.invested,
                    value: fmt(summary.invested),
                    labelColor: labelColor,
                    valueColor: balanceColor,
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: t.totalPnl,
                    value: masked
                        ? '••••••'
                        : '${Formatters.price(summary.pnl, currency)}  (${Formatters.percent(summary.pnlPercent)})',
                    labelColor: labelColor,
                    valueColor:
                        positive ? AppColors.positive : AppColors.negative,
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

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: labelColor,
                )),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  )),
        ),
      ],
    );
  }
}
