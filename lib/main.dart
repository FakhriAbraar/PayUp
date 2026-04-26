import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Pastikan file-file ini sudah ada di foldernya masing-masing
import 'firebase_options.dart';
import 'services/database_service.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Inisialisasi Isar Database
  await PayUpDatabase.initialize();

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
      // Gunakan LoginScreen sebagai halaman pertama saat aplikasi dibuka
      home: const LoginScreen(),
    );
  }
}