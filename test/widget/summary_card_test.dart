import 'package:crypto_tosentai/core/constants/app_currency.dart';
import 'package:crypto_tosentai/features/portfolio/presentation/portfolio_providers.dart';
import 'package:crypto_tosentai/features/portfolio/presentation/widgets/summary_card.dart';
import 'package:crypto_tosentai/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SummaryCard renders balance and PnL', (tester) async {
    const summary = PortfolioSummary(
      invested: 100,
      currentValue: 150,
      pnl: 50,
      pnlPercent: 50,
    );

    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const Scaffold(
        body: SummaryCard(summary: summary, currency: AppCurrency.usd),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('150'), findsWidgets);
    expect(find.textContaining('+50.00%'), findsWidgets);
    expect(find.textContaining('Total balance'), findsOneWidget);
  });
}
