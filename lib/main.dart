import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/database_services.dart';
import 'services/reminder_services.dart';

import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/add_bill.dart';
import 'screens/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PayUpDatabase.initialize();
  await ReminderService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => PayUpDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayUp: Astral Split',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090B10), // Deep Space Black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF), // Neon Cyan (Warna utama Hologram)
          secondary: Color(0xFFB300FF), // Neon Purple
          surface: Color(0xFF121622), // Panel UI Gelap
          error: Color(0xFFFF0055), // Neon Red/Pink
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090B10),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF00E5FF)),
          titleTextStyle: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0, // Teks berjarak khas game Sci-Fi
          ),
        ),
        // Menggunakan cardColor sebagai pengganti CardTheme agar kebal error versi
        cardColor: const Color(0xFF1A1F35),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E5FF).withOpacity(0.1),
            foregroundColor: const Color(0xFF00E5FF),
            side: const BorderSide(color: Color(0xFF00E5FF), width: 1.5), // Tombol Neon
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF00E5FF),
            side: const BorderSide(color: Color(0xFF00E5FF)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'home': (context) => const HomeScreen(),
        'add-bill': (context) => const AddBillScreen(),
        'history': (context) => const HistoryScreen(),
      },
    );
  }
}