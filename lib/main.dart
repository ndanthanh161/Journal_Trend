import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/analyzer_provider.dart';
import 'screens/navigation_shell.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalyzerProvider()),
      ],
      child: MaterialApp(
        title: 'Journal Trend Analyzer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const NavigationShell(),
      ),
    );
  }
}
