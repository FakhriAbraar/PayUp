import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import model dan database service
import '../models/payup_model.dart';
import '../services/database_services.dart';

// Import halaman detail
import 'detail_bill.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Membaca data dari database lokal segera setelah halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PayUpDatabase>().fetchBills();
    });
  }

  // Fungsi untuk keluar dari akun (Logout)
  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    // Kembali ke layar login dan hapus semua history navigasi
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan data pada database melalui Provider
    final database = context.watch<PayUpDatabase>();
    final List<Bill> bills = database.currentBills;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard PayUp', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: logout,
            tooltip: 'Logout',
          )
        ],
      ),
      // Tombol untuk menambah tagihan split bill baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'add-bill');
        },
        icon: const Icon(Icons.add),
        label: const Text('Split Bill'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      // Menampilkan konten utama
      body: bills.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return _buildBillCard(bill);
        },
      ),
    );
  }

  // Widget tampilan jika data kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada tagihan.',
            style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik tombol "Split Bill" untuk mulai!',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // Widget kartu untuk setiap tagihan
  Widget _buildBillCard(Bill bill) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_long, color: Colors.blue),
        ),
        title: Text(
          bill.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Tanggal: ${bill.date.day}-${bill.date.month}-${bill.date.year}'),
            Text('${bill.splitDetails.length} orang berpartisipasi'),
          ],
        ),
        trailing: Text(
          'Rp ${bill.totalAmount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Arahkan ke halaman detail saat diklik
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailBillScreen(bill: bill)),
          );
        },
      ),
    );
  }
}