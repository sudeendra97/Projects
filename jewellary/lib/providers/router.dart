// import 'package:an_app/main.dart';
// import 'package:an_app/screens/receive_order_screen.dart';
// import 'package:fluro/fluro.dart';
// import 'package:flutter/cupertino.dart';

// class FlourRouter {
//   static var router = FluroRouter.appRouter;
//   var userHandler = Handler(
//       handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//     return ReceiveOrderScreen(params["id"]);
//   });

//   var homeHandler = Handler(
//       handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//     return MyApp();
//   });

//   void defineRoutes(FluroRouter router) {
//     router.define('/', handler: homeHandler);
//     router.define("/ReceiveOrders/:id", handler: userHandler);
//   }
// }
