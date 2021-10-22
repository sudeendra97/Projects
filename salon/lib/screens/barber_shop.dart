import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_details.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/screens/bookingpage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BarberShopDetails extends StatefulWidget {
  const BarberShopDetails({Key? key}) : super(key: key);

  static const routeName = '/BarberShop';

  @override
  State<BarberShopDetails> createState() => _BarberShopDetailsState();
}

class _BarberShopDetailsState extends State<BarberShopDetails> {
  @override
  void initState() {
    super.initState();
  }

  var businessName;
  var description;
  var address;
  var token;
  var image;

  var isloading = true;

  @override
  void didChangeDependencies() {
    run();
    super.didChangeDependencies();
  }

  void run() {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (data != null) {
      Business details = Provider.of<ApiCalls>(context, listen: false)
          .getBarberDetails(data['index']);
      businessName = details.businessName;
      description = details.description;
      address = details.city;
      token = data['token'];
      image = data['image'];
      reRun();
    }
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber Details'),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                children: [
                  Container(
                    width: 500,
                    height: 250,
                    child: CachedNetworkImage(
                      //  placeholder: (context, url) => const CircularProgressIndicator(),
                      imageUrl: image,
                      fit: BoxFit.fill,
                    ),
                    //  Image.memory(
                    //   Uint8List.fromList(image.cast<int>().toList()),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        child: Text(
                      businessName,
                      style: const TextStyle(fontSize: 25),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            onPressed: () {},
                            child: const Text(
                              'cancel',
                              style: TextStyle(fontSize: 15),
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, BookingPage.routeName);
                            },
                            child: const Text(
                              'book',
                              style: TextStyle(fontSize: 15),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
