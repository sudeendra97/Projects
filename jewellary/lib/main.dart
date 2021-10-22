import 'package:an_app/providers/vendorslist.dart';
import 'package:an_app/screens/editpage.dart';
import 'package:an_app/screens/orderdetailsscreen.dart';
import 'package:an_app/screens/receive_order_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'screens/mainscreen.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  runApp(ModularApp(module: AppModule(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => VendorsList(),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/',
          // Hide the debug banner
          debugShowCheckedModeBanner: false,
          title: 'SterlynSilver',
          theme: ThemeData(
            primaryColor: Color(0xFF22577A),
            primarySwatch: Colors.indigo,
          ),
          home: HomePage(),
          // onGenerateRoute: FlourRouter.router.generator,
          routes: {
            OrderDetailsScreen.routeName: (ctx) => OrderDetailsScreen(),
            EditPage.routeName: (ctx) => EditPage(),
          },
        ).modular());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 6,
      child: Scaffold(
        body: MainScreen(),
      ),
    );
  }
}

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => HomePage()),
    ChildRoute('/PurchaseOrder/:id',
        child: (_, args) => ReceiveOrderScreen(args.params['id'])),
    ChildRoute('/OrderDetailsScreen', child: (_, args) => OrderDetailsScreen())
  ];
}
