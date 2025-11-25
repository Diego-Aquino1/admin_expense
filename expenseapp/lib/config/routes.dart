import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/transactions/transactions_screen.dart';
import '../screens/transactions/add_transaction_screen.dart';
import '../screens/accounts/accounts_screen.dart';
import '../screens/budgets/budgets_screen.dart';
import '../screens/goals/goals_screen.dart';
import '../screens/credit_cards/credit_cards_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/can_spend/can_spend_screen.dart';
import '../screens/investments/investments_screen.dart';

class AppRouter {
  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isLoggingIn = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }

        if (isLoggedIn && isLoggingIn) {
          return '/';
        }

        return null;
      },
      routes: [
        // Auth
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        
        // Main App
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: 'transactions',
              builder: (context, state) => const TransactionsScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddTransactionScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'accounts',
              builder: (context, state) => const AccountsScreen(),
            ),
            GoRoute(
              path: 'budgets',
              builder: (context, state) => const BudgetsScreen(),
            ),
            GoRoute(
              path: 'goals',
              builder: (context, state) => const GoalsScreen(),
            ),
            GoRoute(
              path: 'credit-cards',
              builder: (context, state) => const CreditCardsScreen(),
            ),
            GoRoute(
              path: 'analytics',
              builder: (context, state) => const AnalyticsScreen(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: 'can-spend',
              builder: (context, state) => const CanSpendScreen(),
            ),
            GoRoute(
              path: 'investments',
              builder: (context, state) => const InvestmentsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    );
  }
}

