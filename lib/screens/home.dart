import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_services.dart';
import 'detail_bill.dart';
import 'history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Fungsi Keluar Akun
  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  // Fungsi Menampilkan Sistem Log (Notifikasi) - BUG FIXED
  void showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121622).withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(
              top: BorderSide(color: Color(0xFF00E5FF), width: 2),
              left: BorderSide(color: Color(0xFF00E5FF), width: 0.5),
              right: BorderSide(color: Color(0xFF00E5FF), width: 0.5),
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            // PERBAIKAN: Hapus orderBy() agar terhindar dari bug Composite Index
            stream: FirebaseFirestore.instance.collection('app_notifications')
                .where('targetEmail', isEqualTo: currentUser?.email).snapshots(),
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return const Center(
                    child: Text('Koneksi Error', style: TextStyle(color: Color(0xFFFF0055)))
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('Belum ada notifikasi 😴', style: TextStyle(color: Color(0xFF00E5FF), letterSpacing: 1))
                );
              }

              // PERBAIKAN: Mengurutkan notifikasi menggunakan Dart (Lokal)
              final notifs = snapshot.data!.docs.toList();
              notifs.sort((a, b) {
                final dataA = a.data() as Map<String, dynamic>;
                final dataB = b.data() as Map<String, dynamic>;
                final String timeA = dataA['timestamp'] ?? '';
                final String timeB = dataB['timestamp'] ?? '';
                return timeB.compareTo(timeA); // Urutkan Descending (Baru ke lama)
              });

              return Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Notifikasi Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF), letterSpacing: 1))
                  ),
                  const Divider(color: Color(0xFF00E5FF), height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: notifs.length,
                      itemBuilder: (context, index) {
                        final data = notifs[index].data() as Map<String, dynamic>;
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E5FF).withOpacity(0.1),
                              border: Border.all(color: const Color(0xFF00E5FF)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.notifications_active, color: Color(0xFF00E5FF)),
                          ),
                          title: Text(data['title'] ?? 'Notifikasi', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text(data['message'] ?? '', style: const TextStyle(color: Colors.white70)),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<PayUpDatabase>();
    final String displayName = currentUser?.displayName ?? "Bos";

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Latar Belakang Gradien Luar Angkasa
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF090B10), Color(0xFF1A1B2F)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // CUSTOM APP BAR SCI-FI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Halo,', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
                          Text('$displayName 👋', style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1)),
                        ],
                      ),
                      Row(
                        children: [
                          // Notifikasi
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('app_notifications')
                                .where('targetEmail', isEqualTo: currentUser?.email).snapshots(),
                            builder: (context, snapshot) {
                              int notifCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                              return IconButton(
                                icon: Badge(
                                  isLabelVisible: notifCount > 0,
                                  label: Text('$notifCount'),
                                  backgroundColor: const Color(0xFFFF0055),
                                  child: const Icon(Icons.notifications, color: Color(0xFF00E5FF)),
                                ),
                                onPressed: showNotificationSheet,
                              );
                            },
                          ),
                          // Tombol History
                          IconButton(
                              icon: const Icon(Icons.history, color: Colors.white70),
                              onPressed: () => Navigator.pushNamed(context, 'history')
                          ),
                          // Tombol Logout
                          IconButton(
                              icon: const Icon(Icons.logout, color: Color(0xFFFF0055)),
                              onPressed: logout
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // TAB BAR HOLOGRAPHIC
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B28),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: const Color(0xFF00E5FF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF00E5FF), width: 1),
                    ),
                    labelColor: const Color(0xFF00E5FF),
                    unselectedLabelColor: Colors.white54,
                    tabs: const [
                      Tab(child: Text('MENAGIH', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold))),
                      Tab(child: Text('DITAGIH', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),

                // AREA KONTEN LIST
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildStreamList(database.getBillsCreatedByMe(), isMenagih: true),
                      _buildStreamList(database.getBillsWhereIAmParticipant(), isMenagih: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // TOMBOL FAB GLOWING
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, 'add-bill'),
            icon: const Icon(Icons.add, color: Color(0xFF090B10)),
            label: const Text('Split Bill', style: TextStyle(color: Color(0xFF090B10), fontWeight: FontWeight.bold, letterSpacing: 1)),
            backgroundColor: const Color(0xFF00E5FF),
          ),
        ),
      ),
    );
  }

  // WIDGET LIST TAGIHAN
  Widget _buildStreamList(Stream<QuerySnapshot> stream, {required bool isMenagih}) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(isMenagih);
        }

        // FUNGSI FILTER: Sembunyikan yang sudah lunas
        List<QueryDocumentSnapshot> validDocs = snapshot.data!.docs;

        if (isMenagih) {
          validDocs = validDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final splits = data['splits'] as List<dynamic>? ?? [];
            if (splits.isEmpty) return true;
            return splits.any((s) => s['isPaid'] == false);
          }).toList();
        } else {
          validDocs = validDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final splits = data['splits'] as List<dynamic>? ?? [];
            final mySplit = splits.firstWhere((s) => s['email'] == currentUser?.email, orElse: () => null);
            return mySplit != null && mySplit['isPaid'] == false;
          }).toList();
        }

        if (validDocs.isEmpty) {
          return _buildEmptyState(isMenagih);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: validDocs.length,
          itemBuilder: (context, index) {
            final data = validDocs[index].data() as Map<String, dynamic>;
            final docId = validDocs[index].id;

            // KARTU HOLOGRAM
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF161B28).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.1), blurRadius: 8, spreadRadius: 1),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMenagih ? const Color(0xFF00E5FF).withOpacity(0.1) : const Color(0xFFB300FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isMenagih ? const Color(0xFF00E5FF) : const Color(0xFFB300FF)),
                  ),
                  child: Icon(
                      isMenagih ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      color: isMenagih ? const Color(0xFF00E5FF) : const Color(0xFFB300FF)
                  ),
                ),
                title: Text(data['title'] ?? 'Tanpa Judul',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, letterSpacing: 1)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Total: Rp ${data['totalAmount'].toStringAsFixed(0)}',
                      style: const TextStyle(color: Color(0xFF00E5FF))),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBillScreen(docId: docId))),
              ),
            );
          },
        );
      },
    );
  }

  // WIDGET KETIKA KOSONG
  Widget _buildEmptyState(bool isMenagih) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isMenagih ? Icons.receipt_long : Icons.inbox, size: 80, color: const Color(0xFF00E5FF).withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(isMenagih ? 'Kamu belum menagih siapapun.' : 'Hore! Semua tagihanmu sudah lunas 🎉',
                  style: const TextStyle(color: Colors.white54, letterSpacing: 1))
            ]
        )
    );
  }
}