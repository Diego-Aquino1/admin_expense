import 'env_config.dart';

/// Constantes de la aplicación Monea
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Monea';
  static const String appTagline = 'Tu dinero, tu control';
  static const String appVersion = '1.0.0';

  // API - Usa detección automática de plataforma
  // Ver lib/config/env_config.dart para configuración avanzada
  static String get apiBaseUrl => EnvConfig.apiBaseUrl;

  // Storage Keys
  static const String tokenKey = 'monea_auth_token';
  static const String userKey = 'monea_user_data';
  static const String themeKey = 'monea_theme_mode';
  static const String onboardingKey = 'monea_onboarding_completed';

  // Defaults
  static const String defaultCurrency = 'PEN';
  static const String currencySymbol = 'S/.';
  static const String defaultLocale = 'es_PE';

  // Pagination
  static const int defaultPageSize = 50;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // Limits
  static const int maxTransactionNoteLength = 500;
  static const int maxAccountNameLength = 50;
  static const int maxCategoryNameLength = 30;
  static const int maxGoalNameLength = 100;

  // Date Formats
  static const String dateFormatShort = 'dd/MM/yy';
  static const String dateFormatMedium = 'dd MMM yyyy';
  static const String dateFormatLong = 'dd \'de\' MMMM, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yy HH:mm';

  // Currency Formats
  static const int currencyDecimalDigits = 2;
}

/// Rutas de navegación
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String onboarding = '/onboarding';

  // Main
  static const String home = '/';
  static const String dashboard = '/dashboard';

  // Transactions
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String transactionDetail = '/transactions/:id';

  // Accounts
  static const String accounts = '/accounts';
  static const String addAccount = '/accounts/add';
  static const String accountDetail = '/accounts/:id';

  // Budgets
  static const String budgets = '/budgets';
  static const String addBudget = '/budgets/add';
  static const String budgetDetail = '/budgets/:id';

  // Goals
  static const String goals = '/goals';
  static const String addGoal = '/goals/add';
  static const String goalDetail = '/goals/:id';

  // Credit Cards
  static const String creditCards = '/credit-cards';
  static const String addCreditCard = '/credit-cards/add';
  static const String creditCardDetail = '/credit-cards/:id';

  // Investments
  static const String investments = '/investments';
  static const String addInvestment = '/investments/add';
  static const String investmentDetail = '/investments/:id';

  // Analytics
  static const String analytics = '/analytics';
  static const String reports = '/reports';

  // Features
  static const String canSpend = '/can-spend';
  static const String subscriptions = '/subscriptions';
  static const String alerts = '/alerts';

  // Settings
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String categories = '/categories';
  static const String exportData = '/export';
}
