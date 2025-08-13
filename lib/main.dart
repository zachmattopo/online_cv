import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/portfolio_screen.dart';

// Global theme notifier to manage dark/light mode
final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.system);

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Hafiz Nordin - Online CV',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0284c7),
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.interTextTheme(),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0284c7),
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.interTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          themeMode: currentMode,
          home: const PortfolioScreen(),
        );
      },
    );
  }
}
