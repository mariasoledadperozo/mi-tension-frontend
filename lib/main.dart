import 'package:flutter/material.dart';
import 'package:mi_tension/features/auth/services/notification_service.dart';
import 'package:mi_tension/features/screens/onboarding_screen.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.inicializar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi tension',
      theme: AppTheme.lightTheme(),
      home: const OnboardingScreen(),
    );
  }
}
