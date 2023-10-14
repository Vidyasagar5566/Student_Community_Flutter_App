import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'First_page.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'App_notifications/Remainder_nitifications.dart';
import 'Login/login.dart';

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

/*
void main() {
  runApp(const MyApp());
} */

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
      // initialRoute: '/',
      // routes: {
      //   '/': (context) {
      //     if (storage.getItem('token') == null) {
      //       return liginpage("");
      //     } else {
      //       return get_ueser_widget(0);
      //     }
      //   },
      //   '/details': (context) => get_ueser_widget(0)
      // },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white70,
        //accentColor: Colors.black45,
        dividerColor: Colors.white,
        brightness: Brightness.light,
      ),
      home: FutureBuilder(
        future: storage.ready,
        builder: (context, snapshop) {
          if (snapshop.data == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          /*         if (storage.getItem('terms_conditions') == null) {
            return terms_conditions();
          }    */
          if (storage.getItem('token') == null) {
            return loginpage("");
          }
          return get_ueser_widget(0);
        },
      ),
    );
  }
}
