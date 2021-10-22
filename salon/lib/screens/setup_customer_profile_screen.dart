import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
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
    return const EdgeInsets.only(
      left: 10,
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

  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (ModalRoute.of(context)!.settings.arguments != null) {
  //     token = ModalRoute.of(context)!.settings.arguments;
  //     print(token);
  //   }
  // }

  html.File? _cloudFile = null;
  var _fileBytes = [];
  Image? _imageWidget = null;
  Image? _imageWidgetFile = null;
  var fileName = '';
  var fileBase64;
  var token;
  var isloading = false;

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
        fileName = mediaData.fileName!;
        fileBase64 = mediaData.base64;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile'),
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(30),
                        // ),
                        height: 150,
                        width: 180,
                        child: _fileBytes.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                child: const Text('No Image Selected'))
                            : Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(30)),

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: MemoryImage(
                                      Uint8List.fromList(
                                          _fileBytes.cast<int>().toList()),
                                    ),
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
                    ElevatedButton(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Padding(
                            padding: getPadding(),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'FirstName'),
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
                          width: 150,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Padding(
                            padding: getPadding(),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'LastName'),
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
                      width: 310,
                      decoration: BoxDecoration(border: Border.all()),
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
                      width: 310,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                        padding: getPadding(),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'City'),
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
                      width: 310,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                        padding: getPadding(),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'State'),
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
                      width: 310,
                      decoration: BoxDecoration(border: Border.all()),
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
                      width: 310,
                      decoration: BoxDecoration(border: Border.all()),
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
                    ElevatedButton(
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
                                              PaymentScreen.routeName);
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
                  ],
                ),
              ),
            ),
    );
  }
}
