import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/screens/business_signup_flow8.dart';
import 'package:salon/screens/register_screen.dart';

class BusinessSignUpFlow7 extends StatefulWidget {
  BusinessSignUpFlow7({Key? key}) : super(key: key);

  static const routeName = '/BusinessSignUpFlow7';

  @override
  _BusinessSignUpFlow7State createState() => _BusinessSignUpFlow7State();
}

class _BusinessSignUpFlow7State extends State<BusinessSignUpFlow7> {
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.symmetric(horizontal: 50, vertical: 20);
  }

  EdgeInsetsGeometry setPadding() {
    return const EdgeInsets.symmetric(horizontal: 50, vertical: 5);
  }

  List list = [
    'Learn How We Support You',
    'See Other Business Like You',
    'Ask For Help With Our Support Team',
    'Discover More Resources'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: getPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Set Up Your Business Today',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.\nThe point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters,as opposed to using Content here, content here, making it look like readable English.',
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            RegisterScreen.routeName,
                            arguments: 'Business');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Sign Up Now',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          const SizedBox(
            height: 25,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: setPadding(),
                child: const Text(
                  'Set Appointments from Anywhere',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: setPadding(),
                child: const Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
              ),
              SizedBox(
                height: 100,
                width: 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.black,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: setPadding(),
                child: const Text(
                  'Gain Confidence With Your Customers And Never Miss A Style',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: setPadding(),
                child: const Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
              ),
              Padding(
                padding: setPadding(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey),
                  // color: Colors.grey,
                  width: double.infinity,
                  height: 150,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.black,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: setPadding(),
                child: const Text(
                  'learn How We Will Help Your Business Thrive',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: setPadding(),
                child: const Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
              ),
              Padding(
                padding: setPadding(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(list[index]),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.black,
          ),
          Container(
            alignment: Alignment.center,
            padding: setPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.grey,
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  ' "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."',
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('John Doe, Company X'),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.black,
          ),
          Padding(
            padding: getPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Set Up Your Business Today',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.\nThe point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters,as opposed to using Content here, content here, making it look like readable English.',
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(BusinessSignUpFlow8.routeName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Sign Up Now',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
