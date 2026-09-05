import 'package:flutter/material.dart';

import '../ab_dashboard/ab_dashboard_screen.dart';
import '../catalog/catalog_screen.dart';
import '../home/home_screen.dart';
import '../progress/progress_screen.dart';
import '../workouts/workouts_screen.dart';

/// Estrutura principal com navegação inferior entre as áreas do app.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    WorkoutsScreen(),
    ProgressScreen(),
    AbDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined), label: 'Treinos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Progresso'),
          BottomNavigationBarItem(
              icon: Icon(Icons.science_outlined), label: 'A/B'),
        ],
      ),
    );
  }
}

/// Exposto para navegação direta ao catálogo, se necessário.
class CatalogRoute {
  static Route<void> build() =>
      MaterialPageRoute(builder: (_) => const CatalogScreen());
}
