import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_details.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/screens/barber_shop.dart';
import 'package:salon/screens/customer_bookings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'customer_profile_screen.dart';

class BarberShopList extends StatefulWidget {
  BarberShopList({Key? key}) : super(key: key);

  static const routeName = '/BarberShopList';

  @override
  _BarberShopListState createState() => _BarberShopListState();
}

class _BarberShopListState extends State<BarberShopList> {
  var isloading = true;
  Uint8List? image = null;
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

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  const Center(
                    child: DrawerHeader(
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CustomerProfileScreenData.routeName);
                        },
                        child: const Text('My Profile')),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CustomerBookings.routeName);
                        },
                        child: const Text('My Bookings')),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      onPressed: () {
                        Navigator.of(context).popUntil(
                          ModalRoute.withName('/'),
                        );
                      },
                      child: const Text('LogOut'),
                    ),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              title: const Text('Barber Shops'),
              backgroundColor: Colors.black,
            ),
            body: ListView(children: [
              for (var data in barberList)
                SizedBox(
                  width: 450,
                  height: 250,
                  child: BarberShop(
                    businessName: data.businessName,
                    description: data.description,
                    imagePath: data.imagepath,
                    index: data.index,
                    token: token,
                    id: data.id,
                  ),
                )
            ]));
  }
}

class BarberShop extends StatelessWidget {
  BarberShop(
      {required this.businessName,
      required this.description,
      required this.imagePath,
      required this.index,
      this.token,
      this.id});

  final String businessName;
  final String description;
  final String imagePath;
  final int index;
  var token;
  var id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: TextButton(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                _buildBackground(),
                _buildTitleAndSubtitle(),
              ],
            ),
          ),
        ),
        onPressed: () {
          BarberDetails.id = id;
          Navigator.of(context).pushNamed(
            BarberShopDetails.routeName,
            arguments: {'index': index, 'token': token, 'image': imagePath},
          );
        },
      ),
    );
  }

  Widget _buildBackground() {
    return SizedBox(
      width: 450,
      height: 250,
      child:
          //  Container(
          //   color: Colors.blue[200],
          //   child: Text('image'),
          // )
          FittedBox(
        fit: BoxFit.fill,
        clipBehavior: Clip.hardEdge,
        child: imagePath == ''
            ? const Text('NO Image')
            : CachedNetworkImage(
                //  placeholder: (context, url) => const CircularProgressIndicator(),
                imageUrl: imagePath,
              ),
        //     Image.memory(
        //   Uint8List.fromList(imagePath.cast<int>().toList()),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            businessName,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
