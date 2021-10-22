import 'package:flutter/material.dart';
import 'package:salon/screens/business_signup_flow14.dart';

import '../main.dart';

class BusinessSignUpFlow13 extends StatefulWidget {
  const BusinessSignUpFlow13({Key? key}) : super(key: key);

  static const routeName = '/BusinessSignUpFlow13';

  @override
  State<BusinessSignUpFlow13> createState() => _BusinessSignUpFlow13State();
}

class _BusinessSignUpFlow13State extends State<BusinessSignUpFlow13> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // Map<Map<String, dynamic>, dynamic>
  var signUpData;
  var isloading = true;
  static List list = [];

  @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  // void getData() {
  //   var data = ModalRoute.of(context)!.settings.arguments;
  //   // as Map<Map<String, dynamic>, dynamic>;
  //   signUpData = data;
  //   print(signUpData.toString());
  // }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data = ModalRoute.of(context)!.settings.arguments;
      // as Map<Map<String, dynamic>, dynamic>;
      signUpData = data;
      // print(signUpData.toString());
    }
    isloading = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                WelcomePage.routeName,
                                (Route<dynamic> route) => false);
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
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Text(
                    'Provide Business Name and Description.',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15)),
                        width: 300,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Enter Your Business Name',
                                border: InputBorder.none),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Business Name Cannot be Empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              signUpData['signUpData']['BusinessName'] = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 300,
                        height: 150,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Description',
                                border: InputBorder.none),
                            maxLines: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Description Cannot Be Empty ';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              signUpData['signUpData']['Description'] = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AddBarbers(),
                    ],
                  ),
                )
              ],
            ),
          ),
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
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    _formKey.currentState!.save();
                    signUpData['signUpData']['BarberNames'] =
                        _AddBarbersState.barberList;
                    //   print(signUpData['BarberNames']);
                    Navigator.of(context).pushNamed(
                        BusinessSignUpFlow14.routeName,
                        arguments: signUpData);
                  },
                  child: const Text(
                    'Review',
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

class AddBarbers extends StatefulWidget {
  AddBarbers({Key? key}) : super(key: key);

  @override
  _AddBarbersState createState() => _AddBarbersState();
}

class _AddBarbersState extends State<AddBarbers> {
  static List barberList = [];

  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController mycontroller = TextEditingController();

  void reRun() {
    setState(() {
      //_BusinessSignUpFlow13State.list = barberList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
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
                        barberList.add(mycontroller.text);
                        mycontroller.clear();
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
            height: 10,
          ),
          Container(
            width: 300,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: barberList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: IconButton(
                        onPressed: () {
                          setState(() {
                            barberList.remove(barberList[index]);
                            // _BusinessSignUpFlow13State.list
                            //     .remove(barberList[index]);
                          });
                        },
                        icon: const Icon(Icons.cancel)),
                    title: Text(
                      barberList[index],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
