import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/screens/business_signup_flow12.dart';

class BusinessSignUpFlow10 extends StatefulWidget {
  const BusinessSignUpFlow10({Key? key}) : super(key: key);

  static const routeName = '/BusinessSignUpFlow10';

  @override
  State<BusinessSignUpFlow10> createState() => _BusinessSignUpFlow10State();
}

class _BusinessSignUpFlow10State extends State<BusinessSignUpFlow10> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var business;

  Map<String, dynamic> newData = {
    'Street': '',
    'Apt': '',
    'city': '',
    'State': '',
    'ZipCode': '',
    'Country': '',
    'Business': '',
    'Description': '',
    'BusinessName': '',
    'BarberNames': [],
  };

  @override
  void initState() {
    super.initState();
  }

  var isloading = true;

  @override
  void didChangeDependencies() {
    if (isloading == true) {
      newData['Business'] =
          ModalRoute.of(context)!.settings.arguments.toString();
      print(newData['Business']);
    }
    isloading = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            // newData.clear();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded)),
                    ),
                    // const SizedBox(
                    //   width: 8,
                    // ),
                  ],
                ),
              ),
              const Text(
                'Enter Your Business Address',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(15)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Street'),
                          onSaved: (value) {
                            newData['Street'] = value!;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Apt,Suite,Etc'),
                          onSaved: (value) {
                            newData['Apt'] = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'City'),
                          onSaved: (value) {
                            newData['city'] = value!;
                          },
                        ),
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'State'),
                                onSaved: (value) {
                                  newData['State'] = value!;
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Zip Code'),
                                onSaved: (value) {
                                  newData['ZipCode'] = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Country'),
                          onSaved: (value) {
                            newData['Country'] = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
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
                    // print(newData.toString());
                    Navigator.of(context).pushNamed(
                        BusinessSignUpFlow12.routeName,
                        arguments: newData);
                  },
                  child: const Text(
                    'Looks Good',
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
