import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // 1. Meminta izin ke pengguna untuk memunculkan notifikasi
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Izin notifikasi diberikan oleh user!');

      // 2. Mendapatkan FCM Token (ID unik HP ini untuk menerima notifikasi)
      String? token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token HP ini: $token');
      // Di aplikasi berskala besar, token ini disimpan ke Firestore per user.
    }

    // 3. Menangkap notifikasi jika aplikasi sedang dibuka (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Notifikasi masuk: ${message.notification?.title}');
      // Nanti bisa dikembangkan untuk memunculkan pop-up local notification di sini
    });
  }
}