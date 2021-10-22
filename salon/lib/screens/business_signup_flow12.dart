import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/screens/business_signup_flow13.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;

import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

class BusinessSignUpFlow12 extends StatefulWidget {
  const BusinessSignUpFlow12({Key? key}) : super(key: key);

  static const routeName = '/BusinessSignUpFlow12';

  @override
  State<BusinessSignUpFlow12> createState() => _BusinessSignUpFlow12State();
}

class _BusinessSignUpFlow12State extends State<BusinessSignUpFlow12> {
  final ImagePicker _picker = ImagePicker();
  var image;
  PlatformFile? objFile = null;
  var pickedImage;
  Object? fromPicker;
  Uint8List? data;
  html.File? _cloudFile = null;
  var _fileBytes;
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
        _fileBytes = mediaData.data;
        _imageWidget = Image.memory(mediaData.data!);
        fileName = mediaData.fileName;
        fileBase64 = mediaData.base64;
      });
    }
  }

  // Future<void> _takePicture() async {
  //   // image = await _picker.pickImage(source: ImageSource.gallery);
  //   FilePickerResult? result = await FilePicker.platform
  //       .pickFiles(
  //     withReadStream: true,
  //     // type: FileType.custom,
  //     // allowedExtensions: ['jpg', 'pdf', 'doc'],
  //   )
  //       .then((value) {
  //     if (value != null) {
  //       objFile = value.files.single;
  //       data = objFile!.bytes;

  //       setState(() {
  //         _imageWidgetFile = Image.memory(data!);
  //         // print(objFile.bytes.toString());
  //         // signUpData['image'] = file;
  //       });
  //     }
  //   });

  // if (image != null) {
  //   setState(() {});
  // }
  // fromPicker =
  //     await ImagePickerWeb.getImage(outputType: ImageType.widget);

  // if (fromPicker != null) {
  //   setState(() {

  //     print(fromPicker.toString());
  //   });
  // }
  // }

  Map<String, dynamic> signUpData = {
    'Street': '',
    'Apt': '',
    'city': '',
    'State': '',
    'ZipCode': '',
    'Country': '',
    'Business': '',
    'Description': '',
    'BusinessName': '',
  };

  var isloading = true;
  @override
  void initState() {
    super.initState();
  }

  // void getdata()
  // {
  //     var data =
  //         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //     print(data.toString());
  //     // signUpData['Street'] != data['Street'];
  //     // signUpData['Apt'] != data['Apt'];
  //     // signUpData['city'] != data['city'];
  //     // signUpData['State'] != data['State'];
  //     // signUpData['ZipCode'] != data['ZipCode'];
  //     // signUpData['Country'] != data['Country'];
  //     // signUpData['Business'] != data['Business'];
  //     signUpData = data;
  //     print(signUpData.toString());

  // }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      // print(data.toString());
      // signUpData['Street'] != data['Street'];
      // signUpData['Apt'] != data['Apt'];
      // signUpData['city'] != data['city'];
      // signUpData['State'] != data['State'];
      // signUpData['ZipCode'] != data['ZipCode'];
      // signUpData['Country'] != data['Country'];
      // signUpData['Business'] != data['Business'];
      signUpData = data;
      //print(signUpData.toString());
    }
    isloading = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('/'));
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 40,
                      )),
                  // SizedBox(
                  //   width: 80,
                  //   height: 50,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(25),
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(
                  //         backgroundColor:
                  //             MaterialStateProperty.all(Colors.black),
                  //       ),
                  //       onPressed: () {},
                  //       child: const Text('Help'),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            const Text(
              'Upload A Few Photos Of Your Business',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              height: 250,
              width: 300,
              // decoration: BoxDecoration(
              //   border: Border.all(),
              //   borderRadius: BorderRadius.circular(15),
              // ),
              child: FittedBox(
                  clipBehavior: Clip.hardEdge,
                  fit: BoxFit.contain,
                  child:
                      //_imageWidgetFile ?? const Text('No Image Selected')),
                      _imageWidget ?? const Text('No Image Selected')),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  // _takePicture();
                  getMultipleImageInfos();
                },
                child: const Text(
                  'Pick Image',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                )),
            // TextButton(
            //   onPressed: () async {
            //     // _takePicture();
            //     getMultipleImageInfos();
            //   },
            //   child: const Text(
            //     'Pick Image',
            //     style: TextStyle(fontSize: 25, color: Colors.black),
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
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
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded)),
            ),
            const SizedBox(
              width: 80,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      BusinessSignUpFlow13.routeName,
                      arguments: {
                        'signUpData': signUpData,
                        'image': _fileBytes,
                        'uploadData': _cloudFile,
                        'fileName': fileName,
                        'uploadImage': base64,
                      },
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
