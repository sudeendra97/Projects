import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/barber_booking_list_screen.dart';
import 'package:salon/screens/barber_shop_list_screen.dart';
import 'package:salon/screens/business_signup_flow8.dart';
import 'package:salon/screens/demo_profile_screen.dart';
import 'package:salon/screens/demoscreen.dart';
import 'package:salon/screens/select_category_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  static const routeName = '/SignIn';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  // var newSignUp = signUp(
  //   name: '',
  //   email: '',
  //   password: '',
  // );
  var email;
  var password;
  var isloading = false;

  Map<String, String> newsignUp = {
    'Email': '',
    'Password': '',
  };

  Future<void> _submit() async {
    // if (_formKey.currentState!.validate()) {
    //   // Invalid!
    //   return;
    // }
    _formKey.currentState!.save();

    try {
      // Navigator.of(context)
      //     .pushReplacementNamed(SelectCategoryScreen.routeName);
      await Provider.of<ApiCalls>(
        context,
        listen: false,
      ).signInUser(email, password);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 80;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // appBar:
        //     AppBar(backgroundColor: Colors.black, title: const Text('Sign In')),
        body: isloading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 30),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: const Text('Email'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Email Address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  email = value!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: const Text('Password'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Password!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  password = value!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: SizedBox(
                                  height: 50,
                                  width: width / 2,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black)),
                                    onPressed: () async {
                                      Navigator.of(context).pushNamed(
                                          SelectCategoryScreen.routeName);
                                    },
                                    child: const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: SizedBox(
                                  height: 50,
                                  width: width / 2,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black)),
                                    onPressed: () async {
                                      // if (_formKey.currentState!.validate()) {
                                      //   // Invalid!
                                      //   return;
                                      // }
                                      _formKey.currentState!.save();
                                      setState(() {
                                        isloading = true;
                                      });

                                      try {
                                        await Provider.of<ApiCalls>(
                                          context,
                                          listen: false,
                                        )
                                            .signInUser(email, password)
                                            .then((value) {
                                          setState(() {
                                            isloading = false;
                                          });

                                          if (value['StatusCode'] == 200 &&
                                              value['UserType'] == 'Customer') {
                                            Navigator.of(context).pushNamed(
                                              BarberShopList.routeName,
                                            );
                                          } else if (value['StatusCode'] ==
                                                  200 &&
                                              value['UserType'] == 'Business' &&
                                              value['BusinessSetUp'] == true) {
                                            Navigator.of(context).pushNamed(
                                                BarberBookingListScreen
                                                    .routeName);
                                          } else if (value['StatusCode'] ==
                                                  200 &&
                                              value['UserType'] == 'Business' &&
                                              value['BusinessSetUp'] == false) {
                                            Navigator.of(context).pushNamed(
                                                BusinessSignUpFlow8.routeName);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                    'Sign In Failed'),
                                                content: const Text(
                                                    'Something Went Wrong Please SignIn Again'),
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
                                      } catch (error) {
                                        print(error);
                                      }
                                    },
                                    child: const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 8.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [

                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black)),
                                      onPressed: () async {
                                        Navigator.of(context).pushNamed(
                                            DemoProfileScreen.routeName);
                                      },
                                      child: const FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'View Profile',
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
