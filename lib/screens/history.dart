import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detail_bill.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RIWAYAT TRANSAKSI', style: TextStyle(letterSpacing: 2)),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF090B10), Color(0xFF1A1B2F)],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          // Mengambil semua tagihan di mana user terlibat (sebagai penagih atau yang ditagih)
          stream: FirebaseFirestore.instance.collection('bills').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00E5FF))
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState();
            }

            // ==========================================
            // LOGIKA FILTER UNTUK RIWAYAT (HANYA YANG LUNAS)
            // ==========================================
            final allDocs = snapshot.data!.docs;

            List<QueryDocumentSnapshot> historyDocs = allDocs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final splits = data['splits'] as List<dynamic>? ?? [];
              final String creatorEmail = data['creatorEmail'] ?? "";
              final List<dynamic> participantEmails = data['participantEmails'] ?? [];

              bool isCreator = creatorEmail == currentUser?.email;
              bool isParticipant = participantEmails.contains(currentUser?.email);

              if (isCreator) {
                // Masuk History Penagih jika SEMUA orang sudah lunas
                return splits.isNotEmpty && splits.every((s) => s['isPaid'] == true);
              } else if (isParticipant) {
                // Masuk History Ditagih jika SAYA sudah bayar
                final mySplit = splits.firstWhere(
                        (s) => s['email'] == currentUser?.email,
                    orElse: () => null
                );
                return mySplit != null && mySplit['isPaid'] == true;
              }

              return false;
            }).toList();

            if (historyDocs.isEmpty) {
              return _buildEmptyState();
            }

            // Urutkan berdasarkan tanggal terbaru
            historyDocs.sort((a, b) => b['date'].compareTo(a['date']));

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: historyDocs.length,
              itemBuilder: (context, index) {
                final data = historyDocs[index].data() as Map<String, dynamic>;
                final String docId = historyDocs[index].id;
                bool isCreator = data['creatorEmail'] == currentUser?.email;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B28).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    // Menggunakan border hijau neon untuk menandakan "LUNAS"
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.05),
                          blurRadius: 8,
                          spreadRadius: 1
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.greenAccent),
                      ),
                      child: Icon(
                        isCreator ? Icons.fact_check : Icons.check_circle_outline,
                        color: Colors.greenAccent,
                      ),
                    ),
                    title: Text(
                        data['title'] ?? 'TANPA JUDUL',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, letterSpacing: 1)
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        isCreator ? 'SELESAI DITAGIH' : 'SUDAH DIBAYAR',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp ${data['totalAmount'].toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text('LUNAS', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailBillScreen(docId: docId)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // WIDGET KETIKA KOSONG
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: const Color(0xFF00E5FF).withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'BELUM ADA DATA RIWAYAT.',
            style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}