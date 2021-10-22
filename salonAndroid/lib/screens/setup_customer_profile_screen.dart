import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//import 'dart:html' as html;
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/selectpreferencescreen.dart';
import 'payment_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  CustomerProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/CustomerProfileScreen';

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.symmetric(
      horizontal: 20,
    );
  }

  Map<String, String> profile = {
    'First_Name': '',
    'Last_Name': '',
    'Address': '',
    'City': '',
    'State': '',
    'Pin_Code': '',
    'Country': '',
  };

  @override
  void initState() {
    super.initState();
    token = Provider.of<ApiCalls>(context, listen: false).token;
    print(token);
    if (token == null) {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          token = Provider.of<ApiCalls>(context, listen: false).token;
        }
      });
    }
  }

  //  void _onImageButtonPressed(ImageSource source,
  //     {BuildContext? context, bool isMultiImage = false}) async {
  //   if (_controller != null) {
  //     await _controller!.setVolume(0.0);
  //   }
  //   if (isVideo) {
  //     final XFile? file = await _picker.pickVideo(
  //         source: source, maxDuration: const Duration(seconds: 10));
  //     await _playVideo(file);
  //   } else if (isMultiImage) {
  //     await _displayPickImageDialog(context!,
  //         (double? maxWidth, double? maxHeight, int? quality) async {
  //       try {
  //         final pickedFileList = await _picker.pickMultiImage(
  //           maxWidth: maxWidth,
  //           maxHeight: maxHeight,
  //           imageQuality: quality,
  //         );
  //         setState(() {
  //           _imageFileList = pickedFileList;
  //         });
  //       } catch (e) {
  //         setState(() {
  //           _pickImageError = e;
  //         });
  //       }
  //     });
  //   } else {
  //     await _displayPickImageDialog(context!,
  //         (double? maxWidth, double? maxHeight, int? quality) async {
  //       try {
  //         final pickedFile = await _picker.pickImage(
  //           source: source,
  //           maxWidth: maxWidth,
  //           maxHeight: maxHeight,
  //           imageQuality: quality,
  //         );
  //         setState(() {
  //           _imageFile = pickedFile;
  //         });
  //       } catch (e) {
  //         setState(() {
  //           _pickImageError = e;
  //         });
  //       }
  //     });
  //   }
  // }

  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (ModalRoute.of(context)!.settings.arguments != null) {
  //     token = ModalRoute.of(context)!.settings.arguments;
  //     print(token);
  //   }
  // }

  var imageFile;
  List<dynamic> _fileBytes = [];
  Image? _imageWidget;
  Image? _imageWidgetFile;
  var fileName = '';
  var fileBase64;
  var token;
  var isloading = false;
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
          )).then((croppedImage) {
        if (croppedImage == null) {
          return;
        }
        croppedImage.readAsBytes().then((value) {
          _fileBytes = value;
          setState(() {
            imageFile = croppedImage;
            fileName = image.name;

            print(_fileBytes);
            // _cloudFile = mediaFile;
            // _fileBytes = mediaData.data!;
            // _imageWidget = Image.memory(mediaData.data!);
            // fileName = mediaData.fileName!;
            // fileBase64 = mediaData.base64;
          });
        });
      });
    }
  }

  // Future<Uint8List> _readFileByte(String filePath) async {
  //   Uri myUri = Uri.parse(filePath);
  //   File audioFile = File.fromUri(myUri);
  //   Uint8List bytes ;
  //   await audioFile.readAsBytes().then((value) {
  //     bytes = Uint8List.fromList(value);
  //     print('reading of bytes is completed');
  //   }).catchError((onError) {
  //     print('Exception Error while reading audio from path:' +
  //         onError.toString());
  //   });
  //   return bytes;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: const Text('Profile'),
      // ),
      body: isloading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: const [
                            Text(
                              'Profile SetUp',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          height: 150,
                          width: 180,
                          child: imageFile == null
                              ? Container(
                                  alignment: Alignment.center,
                                  child: const Text('No Image Selected'))
                              : Container(
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(30)),

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(imageFile.path)),
                                      // MemoryImage(
                                      //   Uint8List.fromList(
                                      //       _fileBytes.cast<int>().toList()),
                                      // ),
                                    ),
                                  ),

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
                          // CircleAvatar(
                          //     backgroundImage: MemoryImage(
                          //       Uint8List.fromList(
                          //           _fileBytes.cast<int>().toList()),
                          //     ),
                          //   )
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(150),
                          //   child: FittedBox(
                          //       clipBehavior: Clip.hardEdge,
                          //       fit: BoxFit.cover,
                          //       child:
                          //           //_imageWidgetFile ?? const Text('No Image Selected')),
                          //           _imageWidget ??
                          //               const Text('No Image Selected')),
                          // ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            onPressed: () async {
                              getMultipleImageInfos();
                            },
                            child: const Text('Pick Image',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'FirstName'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'FirstName Cannot Be Empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  profile['First_Name'] = value!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 30,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'LastName'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'LastName Cannot Be Empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  profile['Last_Name'] = value!;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: getPadding(),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Address'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Address Cannot Be Empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              profile['Address'] = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: getPadding(),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'City'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'City Cannot Be Empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              profile['City'] = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: getPadding(),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'State'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'State Cannot Be Empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              profile['State'] = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: getPadding(),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Pincode'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Pincode Cannot Be Empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              profile['Pin_Code'] = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: getPadding(),
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Country'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Country Cannot Be Empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              profile['Country'] = value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  // Invalid!
                                  return;
                                }
                                _formKey.currentState!.save();

                                try {
                                  setState(() {
                                    isloading = true;
                                  });
                                  Provider.of<ApiCalls>(context, listen: false)
                                      .customerProfileSetUp(
                                    profile,
                                    _fileBytes,
                                    token,
                                    fileName,
                                  )
                                      .then((value) {
                                    setState(() {
                                      isloading = false;
                                    });
                                    if (value == 201) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Success'),
                                          content: const Text(
                                              'Successgully uploaded Your profile'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                Navigator.of(context).pushNamed(
                                                    SelectPreferenceScreen
                                                        .routeName);
                                              },
                                              child: const Text('ok'),
                                            )
                                          ],
                                        ),
                                      );
                                      // Scaffold.of(context).showSnackBar(
                                      //   // const SnackBar(
                                      //   //   content: Text(
                                      //   //     'Successfully uploaded your profile',
                                      //   //   ),
                                      //   //   duration: Duration(seconds: 2),
                                      //   //   // action: SnackBarAction(
                                      //   //   //   label: 'UNDO',
                                      //   //   //   onPressed: () {
                                      //   //   //     cart.removeSingleItem(productData.id);
                                      //   //   //   },
                                      //   //   // ),
                                      //   // ),
                                      // );

                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Failed'),
                                          content: const Text(
                                              'Failed to upload Your profile try again'),
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
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Text('Submit')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
