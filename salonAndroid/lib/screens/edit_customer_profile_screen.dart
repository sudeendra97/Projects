import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';

class EditCustomerProfileScreen extends StatefulWidget {
  EditCustomerProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/editCustomerProfile';

  @override
  _EditCustomerProfileScreenState createState() =>
      _EditCustomerProfileScreenState();
}

class _EditCustomerProfileScreenState extends State<EditCustomerProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var isloading = true;
  var image;

  var firstName;
  var lastName;
  var userId;
  var pinCode;
  var address;
  var city;
  var state;
  var country;
  var token;
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(
      left: 10,
    );
  }

  Map<String, String> profile = {
    'First_Name': '',
    'Last_Name': '',
    'Street_Address': '',
    'City': '',
    'State': '',
    'Pin_Code': '',
    'Country': '',
  };
  void initState() {
    token = Provider.of<ApiCalls>(context, listen: false).token;
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getUserProfile(token)
          .then((value) {
        firstName = value['First_Name'];
        lastName = value['Last_Name'];
        userId = value['User_Id'];
        address = value['Street_Address'];
        city = value['City'];
        state = value['State'];
        country = value['Country'];
        pinCode = value['Zip_Code'];
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
            firstName = value['First_Name'];
            lastName = value['Last_Name'];
            userId = value['User_Id'];
            address = value['Street_Address'];
            city = value['City'];
            state = value['State'];
            country = value['Country'];
            pinCode = value['Zip_Code'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile'),
      ),
      body: isloading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                              initialValue: firstName,
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
                              initialValue: lastName,
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
                          initialValue: address,
                          decoration: const InputDecoration(
                              labelText: 'Street_Address'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Address Cannot Be Empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            profile['Street_Address'] = value!;
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
                          initialValue: city,
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
                          initialValue: state,
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
                          initialValue: pinCode,
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
                          initialValue: country,
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
                            print(profile);
                            setState(() {
                              isloading = true;
                            });
                            Provider.of<ApiCalls>(context, listen: false)
                                .updateCustomerProfile(profile, token)
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
                                        'Successfully updated Your Profile'),
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
                            // setState(() {
                            //   isloading = true;
                            // });
                            // Provider.of<ApiCalls>(context, listen: false)
                            //     .customerProfileSetUp(
                            //   profile,
                            //   _fileBytes,
                            //   token,
                            //   fileName,
                            // )
                            //     .then((value) {
                            //   setState(() {
                            //     isloading = false;
                            //   });
                            //   if (value == 201) {
                            //     showDialog(
                            //       context: context,
                            //       builder: (ctx) => AlertDialog(
                            //         title: const Text('Success'),
                            //         content: const Text(
                            //             'Successgully uploaded Your profile'),
                            //         actions: [
                            //           FlatButton(
                            //             onPressed: () {
                            //               Navigator.of(ctx).pop();

                            //             },
                            //             child: const Text('ok'),
                            //           )
                            //         ],
                            //       ),
                            //     );
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

                            // } else {
                            //   showDialog(
                            //     context: context,
                            //     builder: (ctx) => AlertDialog(
                            //       title: const Text('Failed'),
                            //       content: const Text(
                            //           'Failed to upload Your profile try again'),
                            //       actions: [
                            //         FlatButton(
                            //           onPressed: () {
                            //             Navigator.of(ctx).pop();
                            //           },
                            //           child: const Text('ok'),
                            //         )
                            //       ],
                            //     ),
                            //   );
                            // }

                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text('update')),
                  ],
                ),
              ),
            ),
    );
  }
}
