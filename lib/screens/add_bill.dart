import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_services.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _titleController = TextEditingController();
  final _taxController = TextEditingController();
  final _friendUsernameController = TextEditingController();

  List<Map<String, dynamic>> participants = [];
  File? _image;
  String _base64Image = "";
  final picker = ImagePicker();
  bool _isLoading = false;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 20);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _image = imageFile;
        _base64Image = base64Encode(imageBytes);
      });
    }
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121622),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Pilih Sumber Foto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF)))
              ),
              ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFF00E5FF)),
                  title: const Text('Ambil dari Galeri'),
                  onTap: () { Navigator.of(context).pop(); getImage(ImageSource.gallery); }
              ),
              ListTile(
                  leading: const Icon(Icons.photo_camera, color: Color(0xFF00E5FF)),
                  title: const Text('Gunakan Kamera'),
                  onTap: () { Navigator.of(context).pop(); getImage(ImageSource.camera); }
              ),
            ],
          ),
        );
      },
    );
  }

  void addFriend() async {
    String username = _friendUsernameController.text.trim();
    if (username.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        String email = querySnapshot.docs.first['email'];
        if (participants.any((p) => p['email'] == email)) {
          if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Teman ini sudah ditambahkan!')));
        } else {
          setState(() {
            participants.add({
              'username': username,
              'email': email,
              'amountController': TextEditingController()
            });
            _friendUsernameController.clear();
          });
        }
      } else {
        if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username tidak ditemukan! 😢'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void saveBill() async {
    if (_titleController.text.isEmpty || participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi judul dan minimal tambahkan 1 teman!')));
      return;
    }
    bool hasEmptyAmount = participants.any((p) => p['amountController'].text.isEmpty);
    if (hasEmptyAmount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pastikan semua teman sudah diisi nominal hutangnya!')));
      return;
    }

    setState(() { _isLoading = true; });
    double tax = _taxController.text.isEmpty ? 0.0 : double.parse(_taxController.text);
    double totalBaseAmount = 0;
    List<String> participantEmails = [];
    List<Map<String, dynamic>> splitsData = [];

    for (var p in participants) {
      double baseAmount = double.parse(p['amountController'].text);
      totalBaseAmount += baseAmount;
      double amountWithTax = baseAmount + (baseAmount * (tax / 100));
      participantEmails.add(p['email']);
      splitsData.add({
        'username': p['username'],
        'email': p['email'],
        'amount': amountWithTax,
        'isPaid': false,
        'proofImage': ''
      });
    }

    await context.read<PayUpDatabase>().addBillCloud(
        title: _titleController.text,
        baseAmount: totalBaseAmount,
        taxPercentage: tax,
        splitsData: splitsData,
        participantEmails: participantEmails,
        base64Image: _base64Image
    );

    if (!mounted) return;
    setState(() { _isLoading = false; });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Tagihan Baru')),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF090B10), Color(0xFF1A1B2F)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // AREA FOTO STRUK
              GestureDetector(
                onTap: showImagePickerOptions,
                child: Container(
                  height: 180, width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B28).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5), width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _image == null
                      ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 50, color: const Color(0xFF00E5FF).withOpacity(0.5)),
                        const SizedBox(height: 12),
                        const Text('TAMBAHKAN FOTO STRUK', style: TextStyle(color: Color(0xFF00E5FF), letterSpacing: 2, fontSize: 12))
                      ]
                  )
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),

              // INPUT JUDUL & PAJAK
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Nama Tagihan', border: OutlineInputBorder())
                      )
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      flex: 1,
                      child: TextField(
                          controller: _taxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Pajak (%)', border: OutlineInputBorder())
                      )
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFF00E5FF), thickness: 0.5),

              // INPUT CARI TEMAN
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: _friendUsernameController,
                          decoration: const InputDecoration(labelText: 'Cari Username Teman', prefixIcon: Icon(Icons.search, color: Color(0xFF00E5FF)))
                      )
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                      onPressed: _isLoading ? null : addFriend,
                      icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF00E5FF)), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.person_add, color: Color(0xFF00E5FF))
                      )
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // LIST TEMAN
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final p = participants[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B28).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle, color: Color(0xFF00E5FF)),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: Text(p['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: p['amountController'],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: 'Nominal',
                              prefixText: 'Rp ',
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFFFF0055), size: 20),
                          onPressed: () => setState(() => participants.removeAt(index)),
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // BUTTON SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : saveBill,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Color(0xFF00E5FF))
                      : const Text('AKTIFKAN TAGIHAN', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}