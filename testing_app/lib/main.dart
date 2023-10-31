import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'First_page.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'App_notifications/Remainder_nitifications.dart';
import 'Login/Login.dart';

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//Main Function which run by default
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  NotificationService().initNotification();
  tz.initializeTimeZones();

  FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
    Map<String, dynamic> message = remoteMessage.data;
  });
  runApp(const MyApp());
}

//My app widget which called by main function theam and routings all will include
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    LocalStorage storage = LocalStorage("usertoken");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white70,
        dividerColor: Colors.white,
        brightness: Brightness.light,
      ),
      home: FutureBuilder(
        future: storage.ready,
        builder: (context, snapshop) {
          if (snapshop.data == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (storage.getItem('token') == null) {
            return loginpage("");
          }
          return get_ueser_widget(0);
        },
      ),
    );
  }
}
