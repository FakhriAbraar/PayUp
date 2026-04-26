import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payup_model.dart';

class PayUpDatabase extends ChangeNotifier {
  static late Isar isar;

  // 1. Inisialisasi Isar Lokal
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [BillSchema, SplitDetailSchema],
        directory: dir.path
    );
  }

  // 2. Operasi CRUD & Sinkronisasi ke Firebase
  final List<Bill> currentBills = [];

  Future<void> addBill(String title, double amount, List<SplitDetail> splits) async {
    final newBill = Bill()
      ..title = title
      ..totalAmount = amount
      ..date = DateTime.now();

    await isar.writeTxn(() async {
      await isar.bills.put(newBill);
      for (var split in splits) {
        await isar.splitDetails.put(split);
        newBill.splitDetails.add(split);
      }
      await newBill.splitDetails.save();
    });

    // BACKUP KE FIREBASE FIRESTORE
    FirebaseFirestore.instance.collection('bills').add({
      'title': title,
      'totalAmount': amount,
      'date': DateTime.now().toIso8601String(),
    });

    fetchBills();
  }

  Future<void> fetchBills() async {
    List<Bill> fetched = await isar.bills.where().findAll();
    currentBills.clear();
    currentBills.addAll(fetched);
    notifyListeners();
  }
}