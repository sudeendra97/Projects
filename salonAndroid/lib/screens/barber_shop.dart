import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/screens/bookingpage.dart';

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
  List image = [];

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

  int currentPos = 0;

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
              title: const Text('Shop Details'),
              backgroundColor: Colors.black,
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: const [
                          Text(
                            'Salon',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    image.isEmpty
                        ? Container(
                            width: 500,
                            height: 250,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 300,
                            child: Stack(children: [
                              _buildBackgroundImage(),
                              _buildSliderDots(),
                            ]),
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
                  ],
                ),
              ),
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 50,
                  width: 50,
                  child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        // newData.clear();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded)),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          Navigator.pushNamed(context, BookingPage.routeName);
                        },
                        child: const Text(
                          'Book Now',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildSliderDots() {
    return Positioned(
      width: MediaQuery.of(context).size.width - 50,
      // left: MediaQuery.of(context).size.width / 2,
      bottom: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: image.map((url) {
          int index = image.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPos == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        viewportFraction: 10,
        autoPlayAnimationDuration: const Duration(seconds: 1),
        // autoPlayInterval: ,

        // aspectRatio: 16 / 9,

        scrollDirection: Axis.horizontal,
        autoPlay: true,
        onPageChanged: (index, reason) {
          setState(() {
            currentPos = index;
          });
        },
      ),
      itemCount: image.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          width: 400,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              //  placeholder: (context, url) => const CircularProgressIndicator(),
              imageUrl: image[index],
              fit: BoxFit.fill,
            ),
          ),
          //  Image.memory(
          //   Uint8List.fromList(image.cast<int>().toList()),
          //   fit: BoxFit.fill,
          // ),
        );
      },
    );
  }
}
