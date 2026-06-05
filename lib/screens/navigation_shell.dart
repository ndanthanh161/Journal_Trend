import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/analyzer_provider.dart';
import '../theme.dart';
import 'search_screen.dart';
import 'dashboard_screen.dart';
import 'trend_screen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const SearchScreen(),
      DashboardScreen(onNavigateToSearch: _navigateToSearch),
      TrendScreen(onNavigateToSearch: _navigateToSearch),
    ]);
  }

  void _navigateToSearch() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyzerProvider>();
    final hasResults = provider.works.isNotEmpty;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.borderSubdued, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavTab(
                  icon: Icons.search_rounded,
                  label: 'Tìm kiếm',
                  isActive: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavTab(
                  icon: Icons.space_dashboard_outlined,
                  label: 'Tổng quan',
                  isActive: _currentIndex == 1,
                  showDot: hasResults && _currentIndex != 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavTab(
                  icon: Icons.insights_rounded,
                  label: 'Xu hướng',
                  isActive: _currentIndex == 2,
                  showDot: hasResults && _currentIndex != 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool showDot;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.label,
    required this.isActive,
    this.showDot = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppTheme.brandGreen : AppTheme.textDisabled;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 22, color: color),
                if (showDot)
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.brandGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
