import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard PayUp')),
      body: const Center(
        child: Text('Ini adalah halaman utama (CRUD Split Bill nanti ditaruh di sini)'),
      ),
    );
  }
}