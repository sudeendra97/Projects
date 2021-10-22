import 'dart:developer';

import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/blist.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/screens/addcustomerscreen.dart';
import 'package:cablecollection_app/screens/area_wise_customer_list_screen.dart';
import 'package:cablecollection_app/screens/authscreen.dart';
import 'package:cablecollection_app/screens/billingscreen.dart';
import 'package:cablecollection_app/screens/complaints_screen.dart';
import 'package:cablecollection_app/screens/customerdetailsscreen.dart';
import 'package:cablecollection_app/screens/individual_customer_complaint_screen.dart';
import 'package:cablecollection_app/screens/node_wise_customer_list.dart';
import 'package:cablecollection_app/screens/splashScreen.dart';
import 'package:cablecollection_app/screens/store_screen.dart';
import 'package:cablecollection_app/screens/todo_screen.dart';
import 'package:cablecollection_app/widgets/tabbarcontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/mainscreen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:rename/rename.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   '1234',
//   'Name',
//   'Description',
//   importance: Importance.high,
//   playSound: true,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A Message Showed Up:${message.messageId}');
// }

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  // var initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  // );

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);

  runApp(MyHome());
}

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  static const routeName = '/';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color darkBlue = Color(0xFFE4FBFF);

  @override
  void initState() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   log(value);
    // });
    super.initState();
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, CustomerList>(
          create: (ctx) => CustomerList(),
          update: (ctx, auth, previousList) => CustomerList(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, BillList>(
          create: (ctx) => BillList(),
          update: (ctx, auth, previousList) => BillList(auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReportList(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData.light(),
          title: 'Cable Collection',
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? tabBarController(darkBlue: darkBlue)
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  future: auth.tryAutoLogin(),
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            tabBarController.routeName: (ctx) => tabBarController(
                  darkBlue: Color(0xFFE4FBFF),
                ),
            // MyApp.routeName: (ctx) => MyApp(),
            AddCustomerScreen.routeName: (ctx) => AddCustomerScreen(),
            CustomerDetailsScreen.routeName: (ctx) => CustomerDetailsScreen(),
            BillingScreen.routeName: (ctx) => BillingScreen(),
            StoreScreen.routeName: (ctx) => StoreScreen(),
            Complaints.routeName: (ctx) => Complaints(),
            TodoScreen.routeName: (ctx) => TodoScreen(),
            IndividualCustomerComplaint.routeName: (ctx) =>
                IndividualCustomerComplaint(),
            AreaWiseCustomerList.routeName: (ctx) => AreaWiseCustomerList(),
            NodeWiseCustomerList.routeName: (ctx) => NodeWiseCustomerList(),
          },
        ),
      ),
    );
  }
}
