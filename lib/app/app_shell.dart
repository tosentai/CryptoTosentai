import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../l10n/generated/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onNavigate,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: child,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onNavigate,
          selectedItemColor: AppColors.emerald,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.show_chart_rounded),
              label: t.tabHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              label: t.tabPortfolio,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: t.tabProfile,
            ),
          ],
        ),
      ),
    );
  }
}
