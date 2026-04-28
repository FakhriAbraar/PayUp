import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // 1. Persiapan awal notifikasi lokal
  static Future<void> initialize() async {
    // Meminta izin notifikasi untuk Android 13 ke atas
    _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // 2. Fungsi eksekusi hitungan manual
  static void scheduleReminder({
    required int id,
    required String title,
    required String body,
    required int hours,
    required int minutes,
    required int seconds,
  }) {
    // Membuat durasi hitung mundur murni
    final Duration delay = Duration(hours: hours, minutes: minutes, seconds: seconds);

    // Menunggu sampai waktunya habis, lalu memunculkan notifikasi
    Future.delayed(delay, () async {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Penagih Reminders',
        channelDescription: 'Notifikasi untuk mengecek tagihan teman',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails);

      // Tembakkan notifikasi ke layar HP!
      await _notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
      );
    });
  }
}