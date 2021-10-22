import 'dart:typed_data';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_details.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/screens/barber_shop.dart';
import 'package:salon/screens/default_customer_profile_screen.dart';
import 'package:salon/screens/map_screen.dart';
import 'package:salon/screens/myfavorites.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BarberShopList extends StatefulWidget {
  BarberShopList({Key? key}) : super(key: key);

  static const routeName = '/BarberShopList';

  @override
  _BarberShopListState createState() => _BarberShopListState();
}

class _BarberShopListState extends State<BarberShopList> {
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
  int _selectedIndex = 0;
  var home;
  var search;
  var profile;

  List pages = [MyFavorites(), MapScreen(), DefaultCustomerProfileScreen()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: Colors.black,
          )))
        : SafeArea(
            child: Scaffold(
              body: pages.elementAt(_selectedIndex),
              // ListView(
              //   children: [
              //     for (var data in barberList)
              //       SizedBox(
              //         width: 450,
              //         height: 250,
              //         child: BarberShop(
              //           businessName: data.businessName,
              //           description: data.description,
              //           imagePath: data.imagepath,
              //           index: data.index,
              //           token: token,
              //           id: data.id,
              //           key: UniqueKey(),
              //           favorite: false,
              //           update: _update,
              //         ),
              //       )
              //   ],
              // ),

              bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: _selectedIndex == 0
                            ? const Icon(
                                Icons.home_filled,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.home_outlined,
                                color: Colors.black,
                              ),
                        label: 'Home',
                        backgroundColor: Colors.white),
                    BottomNavigationBarItem(
                        icon: _selectedIndex == 1
                            ? const Icon(
                                Icons.location_searching_rounded,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                        label: 'Search',
                        backgroundColor: Colors.white),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 2
                          ? const Icon(
                              Icons.person,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.person_outline,
                              color: Colors.black,
                            ),
                      label: 'Profile',
                      backgroundColor: Colors.white,
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.black,
                  iconSize: 30,
                  onTap: _onItemTapped,
                  elevation: 5),
            ),
          );
  }
}

class BarberShop extends StatefulWidget {
  BarberShop({
    required this.businessName,
    required this.description,
    required this.imagePath,
    required this.index,
    this.token,
    this.id,
    Key? key,
    required this.favorite,
    required this.update,
  });

  final String businessName;
  final String description;
  final List imagePath;
  final int index;
  var token;
  var id;
  final bool favorite;
  final ValueChanged<int> update;

  @override
  State<BarberShop> createState() => _BarberShopState();
}

class _BarberShopState extends State<BarberShop> {
  void setFavorites(var id) {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<ApiCalls>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .addToFavorites(id, token)
            .then((value) {
          if (value == 200 || value == 201 || value == 204) {
          } else {
            Scaffold.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unable to add shop to Favorites',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Added shop to Favorites',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void deleteFavorite(var id) {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<ApiCalls>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .deleteFavorite(id, token)
            .then((value) {
          if (value == 200 || value == 201 || value == 204) {
            widget.update(100);
          } else {
            Scaffold.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unable to add shop to Favorites',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
          // barberList = value;
          // print(barberList.isEmpty);

          // reRun();
        });
      }
    });
  }

  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            height: 300,
            child: TextButton(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Stack(
                  children: [
                    _buildBackground(),
                    _buildFavoriteButton(),
                    _buildSliderDots(),
                  ],
                ),
              ),
              onPressed: () {
                BarberDetails.id = widget.id;
                Navigator.of(context).pushNamed(
                  BarberShopDetails.routeName,
                  arguments: {
                    'index': widget.index,
                    'token': widget.token,
                    'image': widget.imagePath
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    widget.businessName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderDots() {
    return Positioned(
      width: MediaQuery.of(context).size.width - 80,
      // left: 180,
      bottom: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imagePath.map((url) {
          int index = widget.imagePath.indexOf(url);
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

  Widget _buildBackground() {
    return widget.imagePath.isEmpty
        ? Container(
            alignment: Alignment.center,
            width: 500,
            height: 300,
            child: const Text('NO Image'))
        : FittedBox(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 500,
              height: 300,
              child: CarouselSlider.builder(
                itemCount: widget.imagePath.length,
                options: CarouselOptions(
                  autoPlayCurve: Curves.easeInOutQuart,
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
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return SizedBox(
                    width: 500,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      // width: 400,
                      imageUrl: widget.imagePath[index],
                    ),
                  );
                },
                // itemBuilder: (BuildContext context, int index) {
                //   return
                //   CachedNetworkImage(
                //     fit: BoxFit.fill,
                //     width: 500,
                //     imageUrl: widget.imagePath[index],
                //   );
                // },
              ),
            ),
          );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
        right: 5,
        top: 5,
        child: widget.favorite != true
            ? IconButton(
                color: Colors.white,
                onPressed: () {
                  print('pressed');
                  setFavorites(widget.id);
                },
                icon: const Icon(Icons.add_circle_outlined),
              )
            : IconButton(
                color: Colors.white,
                onPressed: () {
                  print('delete');
                  deleteFavorite(widget.id);
                },
                icon: const Icon(Icons.remove_circle_rounded),
              ));
  }

  Widget _buildTitleAndSubtitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.businessName,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.description,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
