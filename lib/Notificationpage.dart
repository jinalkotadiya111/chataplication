import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';



class Notificationpage extends StatefulWidget {
  const Notificationpage({Key? key}) : super(key: key);

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  @override
  Widget build(BuildContext context) {
    // AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   if(receivedNotification.buttonKeyPressed=="home")
    //   {
    //     Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context)=>HomeScreen())
    //     );
    //   }
    //   else if(receivedNotification.buttonKeyPressed=="about")
    //   {
    //
    //   }
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text("NOTIFICATION PAGE"),
      ),
      body: Column(
        children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             ElevatedButton(onPressed: () async{


               bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

               if(isAllowed)
                 {
                   AwesomeNotifications().createNotification(
                     content: NotificationContent(
                       id: 101,
                       channelKey: 'alerts',
                       title: 'Welcome!',
                       body: 'This is Awesome Chat App! Enjoy!',
                     ),
                   );
                 }
               else
                 {
                   showDialog(context: context, builder: (context){
                     return AlertDialog(
                       title: Text('Get Notified!',
                           style: Theme.of(context).textTheme.titleLarge),
                       content: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           const SizedBox(height: 20),
                           const Text(
                               'Allow Awesome Notifications to send you beautiful notifications!'),
                         ],
                       ),
                       actions: [
                         TextButton(
                             onPressed: () {
                               Navigator.of(context).pop();
                             },
                             child: Text(
                               'Deny',
                               style: Theme.of(context)
                                   .textTheme
                                   .titleLarge
                                   ?.copyWith(color: Colors.red),
                             )),
                         TextButton(
                             onPressed: () async {
                               await AwesomeNotifications().requestPermissionToSendNotifications();
                               Navigator.of(context).pop();
                             },
                             child: Text(
                               'Allow',
                               style: Theme.of(context)
                                   .textTheme
                                   .titleLarge
                                   ?.copyWith(color: Colors.deepPurple),
                             )),
                       ],
                     );
                   });
                 }






             },
                 child: Text("submit")),
             ElevatedButton(
                 onPressed: () async{
                     AwesomeNotifications().createNotification(
                         content: NotificationContent( //with image from URL
                             id: 102,
                             channelKey: 'image',
                             title: ' Image',
                             body: 'This simple notification is from Flutter App',
                             bigPicture: 'asset://img/chattapplogo.jpg',
                             notificationLayout: NotificationLayout.BigPicture,
                         ),
                       actionButtons: [
                         NotificationActionButton(key: 'home', label: 'Home'),
                         NotificationActionButton(key: 'about', label: 'About'),
                       ]
                     );
                   },child: Text("With Buttons")
             ),
           ],
         ),
        ],
      ),
    );
  }
}
