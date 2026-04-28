import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../services/database_services.dart';
import '../services/reminder_services.dart';

class DetailBillScreen extends StatefulWidget {
  final String docId;
  const DetailBillScreen({super.key, required this.docId});

  @override
  State<DetailBillScreen> createState() => _DetailBillScreenState();
}

class _DetailBillScreenState extends State<DetailBillScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // State untuk interaksi pengguna
  File? _proofImage;
  String _proofBase64 = "";
  bool? _isPaidLocal;
  bool _isLoading = false;
  final picker = ImagePicker();

  // Membuka foto struk utama dalam mode Full Screen Hologram
  void _openFullScreenImage(BuildContext context, String base64Image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Color(0xFF00E5FF))
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.memory(base64Decode(base64Image)),
            ),
          ),
        ),
      ),
    );
  }

  // Si Ditagih mengunggah bukti pembayaran
  Future _pickProofImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _proofImage = imageFile;
        _proofBase64 = base64Encode(imageBytes);
      });
    }
  }

  // Dialog untuk Penagih melihat detail pembayaran teman
  void _showParticipantDetail(Map<String, dynamic> split) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121622),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF00E5FF))
        ),
        title: Text(
            'DETAIL PEMBAYARAN',
            style: const TextStyle(color: Color(0xFF00E5FF), letterSpacing: 2, fontSize: 16)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(split['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            Text('Jumlah: Rp ${split['amount'].toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white10, height: 30),
            const Text('Foto Bukti:', style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 8),
            (split['proofImage'] != null && split['proofImage'].toString().isNotEmpty)
                ? Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8)
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.memory(base64Decode(split['proofImage'])),
            )
                : const Text('Belum ada foto bukti.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white24)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('TUTUP', style: TextStyle(color: Color(0xFF00E5FF)))
          )
        ],
      ),
    );
  }

  // Dialog Setel Pengingat Cek Tagihan
  void _showReminderDialog(String title) {
    final hController = TextEditingController(text: '0');
    final mController = TextEditingController(text: '0');
    final sController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF121622),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF00E5FF))),
        title: const Text('INGATKAN SAYA DALAM...', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 16)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeField(hController, 'JAM'),
            _buildTimeField(mController, 'MEN'),
            _buildTimeField(sController, 'DET'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('BATAL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () {
              int hours = int.tryParse(hController.text) ?? 0;
              int minutes = int.tryParse(mController.text) ?? 0;
              int seconds = int.tryParse(sController.text) ?? 0;
              ReminderService.scheduleReminder(
                  id: widget.docId.hashCode,
                  title: 'WAKTU MENAGIH! 🔔',
                  body: 'Cek tagihan: $title',
                  hours: hours, minutes: minutes, seconds: seconds
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengingat berhasil dijadwalkan!')));
            },
            child: const Text('SETEL'),
          )
        ],
      ),
    );
  }

  Widget _buildTimeField(TextEditingController controller, String label) {
    return SizedBox(
        width: 55,
        child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DETAIL TAGIHAN')),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF090B10), Color(0xFF1A1B2F)],
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('bills').doc(widget.docId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
            if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text('DATA TIDAK DITEMUKAN.'));

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final splits = data['splits'] as List<dynamic>;
            final String base64Image = data['imageBase64'] ?? "";
            final String creatorEmail = data['creatorEmail'];
            final String title = data['title'];
            bool isCreator = currentUser?.email == creatorEmail;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AREA FOTO STRUK (HOLOGRAPHIC PREVIEW)
                  if (base64Image.isNotEmpty)
                    GestureDetector(
                      onTap: () => _openFullScreenImage(context, base64Image),
                      child: Container(
                        width: double.infinity, height: 160, margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(base64Decode(base64Image), fit: BoxFit.cover),
                            Positioned(
                                bottom: 8, right: 8,
                                child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    child: const Icon(Icons.zoom_in, color: Color(0xFF00E5FF), size: 20)
                                )
                            )
                          ],
                        ),
                      ),
                    ),

                  // KARTU INFORMASI UTAMA
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B28).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isCreator ? const Color(0xFF00E5FF) : const Color(0xFFB300FF)),
                      boxShadow: [
                        BoxShadow(
                            color: (isCreator ? const Color(0xFF00E5FF) : const Color(0xFFB300FF)).withOpacity(0.1),
                            blurRadius: 10, spreadRadius: 1
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Text(
                            'TOTAL: Rp ${data['totalAmount'].toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 18,
                                color: isCreator ? const Color(0xFF00E5FF) : const Color(0xFFB300FF),
                                fontWeight: FontWeight.bold
                            )
                        ),
                        const Divider(height: 30, color: Colors.white10),
                        Text('Pembuat: $creatorEmail', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (isCreator) ...[
                    // VIEW PENAGIH
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                            onPressed: () => _showReminderDialog(title),
                            icon: const Icon(Icons.alarm),
                            label: const Text('SETEL PENGINGAT CEK TAGIHAN')
                        )
                    ),
                    const SizedBox(height: 24),
                    const Text(
                        'STATUS PEMBAYARAN TEMAN',
                        style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: splits.length,
                      itemBuilder: (context, index) {
                        final split = splits[index];
                        bool isPaid = split['isPaid'] as bool;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B28).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: ListTile(
                            onTap: () => _showParticipantDetail(split),
                            leading: Icon(
                                isPaid ? Icons.check_circle : Icons.pending,
                                color: isPaid ? Colors.green : Colors.orange
                            ),
                            title: Text(split['username'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            subtitle: Text('Rp ${split['amount'].toStringAsFixed(0)}', style: const TextStyle(color: Colors.white54)),
                            trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    // VIEW DITAGIH
                    Builder(builder: (context) {
                      final mySplit = splits.firstWhere((s) => s['email'] == currentUser?.email, orElse: () => null);
                      if (mySplit == null) return const Text('ANDA TIDAK TERDAFTAR.');
                      bool currentIsPaid = _isPaidLocal ?? mySplit['isPaid'];
                      String existingProof = mySplit['proofImage'] ?? "";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'KONFIRMASI PEMBAYARAN ANDA',
                              style: TextStyle(color: Color(0xFFB300FF), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: const Color(0xFF161B28).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFB300FF).withOpacity(0.3))
                            ),
                            child: Column(
                              children: [
                                OutlinedButton.icon(
                                    onPressed: _pickProofImage,
                                    icon: const Icon(Icons.upload_file),
                                    label: const Text('UNGGAH FOTO BUKTI')
                                ),
                                const SizedBox(height: 12),
                                if (_proofImage != null || existingProof.isNotEmpty)
                                  const Text('✅ FOTO BUKTI SIAP', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                                const Divider(height: 40, color: Colors.white10),
                                CheckboxListTile(
                                    title: const Text('SAYA SUDAH MEMBAYAR', style: TextStyle(fontSize: 14, color: Colors.white)),
                                    value: currentIsPaid,
                                    activeColor: const Color(0xFFB300FF),
                                    onChanged: (val) => setState(() => _isPaidLocal = val)
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : () async {
                                      setState(() => _isLoading = true);
                                      await context.read<PayUpDatabase>().updatePaymentStatusCloud(
                                          widget.docId, splits, currentUser!.email!, currentIsPaid,
                                          creatorEmail, title, mySplit['username'], _proofBase64
                                      );
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                        if (currentIsPaid) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: const Color(0xFF121622),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.green)),
                                                content: const Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.check_circle, color: Colors.green, size: 70),
                                                    SizedBox(height: 20),
                                                    Text('PEMBAYARAN SELESAI!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                                    SizedBox(height: 8),
                                                    Text('Laporan berhasil dikirim ke penagih.', style: TextStyle(color: Colors.white54, fontSize: 12), textAlign: TextAlign.center),
                                                  ],
                                                ),
                                              )
                                          );
                                          Future.delayed(const Duration(milliseconds: 2000), () {
                                            Navigator.pop(context); // Tutup Dialog
                                            Navigator.pop(context); // Kembali ke Home
                                          });
                                        }
                                      }
                                    },
                                    child: _isLoading
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                        : const Text('UPDATE STATUS PEMBAYARAN', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}