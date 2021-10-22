// import 'dart:io';
// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/main.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/barber_booking_list_screen.dart';

import 'customer_related_screens/personal_information.dart';

class BusinessSignUpFlow14 extends StatefulWidget {
  const BusinessSignUpFlow14({Key? key}) : super(key: key);

  static const routeName = '/BusinessSignUpFlow14';

  @override
  State<BusinessSignUpFlow14> createState() => _BusinessSignUpFlow14State();
}

class _BusinessSignUpFlow14State extends State<BusinessSignUpFlow14> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var signUpData;
  var isloading = true;
  var images;
  var token;

  @override
  void initState() {
    token = Provider.of<ApiCalls>(context, listen: false).token;
    print(token);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (data['image'] != null) {
        images = data['image'];
      }

      signUpData = data;
      // print(signUpData);
      // print(signUpData.toString());
      reRun();
    }

    super.didChangeDependencies();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  EdgeInsetsGeometry setPadding() {
    return const EdgeInsets.only(left: 20);
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
            body: SafeArea(
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      WelcomePage.routeName,
                                      (Route<dynamic> route) => false);
                                  // Navigator.of(context).popUntil(
                                  //     ModalRoute.withName(
                                  //         WelcomePage.routeName));
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 40,
                                )),
                            SizedBox(
                              width: 80,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        PersonalInformation.routeName,
                                        arguments: 'This is a Help Page');
                                  },
                                  child: const Text('Help'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Text(
                        'Check Out Your Business',
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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            images.isEmpty
                                ? Container(
                                    height: 250,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      // borderRadius: BorderRadius.circular(35),
                                    ),
                                  )
                                : Container(
                                    height: 250,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: images.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          // decoration: BoxDecoration(border: Border.all()),
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.memory(images[index])
                                              //  kIsWeb == true
                                              //     ? Image.network(image!.path)
                                              //     : Image.file(
                                              //         File(image!.path),
                                              //       )
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: setPadding(),
                              child: TextFormField(
                                enabled: false,
                                initialValue: signUpData['signUpData']
                                    ['BusinessName'],
                                decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: InputBorder.none),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: setPadding(),
                              height: 100,
                              child: TextFormField(
                                enabled: false,
                                initialValue: signUpData['signUpData']
                                    ['Description'],
                                decoration: const InputDecoration(
                                    labelText: 'Description',
                                    border: InputBorder.none),
                                maxLines: 5,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: setPadding(),
                              child: TextFormField(
                                enabled: false,
                                initialValue:
                                    '${signUpData['signUpData']['Street']},${signUpData['signUpData']['Apt']}',
                                decoration: const InputDecoration(
                                    labelText: 'Location',
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: signUpData['signUpData']['BarberNames'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.cancel)),
                          title: Text(
                            signUpData['signUpData']['BarberNames'][index],
                          ));
                    },
                  ),
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          print('sending');
                          setState(() {
                            isloading = true;
                          });
                          Provider.of<ApiCalls>(context, listen: false)
                              .signUp(signUpData, token)
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
                                      'Successfully uploaded Your Shop'),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                BarberBookingListScreen
                                                    .routeName,
                                                (Route<dynamic> route) =>
                                                    false);
                                        // Navigator.of(context).pushNamedAndRemoveUntil(
                                        //     BarberBookingListScreen.routeName,
                                        //     ModalRoute.withName(
                                        //         WelcomePage.routeName));
                                      },
                                      child: const Text('ok'),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Failed'),
                                  content: const Text(
                                      'Failed to upload your Shop Details Please Try Again'),
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
                        },
                        child: const Text(
                          'Submit',
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
