import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chataplication/Cloudnotification.dart';
import 'package:chataplication/HomeScreen.dart';
import 'package:chataplication/Notificationpage.dart';
import 'package:chataplication/SplaceScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple,
        ),
        NotificationChannel(
            channelKey: 'image',
            channelName: 'image notifications',
            channelDescription: 'Notification channel for image tests',
            playSound: true,
            onlyAlertOnce: true,
            channelShowBadge: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultColor: Colors.redAccent,
            ledColor: Colors.white,
        ),
        NotificationChannel(
          channelKey: 'image',
          channelName: 'image notifications',
          channelDescription: 'Notification channel for image tests',
          playSound: true,
          onlyAlertOnce: true,
          channelShowBadge: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultColor: Colors.redAccent,
          ledColor: Colors.white,
        )
  ]
  );
  await FirebaseMessaging.instance.getToken().then((token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token.toString());
  });



  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  runApp(MyApp());
}


void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    var title = notification.title.toString();
    var body = notification.body.toString();

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 101,
        channelKey: 'alerts',
        title: title,
        body: body,
      ),
    );

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplaceScreen(),
    );
  }
}
