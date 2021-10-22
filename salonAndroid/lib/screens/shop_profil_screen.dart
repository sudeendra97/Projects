import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/edit_shop_profile_screen.dart';
// import 'dart:html' as html;
import 'package:image_cropper/image_cropper.dart';

class ShopProfilScreen extends StatefulWidget {
  ShopProfilScreen({Key? key}) : super(key: key);
  static const routeName = '/ShopProfileScreen';

  @override
  _ShopProfilScreenState createState() => _ShopProfilScreenState();
}

class _ShopProfilScreenState extends State<ShopProfilScreen> {
  var isloading = true;
  var businessName;
  var description;
  var address;
  List barbers = [];
  List images = [];
  var token;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    token = Provider.of<ApiCalls>(context, listen: false).token;
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getShopProfile(token)
          .then((value) {
        businessName = value['ShopName'];
        address = value['Address'];
        description = value['Description'];
        barbers = value['Barbers'];

        images = value['image'];
        reRun();
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          token = Provider.of<ApiCalls>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .getShopProfile(token)
              .then((value) {
            businessName = value['ShopName'];
            address = value['Address'];
            description = value['Description'];
            barbers = value['Barbers'];
            images = value['image'];
            reRun();
          });
        }
      });
    }
    super.initState();
  }

  void reFetch() {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        token = Provider.of<ApiCalls>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .getShopProfile(token)
            .then((value) {
          businessName = value['ShopName'];
          address = value['Address'];
          description = value['Description'];
          barbers = value['Barbers'];
          images = value['image'];
          reRun();
        });
      }
    });
  }

  // html.File? _cloudFile = null;
  var imageFile;
  List _fileBytes = [];
  Image? _imageWidget = null;
  Image? _imageWidgetFile = null;
  var fileName;
  var fileBase64;
  final ImagePicker _picker = ImagePicker();
  Future<void> getMultipleImageInfos(var oldImage) async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: const AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          )).then((value) {
        if (value == null) {
          return;
        }
        value.readAsBytes().then((value) {
          _fileBytes = value;
          imageFile = image;
          fileName = image.name;
          if (_fileBytes.isNotEmpty) {
            print('sending');
            setState(() {
              isloading = true;
            });
            Provider.of<ApiCalls>(context, listen: false)
                .updateShopProfilePic(_fileBytes, token, fileName, oldImage)
                .then((value) {
              setState(() {
                isloading = false;
              });
              if (value == 200 || value == 201) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Success'),
                    content:
                        const Text('Successfully updated Your Profile Pic'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          reFetch();
                        },
                        child: const Text('ok'),
                      )
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Failed'),
                    content: const Text('Unable To upload Your Profile Pic'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('ok'),
                      )
                    ],
                  ),
                );
              }
            });
          }
        });
      });
    }
  }

  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditShopProfile.routeName);
                },
                icon: const Icon(Icons.edit)),
          )
        ],
      ),
      body: isloading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Tooltip(
                      message: 'update Image',
                      child: images.isEmpty && _fileBytes.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                getMultipleImageInfos('');
                              },
                              child: Container(
                                width: 300,
                                height: 200,
                                alignment: Alignment.center,
                                child: const Text('Pic Image'),
                              ),
                            )
                          : Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width - 20,
                              child: Stack(
                                children: [
                                  _buildBackgroundImages(),
                                  _buildSliderDots()
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text('Name: $businessName'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text('Address: $address'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text('Description: $description'),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text(
                      'Barbers',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: barbers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 30,
                          child: Text(
                            barbers[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSliderDots() {
    return Positioned(
      left: 200,
      bottom: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.map((url) {
          int index = images.indexOf(url);
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

  Widget _buildBackgroundImages() {
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
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () {
            getMultipleImageInfos(images[index]).then((value) {});
            // final a = Uri.parse(images[index]);
            // print(a.pathSegments.last);
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 200,
            child: FittedBox(
              fit: BoxFit.contain,
              child: CachedNetworkImage(imageUrl: images[index]),
            ),
          ),
        );
      },
    );
  }
}
