import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/portfolio_screen.dart';
import 'presentation/cubit/resume_cubit.dart';
import 'theme/hn_theme.dart';

// Global theme notifier to manage dark/light mode
final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.system);

void main() {
  // `?theme=light` or `?theme=dark` pins the theme (handy for shared links).
  final pinned = Uri.base.queryParameters['theme'];
  if (pinned == 'light') themeNotifier.value = ThemeMode.light;
  if (pinned == 'dark') themeNotifier.value = ThemeMode.dark;
  runApp(
    BlocProvider(
      create: (_) => ResumeCubit(),
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return BlocBuilder<ResumeCubit, ResumeState>(
          builder: (context, state) {
            return MaterialApp(
              title: state.appTitle,
              debugShowCheckedModeBanner: false,
              theme: buildTheme(Brightness.light),
              darkTheme: buildTheme(Brightness.dark),
              themeMode: currentMode,
              home: const PortfolioScreen(),
            );
          },
        );
      },
    );
  }
}
