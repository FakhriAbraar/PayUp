import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/payup_model.dart';
import '../services/database_services.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _titleController = TextEditingController();
  final _totalController = TextEditingController();
  final _friendController = TextEditingController();

  List<String> friends = [];
  File? _image;
  final picker = ImagePicker();

  // Fungsi ambil foto dari Kamera
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void addFriend() {
    if (_friendController.text.isNotEmpty) {
      setState(() {
        friends.add(_friendController.text);
        _friendController.clear();
      });
    }
  }

  void saveBill() {
    if (_titleController.text.isEmpty || _totalController.text.isEmpty || friends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua data dan tambah minimal 1 teman!')),
      );
      return;
    }

    double total = double.parse(_totalController.text);
    double splitAmount = total / (friends.length + 1); // Dibagi teman + diri sendiri

    List<SplitDetail> splits = friends.map((name) {
      return SplitDetail()
        ..personName = name
        ..amountToPay = splitAmount
        ..isPaid = false;
    }).toList();

    context.read<PayUpDatabase>().addBill(
      _titleController.text,
      total,
      splits,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Split Bill')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview Foto Struk
            GestureDetector(
              onTap: getImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _image == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.camera_alt, size: 50), Text('Foto Struk')],
                )
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nama Tagihan (Contoh: Makan Siang)'),
            ),
            TextField(
              controller: _totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Nominal (Rp)'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _friendController,
                    decoration: const InputDecoration(labelText: 'Tambah Nama Teman'),
                  ),
                ),
                IconButton(onPressed: addFriend, icon: const Icon(Icons.add_circle, color: Colors.blue)),
              ],
            ),
            // Daftar Teman yang ditambahkan
            Wrap(
              spacing: 8,
              children: friends.map((f) => Chip(
                label: Text(f),
                onDeleted: () => setState(() => friends.remove(f)),
              )).toList(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveBill,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: const Text('Simpan & Bagi Tagihan', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}