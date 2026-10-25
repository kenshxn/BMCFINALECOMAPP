import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
import 'screens/auth_screen.dart';
import 'screens/product_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var configured = AppConfig.isConfigured;
  if (configured) {
    try {
      await Supabase.initialize(
        url: 'https://qjdbaagtrewzstqsflja.supabase.co',
        publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFqZGJhYWd0cmV3enN0cXNmbGphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5Mjk3MDIsImV4cCI6MjEwODUwNTcwMn0.xko-SFhjyCSsZ09yhCaVntd41EFEjQkhvu4lg5BEuro',
      );
    } catch (error) {
      debugPrint('Supabase initialization failed: $error');
      configured = false;
    }
  }
  runApp(SariSariApp(configured: configured));
}

class SariSariApp extends StatelessWidget {
  final bool configured;
  const SariSariApp({super.key, required this.configured});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SariSari',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF155B45),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F6F0),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F6F0),
        foregroundColor: Color(0xFF18392F),
      ),
    ),
    home: configured && Supabase.instance.isInitialized
        ? const AuthGate()
        : const ProductListScreen(demoMode: true),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: Supabase.instance.client.auth.onAuthStateChange,
    builder: (context, snapshot) =>
        Supabase.instance.client.auth.currentSession == null
        ? const AuthScreen()
        : const ProductListScreen(),
  );
}
