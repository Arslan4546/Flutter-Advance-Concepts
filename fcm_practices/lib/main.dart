import 'package:fcm_practices/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fcm_practices/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationservice = NotificationService();
  await notificationservice.initFCM();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);

  runApp(MyApp(notificationService: notificationservice));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  const MyApp({super.key, required this.notificationService});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: notificationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Text("Firebase Push Notification"),
      ),
      body: Center(child: Text("Welcome TO Push Notification")),
    );
  }
}

Future<void> handleBackgroundNotification(RemoteMessage message) async {
  await Firebase.initializeApp(); // ✅ MUST
  print('Background Message: ${message.notification?.title}');
}
