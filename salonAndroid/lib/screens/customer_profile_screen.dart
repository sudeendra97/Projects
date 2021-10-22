import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/customer_booking_details.dart';
import 'package:salon/screens/customer_cut_details.dart';

import 'package:salon/screens/edit_customer_profile_screen.dart';

import '../main.dart';

class CustomerProfileScreenData extends StatefulWidget {
  CustomerProfileScreenData({Key? key}) : super(key: key);

  static const routeName = '/customerProfileScreen';

  @override
  _CustomerProfileScreenDataState createState() =>
      _CustomerProfileScreenDataState();
}

class _CustomerProfileScreenDataState extends State<CustomerProfileScreenData> {
  var image;
  var isloading = true;
  var name;
  var address;
  var city;
  var state;
  var country;
  var token;
  var preferedHairStyle;
  List<dynamic> recentImageCuts = [];
  List<CustomerBooking> bookings = [];
  List<dynamic> imageListData = [];

  @override
  void initState() {
    token = Provider.of<ApiCalls>(context, listen: false).token;
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getUserProfile(token)
          .then((value) async {
        name = value['First_Name'];
        address = value['Street_Address'];
        city = value['City'];
        state = value['State'];
        country = value['Country'];
        image = value['image'];
        recentImageCuts = value['Cut_Images'] ?? [];
        preferedHairStyle = value['Prefered_HairStyle'];
        await Provider.of<ApiCalls>(context, listen: false)
            .getCustomerBookings(token)
            .then((value) {
          if (value.isNotEmpty) {
            bookings = value;
            reRun();
          } else {
            reRun();
          }
        });
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          token = Provider.of<ApiCalls>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .getUserProfile(token)
              .then((value) async {
            name = value['First_Name'];
            address = value['Street_Address'];
            city = value['City'];
            state = value['State'];
            country = value['Country'];
            image = value['image'];
            recentImageCuts = value['Cut_Images'];
            preferedHairStyle = value['Prefered_HairStyle'];
            await Provider.of<ApiCalls>(context, listen: false)
                .getCustomerBookings(token)
                .then((value) {
              if (value.isNotEmpty) {
                bookings = value;
                reRun();
              } else {
                reRun();
              }
            });
            // reRun();
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

  List<dynamic> imageList = [];

  // void pickimages() async {
  //   List? bytesFromPicker =
  //       await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);

  //   if (bytesFromPicker != null) {
  //     // bytesFromPicker.forEach((bytes) => debugPrint(bytes.toString()));
  //     setState(() {
  //       imageList = bytesFromPicker;
  //     });
  //   }
  // }
  //html.File? _cloudFile = null;
  var imageFile;
  List _fileBytes = [];
  Image? _imageWidget = null;
  Image? _imageWidgetFile = null;
  var fileName;
  var fileBase64;
  final ImagePicker _picker = ImagePicker();
  Future<void> getMultipleImageInfos() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    // var mediaData = await ImagePickerWeb.getImageInfo;
    // String? mimeType = mime(Path.basename(mediaData.fileName!));
    // html.File mediaFile =
    //     html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

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
                .updateCustomerProfilePic(_fileBytes, token, fileName)
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
                        },
                        child: const Text('ok'),
                      )
                    ],
                  ),
                );
              }
            });
          }
          // setState(() {

          //   // print(_fileBytes);
          //   // _cloudFile = mediaFile;
          //   // _fileBytes = mediaData.data!;
          //   // _imageWidget = Image.memory(mediaData.data!);
          //   // fileName = mediaData.fileName!;
          //   // fileBase64 = mediaData.base64;
          // });
        });
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
        : Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.black,
            //   title: const Text('Your Profile'),
            //   actions: [
            //     Padding(
            //       padding: const EdgeInsets.only(right: 15.0),
            //       child: IconButton(
            //           onPressed: () {
            //             Navigator.of(context)
            //                 .pushNamed(EditCustomerProfileScreen.routeName);
            //           },
            //           icon: const Icon(Icons.edit)),
            //     )
            //   ],
            // ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: Tooltip(
                              message: 'update Image',
                              child: GestureDetector(
                                onTap: () {
                                  getMultipleImageInfos().then((value) {});
                                },
                                child: image == null && _fileBytes.isEmpty
                                    ? Container(
                                        width: 150,
                                        height: 150,
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        alignment: Alignment.center,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Pick Image',
                                              style: TextStyle(
                                                  backgroundColor: Colors.black,
                                                  color: Colors.white)),
                                        ),
                                      )
                                    : Container(
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(30)),
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: _fileBytes.isEmpty
                                              ? DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(image))
                                              : DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: MemoryImage(
                                                    Uint8List.fromList(
                                                        _fileBytes
                                                            .cast<int>()
                                                            .toList()),
                                                  ),
                                                ),
                                        ),
                                        // child: Container(
                                        //   alignment: Alignment.bottomCenter,
                                        //   child: const Text(
                                        //     'update Image',
                                        //   ),
                                        // )
                                        // child: CircleAvatar(
                                        //   backgroundImage: NetworkImage(image),
                                        // ),
                                        //  FittedBox(
                                        //   fit: BoxFit.contain,
                                        //   child:
                                        //    CachedNetworkImage(
                                        //       //  placeholder: (context, url) => const CircularProgressIndicator(),
                                        //       imageUrl: image),
                                        //   //  Image.memory(
                                        //   //   Uint8List.fromList(
                                        //   //       imageList[index].cast<int>().toList()),
                                        //   // ),
                                        // )
                                      ),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    EditCustomerProfileScreen.routeName);
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          'Hi, $name',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('You Have Not Visited Any Barbers Yet'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          'About',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('Prefered Hair Style: $preferedHairStyle'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('Address: $address'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('City: $city'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('State: $state'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text('Country: $country'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          'Preferences',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          'HairStyles:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                'assets/images/scissor.png',
                                                fit: BoxFit.contain),
                                          ),
                                          backgroundColor: Colors.white,
                                          // backgroundImage: AssetImage(
                                          //   'assets/images/scissor.png',
                                          // ),
                                        )),
                                    preferedHairStyle == null
                                        ? const Text(
                                            'No Prefered Hair Style',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            preferedHairStyle,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          'Length:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                'assets/images/trimmer.png',
                                                fit: BoxFit.contain),
                                          ),
                                          backgroundColor: Colors.white,
                                          // backgroundImage: AssetImage(
                                          //   'assets/images/scissor.png',
                                          // ),
                                        )),
                                    const Text(
                                      'Number 3',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          'Facial Hair:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 30),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircleAvatar(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                'assets/images/beard.png',
                                                fit: BoxFit.contain),
                                          ),
                                          backgroundColor: Colors.white,
                                          // backgroundImage: AssetImage(
                                          //   'assets/images/scissor.png',
                                          // ),
                                        )),
                                    const Text(
                                      'Clean Shaven Straight Razor',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      bookings.isEmpty
                          ? const SizedBox()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Recents:',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                    )
                                  ],
                                )
                              ],
                            ),
                      bookings.isEmpty
                          ? SizedBox()
                          : ListView.builder(
                              itemCount: bookings.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ListTile(
                                        title: Text(bookings[index].shopName),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  CustomerCutDetails.routeName,
                                                  arguments: {
                                                    'barberName':
                                                        bookings[index]
                                                            .barberName,
                                                    'shopName': bookings[index]
                                                        .shopName,
                                                    'shopImage': bookings[index]
                                                        .shopImage,
                                                    'bookedDate':
                                                        bookings[index]
                                                            .selectedDate,
                                                  });
                                            },
                                            icon: const Icon(
                                                Icons.arrow_forward_ios)),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    )
                                  ],
                                );
                              },
                            ),
                      recentImageCuts.isEmpty
                          ? const SizedBox()
                          : const Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Text('Your Recent Cuts',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                      Container(
                        width: 600,
                        height: 150,
                        child: recentImageCuts.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: recentImageCuts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width: 200,
                                        height: 150,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: CachedNetworkImage(
                                              //  placeholder: (context, url) => const CircularProgressIndicator(),
                                              imageUrl: recentImageCuts[index]),
                                          //  Image.memory(
                                          //   Uint8List.fromList(
                                          //       imageList[index].cast<int>().toList()),
                                          // ),
                                        )),
                                  );
                                },
                              ),
                      ),
                      // Container(
                      //   width: 600,
                      //   height: 150,
                      //   child: ListView.builder(
                      //     // shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: imageList.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Container(
                      //             width: 200,
                      //             height: 150,
                      //             child: FittedBox(
                      //               fit: BoxFit.fill,
                      //               child: Image.memory(
                      //                 Uint8List.fromList(
                      //                     imageList[index].cast<int>().toList()),
                      //               ),
                      //             )),
                      //       );
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        height: 15,
                      ),

                      // imageList.isEmpty
                      //     ? const SizedBox()
                      //     : ElevatedButton(
                      //         style: ButtonStyle(
                      //           backgroundColor:
                      //               MaterialStateProperty.all(Colors.black),
                      //         ),
                      //         onPressed: () async {
                      //           List images = [];
                      //           for (int i = 0; i < imageList.length; i++) {
                      //             if (i == 4) {
                      //               break;
                      //             }
                      //             images.add(imageList[i]);
                      //           }
                      //           Provider.of<ApiCalls>(context, listen: false)
                      //               .uploadCuts(images, token, '124565')
                      //               .then((value) {
                      //             setState(() {
                      //               imageList.clear();
                      //               // recentImageCuts = value['Cut_Images'];
                      //             });
                      //           });
                      //         },
                      //         child: const Text('Upload'))
                    ],
                  ),
                ),
              ),
            ),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(25),
            //         child: Container(
            //           // decoration:
            //           //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
            //           height: 50,
            //           width: 150,
            //           child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.all(Colors.black),
            //             ),
            //             onPressed: () {
            //               pickimages();
            //             },
            //             child: const Text(
            //               'Add Cuts',
            //               style: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 30,
            //       ),
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(25),
            //         child: Container(
            //           // decoration:
            //           //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
            //           height: 50,
            //           width: 150,
            //           child: ElevatedButton(
            //             style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.all(Colors.black),
            //             ),
            //             onPressed: () {},
            //             child: const Text(
            //               'View History',
            //               style: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          );
  }
}
