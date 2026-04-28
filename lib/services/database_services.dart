import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/payup_model.dart';

class PayUpDatabase extends ChangeNotifier {
  static late Isar isar;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===================================================================
  // 1. INISIALISASI ISAR (DATABASE LOKAL)
  // ===================================================================
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [BillSchema, SplitDetailSchema],
        directory: dir.path
    );
  }

  final List<Bill> currentBills = [];

  // ===================================================================
  // 2. FUNGSI NOTIFIKASI IN-APP KE FIRESTORE
  // ===================================================================
  Future<void> sendAppNotification(String targetEmail, String title, String message) async {
    await _firestore.collection('app_notifications').add({
      'targetEmail': targetEmail,
      'title': title,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ===================================================================
  // 3. FUNGSI CLOUD MULTI-USER (FIRESTORE)
  // ===================================================================

  // A. CREATE: Menyimpan tagihan ke Cloud & Kirim Notif ke Teman
  Future<void> addBillCloud({
    required String title,
    required double baseAmount,
    required double taxPercentage,
    required List<Map<String, dynamic>> splitsData,
    required List<String> participantEmails,
    required String base64Image,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    double totalWithTax = baseAmount + (baseAmount * (taxPercentage / 100));

    await _firestore.collection('bills').add({
      'title': title,
      'totalAmount': totalWithTax,
      'baseAmount': baseAmount,
      'taxPercentage': taxPercentage,
      'date': DateTime.now().toIso8601String(),
      'creatorEmail': currentUser.email,
      'participantEmails': participantEmails,
      'imageBase64': base64Image,
      'splits': splitsData,
    });

    String senderName = currentUser.displayName ?? currentUser.email ?? 'Seseorang';
    for (String email in participantEmails) {
      await sendAppNotification(
          email,
          'Tagihan Baru! 💸',
          '$senderName menagihmu untuk patungan: $title'
      );
    }
  }

  // B. READ (STREAM): Mengambil tagihan yang SAYA BUAT (Tab Menagih)
  Stream<QuerySnapshot> getBillsCreatedByMe() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('bills')
        .where('creatorEmail', isEqualTo: currentUser?.email)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // C. READ (STREAM): Mengambil tagihan di mana SAYA DITAGIH (Tab Ditagih)
  Stream<QuerySnapshot> getBillsWhereIAmParticipant() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('bills')
        .where('participantEmails', arrayContains: currentUser?.email)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // D. UPDATE CLOUD: Mengubah status lunas/belum, Simpan Bukti, & Kirim Notif Balasan
  Future<void> updatePaymentStatusCloud(
      String docId,
      List<dynamic> currentSplits,
      String targetEmail,
      bool isPaid,
      String creatorEmail,
      String billTitle,
      String payerUsername,
      String proofImageBase64,
      ) async {

    List<dynamic> updatedSplits = currentSplits.map((split) {
      if (split['email'] == targetEmail) {
        return {
          'username': split['username'],
          'email': split['email'],
          'amount': split['amount'],
          'isPaid': isPaid,
          'proofImage': proofImageBase64.isNotEmpty ? proofImageBase64 : (split['proofImage'] ?? ''),
        };
      }
      return split;
    }).toList();

    await _firestore.collection('bills').doc(docId).update({
      'splits': updatedSplits,
    });

    if (isPaid) {
      await sendAppNotification(
          creatorEmail,
          'Pembayaran Masuk! 🎉',
          'Hutang $payerUsername, $billTitle sudah dibayar!'
      );
    }
  }

  // ===================================================================
  // 4. FUNGSI LAMA (ISAR LOKAL)
  // ===================================================================
  Future<void> fetchBills() async {
    List<Bill> fetched = await isar.bills.where().findAll();
    for (var bill in fetched) {
      await bill.splitDetails.load();
    }
    currentBills.clear();
    currentBills.addAll(fetched);
    notifyListeners();
  }

  Future<void> updatePaymentStatus(int detailId, bool isPaid) async {
    final detail = await isar.splitDetails.get(detailId);
    if (detail != null) {
      detail.isPaid = isPaid;
      await isar.writeTxn(() async {
        await isar.splitDetails.put(detail);
      });
      fetchBills();
    }
  }
}