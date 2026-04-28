import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahan untuk database users
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController(); // Controller baru untuk Username
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorCode = "";

  void navigateLogin() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'login');
  }

  void register() async {
    // Validasi form kosong
    if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorCode = "Semua kolom wajib diisi!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorCode = "";
    });

    try {
      // 1. Buat akun di Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 2. Simpan Username ke profil bawaan Firebase
      await userCredential.user!.updateDisplayName(_usernameController.text.trim());

      // 3. Simpan data user ke database Firestore agar bisa dicari teman nanti
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Jika sukses, lempar pengguna ke halaman login
      navigateLogin();

    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
    } catch (e) {
      setState(() {
        _errorCode = "Terjadi kesalahan: ${e.toString()}";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register PayUp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 32),
              Icon(Icons.person_add_alt_1, size: 100, color: Colors.blue[300]),
              const SizedBox(height: 32),

              // Kolom Input Username Baru
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              _errorCode != ""
                  ? Column(children: [Text(_errorCode, style: const TextStyle(color: Colors.red)), const SizedBox(height: 24)])
                  : const SizedBox(height: 0),

              OutlinedButton(
                onPressed: register,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Register', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: navigateLogin,
                    child: const Text('Login'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}