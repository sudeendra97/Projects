import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/business.dart';

import 'barber_shop_list_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ExploreShopList extends StatefulWidget {
  ExploreShopList({Key? key}) : super(key: key);
  static const routeName = '/ExploreShopList';

  @override
  _ExploreShopListState createState() => _ExploreShopListState();
}

class _ExploreShopListState extends State<ExploreShopList> {
  var isloading = true;
  Uint8List? image;
  List<Business> barberList = [];
  var token;

  void gettoken() {
    var data = Provider.of<ApiCalls>(context, listen: false).token;
    token = data;
  }

  @override
  void initState() {
    gettoken();
    print(token);
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getBarberList(token)
          .then((value) {
        barberList = value;
        print(barberList.isEmpty);

        reRun();
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          var token = Provider.of<ApiCalls>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .getBarberList(token)
              .then((value) {
            barberList = value;
            print(barberList.isEmpty);

            reRun();
          });
        }
      });
    }

    super.initState();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  int _count = 0;

  // Pass this method to the child page.
  void _update(int count) {
    // setState(() => _count = count);
  }
  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: Colors.black,
          )))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text('Explore'),
            ),
            // drawer: Drawer(
            //   child: Column(
            //     children: [
            //       const Center(
            //         child: DrawerHeader(
            //           child: Text(
            //             'Welcome',
            //             style: TextStyle(
            //               fontSize: 25,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       Center(
            //         child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor:
            //                   MaterialStateProperty.all(Colors.black),
            //             ),
            //             onPressed: () {
            //               Navigator.of(context)
            //                   .pushNamed(CustomerProfileScreenData.routeName);
            //             },
            //             child: const Text('My Profile')),
            //       ),
            //       const SizedBox(
            //         height: 25,
            //       ),
            //       Center(
            //         child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor:
            //                   MaterialStateProperty.all(Colors.black),
            //             ),
            // //             onPressed: () {
            //               Navigator.of(context)
            //                   .pushNamed(CustomerBookings.routeName);
            //             },
            // //             child: const Text('My Bookings')),
            //       ),
            //       const SizedBox(
            //         height: 25,
            //       ),
            //       Center(
            //         child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor:
            //                   MaterialStateProperty.all(Colors.black),
            //             ),
            //             onPressed: () {
            //               Navigator.of(context).pushNamed(
            //                 MyFavorites.routeName,
            //               );
            //             },
            //             child: const Text('My Favorites')),
            //       ),
            //       const SizedBox(
            //         height: 25,
            //       ),
            //       Center(
            //         child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor:
            //                   MaterialStateProperty.all(Colors.black),
            //             ),
            //             onPressed: () {
            //               Navigator.of(context)
            //                   .pushNamed(SelectPreferenceScreen.routeName);
            //             },
            //             child: const Text('Select Preference')),
            //       ),
            //       const SizedBox(
            //         height: 25,
            //       ),
            //       Center(
            //         child: ElevatedButton(
            //           style: ButtonStyle(
            //               backgroundColor:
            //                   MaterialStateProperty.all(Colors.black)),
            //           onPressed: () {
            //             Provider.of<ApiCalls>(context, listen: false)
            //                 .logout();
            //             Navigator.of(context)
            //                 .pushReplacementNamed(WelcomePage.routeName);
            //             // Navigator.of(context).pushReplacementNamed('/');
            //           },
            //           child: const Text('LogOut'),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // appBar: AppBar(
            //   title: const Text('Barber Shops'),
            //   backgroundColor: Colors.black,
            // ),
            body: ListView(
              children: [
                for (var data in barberList)
                  SizedBox(
                    width: 600,
                    height: 400,
                    child: BarberShop(
                      businessName: data.businessName,
                      description: data.description,
                      imagePath: data.imagepath,
                      index: data.index,
                      token: token,
                      id: data.id,
                      key: UniqueKey(),
                      favorite: false,
                      update: _update,
                    ),
                  )
              ],
            ),
          );
  }
}
