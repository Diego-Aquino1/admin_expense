import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/monea_theme.dart';
import 'config/routes.dart';
import 'config/env_config.dart';
import 'providers/auth_provider.dart';
import 'providers/account_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/credit_card_provider.dart';
import 'providers/investment_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/category_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/subscription_provider.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación y estilo de sistema
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Inicializar localización
  await initializeDateFormatting('es', null);
  
  // Mostrar información del entorno (solo en modo debug)
  if (kDebugMode) {
    EnvConfig.printEnvironmentInfo();
  }
  
  runApp(const MoneaApp());
}

class MoneaApp extends StatelessWidget {
  const MoneaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AccountProvider>(
          create: (_) => AccountProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TransactionProvider>(
          create: (_) => TransactionProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BudgetProvider>(
          create: (_) => BudgetProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, GoalProvider>(
          create: (_) => GoalProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CreditCardProvider>(
          create: (_) => CreditCardProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, InvestmentProvider>(
          create: (_) => InvestmentProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AnalyticsProvider>(
          create: (_) => AnalyticsProvider(),
          update: (_, auth, previous) => previous!..updateAuth(auth),
        ),
        Provider(create: (_) => ApiService()),
        ChangeNotifierProxyProvider<ApiService, CategoryProvider>(
          create: (context) => CategoryProvider(context.read<ApiService>()),
          update: (_, api, previous) => previous ?? CategoryProvider(api),
        ),
        ChangeNotifierProxyProvider<ApiService, AlertProvider>(
          create: (context) => AlertProvider(context.read<ApiService>()),
          update: (_, api, previous) => previous ?? AlertProvider(api),
        ),
        ChangeNotifierProxyProvider<ApiService, SubscriptionProvider>(
          create: (context) => SubscriptionProvider(context.read<ApiService>()),
          update: (_, api, previous) => previous ?? SubscriptionProvider(api),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            title: 'Monea',
            debugShowCheckedModeBanner: false,
            theme: MoneaTheme.lightTheme,
            darkTheme: MoneaTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router(auth),
          );
        },
      ),
    );
  }
}
