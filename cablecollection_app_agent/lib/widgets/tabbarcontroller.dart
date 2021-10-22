import 'package:cablecollection_app/widgets/drawercontainer.dart';
import 'package:cablecollection_app/widgets/mainscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class tabBarController extends StatefulWidget {
  const tabBarController({
    Key key,
    @required this.darkBlue,
  }) : super(key: key);

  static const routeName = '/tabBarController';

  final Color darkBlue;

  @override
  State<tabBarController> createState() => _tabBarControllerState();
}

class _tabBarControllerState extends State<tabBarController> {
  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print(message);
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   // if (notification != null && android != null) {
    //   flutterLocalNotificationsPlugin.show(
    //       message.data.hashCode,
    //       message.data['title'],
    //       message.data['body'],
    //       // notification.hashCode,
    //       // notification.title,
    //       // notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channel.description,
    //           color: Colors.blue,
    //         ),
    //       ));
    //   // }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published');
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification.android;
    //   print(notification);
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body)],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: widget.darkBlue,
        drawer: DrawerContainer(),
        body: MainScreen(),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     Navigator.of(context)
        //         .pushNamed(AddCustomerScreen.routeName);
        //   },
        // ),
      ),
    );
  }
}
