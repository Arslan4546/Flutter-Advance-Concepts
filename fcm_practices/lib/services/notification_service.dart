import 'package:fcm_practices/views/profile_screen.dart';
import 'package:fcm_practices/views/user_chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initFCM() async {
    await _fcm.requestPermission();

    final token = await _fcm.getToken();
    print("FCM Token: $token");

    // ✅ TERMINATED STATE
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(Duration(seconds: 1), () {
        _handleNavigation(initialMessage);
      });
    }

    // ✅ BACKGROUND CLICK
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message);
    });

    // ✅ LOCAL NOTIFICATION INIT (WITH CLICK)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = response.payload!.split("|");

          _navigateFromPayload(data);
        }
      },
    );

    // ✅ FOREGROUND MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.title}');
      print('Foreground Message: ${message.notification?.body}');

      _showNotification(message);
    });
  }

  // 🔥 NAVIGATION HANDLER
  void _handleNavigation(RemoteMessage message) {
    final screen = message.data['screen'];
    final userId = message.data['userId'];

    if (screen == "chat") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ChatScreen(userId: userId)),
      );
    } else if (screen == "profile") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)),
      );
    }
  }

  // 🔥 FOREGROUND CLICK NAVIGATION
  void _navigateFromPayload(List<String> data) {
    final screen = data[0];
    final userId = data[1];

    if (screen == "chat") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ChatScreen(userId: userId)),
      );
    } else if (screen == "profile") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId)),
      );
    }
  }

  // 🔥 SHOW NOTIFICATION WITH PAYLOAD
  void _showNotification(RemoteMessage message) {
    final screen = message.data['screen'] ?? "";
    final userId = message.data['userId'] ?? "";

    _localNotifications.show(
      0,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: "$screen|$userId", // 🔥 IMPORTANT
    );
  }
}
