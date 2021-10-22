import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';

class EditShopProfile extends StatefulWidget {
  EditShopProfile({Key? key}) : super(key: key);
  static const routeName = '/EditShopProfile';

  @override
  _EditShopProfileState createState() => _EditShopProfileState();
}

class _EditShopProfileState extends State<EditShopProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController mycontroller = TextEditingController();
  var isloading = true;
  var businessName;
  var description;
  var street;
  var city;
  var state;
  var zipCode;
  var country;
  var barberNames = [];
  var userId;
  var token;
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(
      left: 10,
    );
  }

  void reRun() {
    setState(() {
      //_BusinessSignUpFlow13State.list = barberList;
    });
  }

  void reSet() {
    setState(() {
      isloading = false;
    });
  }

  Map<String, dynamic> profile = {
    'Business_Name': '',
    'Description': '',
    'Street': '',
    'City': '',
    'State': '',
    'Pin_Code': '',
    'Country': '',
    'Barber_Name': [],
  };
  @override
  void initState() {
    token = Provider.of<ApiCalls>(context, listen: false).token;
    print(token);
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getShopProfile(token)
          .then((value) {
        businessName = value['ShopName'];
        street = value['Address'];
        city = value['City'];
        state = value['State'];
        zipCode = value['ZipCode'];
        country = value['Country'];
        description = value['Description'];
        barberNames = value['Barbers'];
        userId = value['UserId'];
        reSet();
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
            street = value['Address'];
            city = value['City'];
            state = value['State'];
            zipCode = value['ZipCode'];
            country = value['Country'];
            description = value['Description'];
            barberNames = value['Barbers'];
            userId = value['UserId'];
            reSet();
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile'),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 310,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Padding(
                            padding: getPadding(),
                            child: TextFormField(
                              initialValue: businessName,
                              decoration: const InputDecoration(
                                  labelText: 'business Name'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'FirstName Cannot Be Empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                profile['Business_Name'] = value!;
                              },
                            ),
                          ),
                        ),

                        // Container(
                        //   width: 150,
                        //   decoration: BoxDecoration(border: Border.all()),
                        //   child: Padding(
                        //     padding: getPadding(),
                        //     child: TextFormField(
                        //       initialValue: lastName,
                        //       decoration:
                        //           const InputDecoration(labelText: 'LastName'),
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return 'LastName Cannot Be Empty';
                        //         }
                        //         return null;
                        //       },
                        //       onSaved: (value) {
                        //         profile['Last_Name'] = value!;
                        //       },
                        //     ),
                        //   ),
                        // )
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
                          maxLines: 4,
                          initialValue: description,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Description Cannot Be Empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            profile['Description'] = value!;
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
                          initialValue: street,
                          decoration:
                              const InputDecoration(labelText: 'Street'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Street Cannot Be Empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            profile['Street'] = value!;
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
                          initialValue: zipCode,
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
                    Container(
                      width: 300,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: barberNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      barberNames.remove(barberNames[index]);
                                      // _BusinessSignUpFlow13State.list
                                      //     .remove(barberList[index]);
                                    });
                                  },
                                  icon: const Icon(Icons.cancel)),
                              title: Text(
                                barberNames[index],
                              ));
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Add barber'),
                            content: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Barber Name',
                              ),
                              controller: mycontroller,
                              // onSaved: (value) {
                              //   barberList.add(value);
                              // },
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  barberNames.add(mycontroller.text);
                                  Navigator.of(ctx).pop();
                                  reRun();
                                },
                                child: const Text('ok'),
                              )
                            ],
                          ),
                        );
                      },
                      child: const Text('Add Barbers'),
                    ),
                    const SizedBox(
                      height: 15,
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
                            profile['Barber_Name'] = barberNames;
                            print(profile);
                            Provider.of<ApiCalls>(context, listen: false)
                                .updateShopProfile(profile, token)
                                .then((value) {
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
                        child: const Text('Update')),
                  ],
                ),
              ),
            ),
    );
  }
}
