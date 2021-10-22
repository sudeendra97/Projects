import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/authenticationscreen.dart';
import 'package:shop_app/Screens/cartscreen.dart';
import 'package:shop_app/Screens/editproductscreen.dart';
import 'package:shop_app/Screens/ordersscreen.dart';
import 'package:shop_app/Screens/productdetailscreen.dart';
import 'package:shop_app/Screens/productsoverviewscreen.dart';
import 'package:shop_app/Screens/splashscreen.dart';
import 'package:shop_app/Screens/userproductscreen.dart';
import 'package:shop_app/helpers/customroutes.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (BuildContext ctx) {
            // String? getToken = Provider.of<Auth>(ctx, listen: false).token;
            // List<Product> getProducts =
            //     Provider.of<Products>(context, listen: false).items;

            return Products();
          },

          //the first argument  AUTH is type of data that we depend on and the second one Products is the type of data that we provide
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (BuildContext ctx) {
            // String? getToken = Provider.of<Auth>(ctx, listen: false).token;
            // List<OrderItem> getOrders =
            //     Provider.of<Orders>(ctx, listen: false).orders;
            return Orders();
          },
          update: (_, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: auth.isAuth
              ? ProductOverviewScreen()
              :
              // auth.tryAutoLogin() == true
              //     ? ProductOverviewScreen()
              //     : AuthScreen(),
              FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
