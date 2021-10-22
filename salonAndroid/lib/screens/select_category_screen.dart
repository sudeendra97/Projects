import 'package:flutter/material.dart';
import 'package:salon/screens/business_signup_flow10.dart';
import 'package:salon/screens/business_signup_flow7.dart';
import 'package:salon/screens/register_screen.dart';

import '../main.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  static const routeName = '/SelectCategoryScreen';

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

enum pickShop {
  BarberShop,
  Salon,
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  var shop;
  var isbarber = false;
  var isSalon = false;
  var business;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.of(context)
                  //           .pushReplacementNamed(WelcomePage.routeName);
                  //     },
                  //     icon: const Icon(
                  //       Icons.cancel_outlined,
                  //       size: 40,
                  //     )),
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
              'Select Category',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed(
                        //   BusinessSignUpFlow7.routeName,
                        // );
                        Navigator.of(context).pushNamed(
                            RegisterScreen.routeName,
                            arguments: 'Business');
                        // setState(() {
                        //   isbarber = true;
                        //   isSalon = false;
                        // });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isbarber == true
                                    ? Colors.red
                                    : Colors.white10),
                          ),

                          height: 150,
                          width: 150,
                          child: Image.asset(
                            'assets/images/barberShop.jpg',
                            fit: BoxFit.contain,
                          ),
                          //  color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Set Up A Business')
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            RegisterScreen.routeName,
                            arguments: 'Customer');
                        // setState(() {
                        //   isSalon = true;
                        //   isbarber = false;
                        // });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isSalon == true
                                    ? Colors.red
                                    : Colors.white10),
                          ),
                          height: 150,
                          width: 150,
                          // color: Colors.grey,
                          child: Image.asset(
                            'assets/images/customer.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('A Customer')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(15.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           border: Border.all(),
      //           borderRadius: BorderRadius.circular(20),
      //         ),
      //         height: 50,
      //         width: 50,
      //         child: IconButton(
      //             iconSize: 30,
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             icon: const Icon(Icons.arrow_back_rounded)),
      //       ),
      //       const SizedBox(
      //         width: 80,
      //       ),
      //       ClipRRect(
      //         borderRadius: BorderRadius.circular(25),
      //         child: Container(
      //           // decoration:
      //           //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
      //           height: 50,
      //           width: 200,
      //           child: ElevatedButton(
      //             style: ButtonStyle(
      //               backgroundColor: MaterialStateProperty.all(Colors.black),
      //             ),
      //             onPressed: () {
      //               if (isbarber == true) {
      //                 business = 'BarberShop';
      //               } else {
      //                 business = 'Salon';
      //               }
      //               Navigator.of(context).pushNamed(
      //                   BusinessSignUpFlow10.routeName,
      //                   arguments: business);
      //             },
      //             child: const Text(
      //               'Next',
      //               style: TextStyle(fontSize: 25),
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
