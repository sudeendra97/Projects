import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salon/screens/edit_shop_profile_screen.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;

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
  var image;
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

        image = value['image'];
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
            image = value['image'];
            reRun();
          });
        }
      });
    }
    super.initState();
  }

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
                              Provider.of<ApiCalls>(context, listen: false)
                                  .updateShopProfilePic(
                                      _fileBytes, token, fileName)
                                  .then((value) {
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
                                width: 300,
                                height: 200,
                                alignment: Alignment.center,
                                child: const Text('Pic Image'),
                              )
                            : Container(
                                width: 300,
                                height: 200,
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
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: const Text(
                                      'update Image',
                                    ),
                                  ),
                                )
                                // child: Image.network(image, fit: BoxFit.contain),
                                //  CircleAvatar(
                                //   backgroundImage: NetworkImage(
                                //     image,
                                //   ),
                                // ),
                                // FittedBox(
                                //   fit: BoxFit.contain,
                                //   child: image.isEmpty
                                //       ? const Text('No Profile Pic')
                                //       : CachedNetworkImage(
                                //           placeholder: (context, url) =>
                                //               const CircularProgressIndicator(),
                                //           imageUrl:
                                //               'https://ik.imagekit.io/krckmbkshxd/Hairambe/a_big_tree_landscape_scenery_of_highdefinition_picture_xjRHHP5tc.jpg?updatedAt=1632506190073',
                                //         ),
                                //   // Image.memory(
                                //   //     Uint8List.fromList(image.cast<int>().toList()),
                                //   //   ),
                                // ),
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
}
