import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/screens/favorite_barber_shop.dart';

import 'explore_shop_list_screen.dart';

class MyFavorites extends StatefulWidget {
  MyFavorites({Key? key}) : super(key: key);
  static const routeName = '/MyFavorites';

  @override
  _MyFavoritesState createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  var isloading = true;
  Uint8List? image;
  List<Business> barberList = [];
  var token;

  @override
  void didChangeDependencies() {
    Provider.of<ApiCalls>(
      context,
      listen: false,
    ).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<ApiCalls>(
          context,
          listen: false,
        ).token;
        Provider.of<ApiCalls>(
          context,
          listen: false,
        ).fetchFavoriteList(token).then((value) {
          barberList = value;
          print(barberList.isEmpty);
          reRun();
        });
      }
    });

    super.didChangeDependencies();
  }

  Future<void> reFetch(bool remove) async {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<ApiCalls>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .fetchFavoriteList(token)
            .then((value) {
          barberList = value;
          print(barberList.isEmpty);
          if (remove == true) {
            reRunToSet();
          } else {
            reRun();
          }
        });
      }
    });
  }

  void reRunToSet() {
    setState(() {
      isloading = false;
    });
    Scaffold.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Successfully Removed From Favorites',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  int _count = 0;

  // Pass this method to the child page.
  void _update(int count) {
    if (count == 100) {
      setState(() {
        reFetch(true);
      });
    } else if (count == 200) {
      setState(() {
        isloading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: Colors.black,
          )))
        : RefreshIndicator(
            onRefresh: () => reFetch(false),
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                //extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  // toolbarHeight: 60,
                  // bottomOpacity: 0,
                  // elevation: 0,
                  title: const Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Your Favorites',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  backgroundColor: Colors.black,
                  actions: const [
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 15, top: 15),
                    //   child: IconButton(
                    //     onPressed: () {
                    //       reFetch(false);
                    //     },
                    //     icon: const Icon(
                    //       Icons.refresh,
                    //       size: 26,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                body: barberList.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('No Favorites Please Explore'),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Or'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black)),
                                    onPressed: () {
                                      reFetch(false);
                                    },
                                    child: const Text('Refresh')),
                              ),
                            ),
                          )
                        ],
                      ))
                    : SafeArea(
                        child: ListView(
                          children: [
                            for (var data in barberList)
                              FavoriteBarberShop(
                                  businessName: data.businessName,
                                  description: data.description,
                                  imagePath: data.imagepath,
                                  index: data.index,
                                  token: token,
                                  id: data.id,
                                  key: UniqueKey(),
                                  favorite: true,
                                  update: _update)
                          ],
                        ),
                      ),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () {
                                // ExploreShopList();
                                // print('data');
                                Navigator.of(context)
                                    .pushNamed(ExploreShopList.routeName);
                              },
                              child: const Text(
                                'Explore',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
