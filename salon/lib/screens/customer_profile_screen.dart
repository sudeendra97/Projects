import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salon/screens/edit_customer_profile_screen.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;

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
  List<dynamic> recentImageCuts = [];

  @override
  void initState() {
    token = Provider.of<ApiCalls>(context, listen: false).token;
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getUserProfile(token)
          .then((value) {
        name = value['First_Name'];
        address = value['Street_Address'];
        city = value['City'];
        state = value['State'];
        country = value['Country'];
        image = value['image'];
        recentImageCuts = value['Cut_Images'];
        reRun();
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          token = Provider.of<ApiCalls>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .getUserProfile(token)
              .then((value) {
            name = value['First_Name'];
            address = value['Street_Address'];
            city = value['City'];
            state = value['State'];
            country = value['Country'];
            image = value['image'];
            recentImageCuts = value['Cut_Images'];
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
  html.File? _cloudFile = null;
  List _fileBytes = [];
  Image? _imageWidget = null;
  Image? _imageWidgetFile = null;
  var fileName;
  var fileBase64;
  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String? mimeType = mime(Path.basename(mediaData.fileName!));
    html.File mediaFile =
        html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    if (mediaFile != null) {
      setState(() {
        _cloudFile = mediaFile;
        _fileBytes = mediaData.data!;
        _imageWidget = Image.memory(mediaData.data!);
        fileName = mediaData.fileName;
        fileBase64 = mediaData.base64;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Your Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditCustomerProfileScreen.routeName);
                },
                icon: const Icon(Icons.edit)),
          )
        ],
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Tooltip(
                      message: 'update Image',
                      child: GestureDetector(
                        onTap: () {
                          getMultipleImageInfos().then((value) {
                            if (_fileBytes.isNotEmpty) {
                              print('sending');
                              setState(() {
                                isloading = true;
                              });
                              Provider.of<ApiCalls>(context, listen: false)
                                  .updateCustomerProfilePic(
                                      _fileBytes, token, fileName)
                                  .then((value) {
                                setState(() {
                                  isloading = false;
                                });
                                if (value == 200 || value == 201) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text(
                                          'Successfully updated Your Profile Pic'),
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
                        },
                        child: image == null && _fileBytes.isEmpty
                            ? Container(
                                width: 200,
                                height: 180,
                                decoration: BoxDecoration(border: Border.all()),
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
                                width: 200,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: _fileBytes.isEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(image))
                                      : DecorationImage(
                                          fit: BoxFit.contain,
                                          image: MemoryImage(
                                            Uint8List.fromList(_fileBytes
                                                .cast<int>()
                                                .toList()),
                                          ),
                                        ),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: const Text(
                                    'update Image',
                                  ),
                                )
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text('Name: $name'),
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
                  recentImageCuts.isEmpty
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Text('Your Recent Cuts',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
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
