import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/ab/ab_analytics.dart';
import 'core/ab/ab_test_service.dart';
import 'core/ab/experiments.dart';
import 'core/theme/app_theme.dart';
import 'features/app_state.dart';
import 'features/home/home_view_model.dart';
import 'features/shell/home_shell.dart';

/// Raiz do app: injeta as dependências (Providers) e configura o tema.
class IronLogApp extends StatelessWidget {
  final AppState appState;
  final AbAnalytics analytics;
  final String userId;

  const IronLogApp({
    super.key,
    required this.appState,
    required this.analytics,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<AbAnalytics>.value(value: analytics),
        Provider<AbTestService>.value(value: const AbTestService()),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(
            abTest: const AbTestService(),
            analytics: analytics,
            experiment: Experiments.homeCta,
            userId: userId,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'IronLog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeShell(),
      ),
    );
  }
}
