import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Opsi Firebase hasil generate FlutterFire CLI
import 'firebase_options.dart';

// Import Services
import 'services/database_services.dart';
import 'services/notification_services.dart';

// Import Halaman
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/add_bill.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Inisialisasi Isar Database Lokal
  await PayUpDatabase.initialize();

  // 3. Inisialisasi Fitur Notifikasi
  await NotificationService.initialize();

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
      title: 'PayUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Navigasi awal ke halaman Login
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'home': (context) => const HomeScreen(),
        'add-bill': (context) => const AddBillScreen(),
      },
    );
  }
}