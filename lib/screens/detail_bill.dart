import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/payup_model.dart';
import '../services/database_services.dart';

class DetailBillScreen extends StatefulWidget {
  final Bill bill;

  const DetailBillScreen({super.key, required this.bill});

  @override
  State<DetailBillScreen> createState() => _DetailBillScreenState();
}

class _DetailBillScreenState extends State<DetailBillScreen> {
  @override
  Widget build(BuildContext context) {
    // Mengambil daftar teman dari Isar Links
    final splits = widget.bill.splitDetails.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Tagihan'),
        centerTitle: true,
      ),
      // Tombol untuk mengirimkan notifikasi pengingat
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final unpaidCount = splits.where((s) => !s.isPaid).length;

          if (unpaidCount == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semua teman sudah lunas! 🎉'), backgroundColor: Colors.green),
            );
          } else {
            // Simulasi pengiriman notifikasi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mengirim pengingat ke $unpaidCount orang yang belum bayar...'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        },
        icon: const Icon(Icons.campaign),
        label: const Text('Ingatkan Teman'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KARTU INFORMASI UTAMA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.bill.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    'Total Bill: Rp ${widget.bill.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const Divider(color: Colors.white30, height: 20),
                  Text(
                    'Tanggal: ${widget.bill.date.day}/${widget.bill.date.month}/${widget.bill.date.year}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text('Daftar Pembayaran Teman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // LIST TEMAN (RELATIONAL DATA)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: splits.length,
              itemBuilder: (context, index) {
                final split = splits[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: CheckboxListTile(
                    title: Text(split.personName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Harus bayar: Rp ${split.amountToPay.toStringAsFixed(0)}'),
                    value: split.isPaid,
                    activeColor: Colors.green,
                    onChanged: (bool? newValue) async {
                      if (newValue != null) {
                        // 1. Update status di database Isar
                        await context.read<PayUpDatabase>().updatePaymentStatus(split.id, newValue);
                        // 2. Refresh tampilan UI lokal
                        setState(() {
                          split.isPaid = newValue;
                        });
                      }
                    },
                    secondary: CircleAvatar(
                      backgroundColor: split.isPaid ? Colors.green[100] : Colors.orange[100],
                      child: Icon(
                        split.isPaid ? Icons.check : Icons.access_time,
                        color: split.isPaid ? Colors.green[800] : Colors.orange[800],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80), // Padding bawah agar FAB tidak menutupi list terakhir
          ],
        ),
      ),
    );
  }
}