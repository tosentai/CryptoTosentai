import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/delete_account_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/details/presentation/screens/coin_details_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/screens/about_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import 'app_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: _AuthRefresh(ref),
    redirect: (context, state) {
      final loggedIn = authState.valueOrNull != null;
      final loading = authState.isLoading;
      final loc = state.matchedLocation;

      const authRoutes = {'/login', '/register', '/forgot'};
      final isAuthRoute = authRoutes.contains(loc);
      final isSplash = loc == '/splash';

      if (loading) return isSplash ? null : '/splash';
      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && (isAuthRoute || isSplash)) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/forgot', builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(
        path: '/coin/:id',
        builder: (context, state) =>
            CoinDetailsScreen(coinId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
      GoRoute(
        path: '/change-password',
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/delete-account',
        builder: (_, _) => const DeleteAccountScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final loc = state.matchedLocation;
          int index = 0;
          if (loc.startsWith('/portfolio')) index = 1;
          if (loc.startsWith('/profile')) index = 2;
          return AppShell(
            currentIndex: index,
            onNavigate: (i) {
              switch (i) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/portfolio');
                  break;
                case 2:
                  context.go('/profile');
                  break;
              }
            },
            child: child,
          );
        },
        routes: [
          GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: '/portfolio',
            builder: (_, _) => const PortfolioScreen(),
          ),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
    ],
  );
});

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    _sub = ref.listen(authStateProvider, (_, _) => notifyListeners());
  }

  late final ProviderSubscription _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
