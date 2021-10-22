import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/setup_customer_profile_screen.dart';
import 'package:salon/screens/sign_in_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/Register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  // var newSignUp = signUp(
  //   name: '',
  //   email: '',
  //   password: '',
  // );

  var isloading = false;

  Map<String, String> newsignUp = {
    // 'name': '',
    'email': '',
    'password': '',
    'user_Type': '',
  };

  String category = '';
  var loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loading == true) {
      category = ModalRoute.of(context)!.settings.arguments.toString();
      newsignUp['user_Type'] = category;
    }
    loading = false;
    print(category);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    print(category);

    try {
      if (category == 'Business') {
        await Provider.of<ApiCalls>(
          context,
          listen: false,
        ).signUpBusiness(newsignUp);
      } else if (category == 'Customer') {
        await Provider.of<ApiCalls>(
          context,
          listen: false,
        ).signUpCustomer(newsignUp).then((value) {
          if (value == 201) {
            Navigator.of(context).pushNamed(SignInScreen.routeName);
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('Register')),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 30),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   child: const Text('Name'),
                        // ),
                        // Container(
                        //   height: 50,
                        //   width: 250,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(25),
                        //     border: Border.all(width: 0.5),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 12.0),
                        //     child: TextFormField(
                        //       decoration:
                        //           const InputDecoration(border: InputBorder.none),
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return 'Name Cannot be empty';
                        //         }
                        //         return null;
                        //       },
                        //       onSaved: (value) {
                        //         newsignUp['name'] = value!;
                        //       },
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text('Email'),
                        ),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newsignUp['email'] = value!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text('Password'),
                        ),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextFormField(
                              obscureText: true,
                              // onFieldSubmitted: ,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password Cannot Be Empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newsignUp['password'] = value!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text('Confirm Password'),
                        ),
                        Container(
                          height: 50,
                          width: 250,
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
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: SizedBox(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      // Invalid!
                                      return;
                                    }
                                    _formKey.currentState!.save();

                                    print(category);
                                    try {
                                      if (category == 'Business') {
                                        setState(() {
                                          isloading = true;
                                        });
                                        await Provider.of<ApiCalls>(
                                          context,
                                          listen: false,
                                        )
                                            .signUpBusiness(newsignUp)
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
                                                    'Successfully Registered'),
                                                actions: [
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              SignInScreen
                                                                  .routeName);
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
                                                title: const Text(
                                                    'Registration Failed'),
                                                content: const Text(
                                                    'Something Went Wrong'),
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
                                      } else if (category == 'Customer') {
                                        setState(() {
                                          isloading = true;
                                        });
                                        await Provider.of<ApiCalls>(
                                          context,
                                          listen: false,
                                        )
                                            .signUpCustomer(newsignUp)
                                            .then((value) {
                                          setState(() {
                                            isloading = false;
                                          });
                                          if (value['status'] == 201) {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text('Success'),
                                                content: const Text(
                                                    'Successfully Registered'),
                                                actions: [
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              CustomerProfileScreen
                                                                  .routeName,
                                                              arguments: value[
                                                                  'token']);
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
                                                title: const Text(
                                                    'Registration Failed'),
                                                content: const Text(
                                                    'Something Went Wrong'),
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
                                      }
                                      // Navigator.of(context)
                                      //     .pushNamed(SignInScreen.routeName);
                                    } catch (error) {
                                      print(error);
                                    }
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(width: 10),
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(25),
                            //   child: SizedBox(
                            //     height: 50,
                            //     width: 150,
                            //     child: ElevatedButton(
                            //       style: ButtonStyle(
                            //           backgroundColor:
                            //               MaterialStateProperty.all(Colors.black)),
                            //       onPressed: () {
                            //         Navigator.of(context)
                            //             .pushNamed(SignInScreen.routeName);
                            //       },
                            //       child: const Text(
                            //         'Sign In',
                            //         style: TextStyle(fontSize: 20),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // ElevatedButton(
                            //   onPressed: () {},
                            //   child: const Text('SetUp a Busines'),
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
