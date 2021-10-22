import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/barber_booking_list_screen.dart';
import 'package:salon/screens/barber_shop.dart';
import 'package:salon/screens/barber_shop_list_screen.dart';
import 'package:salon/screens/bookingpage.dart';
import 'package:salon/screens/business_setup_screen.dart';
import 'package:salon/screens/business_signup_flow7.dart';
import 'package:salon/screens/customer_bookings_screen.dart';
import 'package:salon/screens/edit_customer_profile_screen.dart';
import 'package:salon/screens/edit_shop_profile_screen.dart';
import 'package:salon/screens/payment_screen.dart';
import 'package:salon/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:salon/screens/setup_customer_profile_screen.dart';
import 'package:salon/screens/shop_profil_screen.dart';
import 'screens/business_signup_flow10.dart';
import 'screens/business_signup_flow12.dart';
import 'screens/business_signup_flow13.dart';
import 'screens/business_signup_flow14.dart';
import 'screens/business_signup_flow8.dart';
import 'screens/business_signup_flow9.dart';
import 'screens/customer_profile_screen.dart';
import 'screens/select_category_screen.dart';
import 'screens/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => ApiCalls(),
          ),
        ],
        child: Consumer<ApiCalls>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            // initialRoute: '/',
            home: const Scaffold(
              body: WelcomePage(),
            ),
            //  auth.isAuth
            //     ? const BusinessOverViewScreen()
            //     : FutureBuilder(
            //         future: auth.tryAutoLogin(),
            //         builder: (ctx, authResultSnapshot) =>
            //             authResultSnapshot.connectionState ==
            //                     ConnectionState.waiting
            //                 ? SplashScreen()
            //                 : const Scaffold(
            //                     body: WelcomePage(),
            //                   ),
            //       ),
            routes: {
              RegisterScreen.routeName: (ctx) => RegisterScreen(),
              SignInScreen.routeName: (ctx) => SignInScreen(),
              SelectCategoryScreen.routeName: (ctx) =>
                  const SelectCategoryScreen(),
              BusinessSignUp.routeName: (ctx) => BusinessSignUp(),
              BarberShopList.routeName: (ctx) => BarberShopList(),
              BusinessSignUpExtended.routeName: (ctx) =>
                  const BusinessSignUpExtended(),
              BusinessSignUpFlow7.routeName: (ctx) => BusinessSignUpFlow7(),
              BusinessSignUpFlow8.routeName: (ctx) =>
                  const BusinessSignUpFlow8(),
              BusinessSignUpFlow9.routeName: (ctx) =>
                  const BusinessSignUpFlow9(),
              BusinessSignUpFlow10.routeName: (ctx) =>
                  const BusinessSignUpFlow10(),
              BusinessSignUpFlow12.routeName: (ctx) =>
                  const BusinessSignUpFlow12(),
              BusinessSignUpFlow13.routeName: (ctx) =>
                  const BusinessSignUpFlow13(),
              BusinessSignUpFlow14.routeName: (ctx) =>
                  const BusinessSignUpFlow14(),
              BarberShopDetails.routeName: (ctx) => const BarberShopDetails(),
              BookingPage.routeName: (ctx) => BookingPage(),
              CustomerBookings.routeName: (ctx) => CustomerBookings(),
              BarberBookingListScreen.routeName: (ctx) =>
                  BarberBookingListScreen(),
              CustomerProfileScreen.routeName: (ctx) => CustomerProfileScreen(),
              CustomerProfileScreenData.routeName: (ctx) =>
                  CustomerProfileScreenData(),
              PaymentScreen.routeName: (ctx) => PaymentScreen(),
              ShopProfilScreen.routeName: (ctx) => ShopProfilScreen(),
              EditCustomerProfileScreen.routeName: (ctx) =>
                  EditCustomerProfileScreen(),
              EditShopProfile.routeName: (ctx) => EditShopProfile(),
            },
          ),
        ));
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 120,
            vertical: 50,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50, bottom: 100),
                child: Text(
                  'Hairambe',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  // padding: EdgeInsets.only(bottom: 100),
                  width: 250,
                  height: 250,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/images/profile.jpg'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 100, top: 50),
                child: const Text(
                  'A cut at Your\nConvenience',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 65,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Welcome'),
                            //content: const Text('Choose Category'),
                            actions: [
                              FlatButton(
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.of(context).pushNamed(
                                      SelectCategoryScreen.routeName);
                                },
                                child: const Text('Create New Account'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.of(context)
                                      .pushNamed(SignInScreen.routeName);
                                },
                                child: const Text('Sign In'),
                              )
                            ],
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 35,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            size: 35,
                          ),
                        ],
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context)
              //         .pushNamed(BusinessSignUpFlow7.routeName);
              //   },
              //   child: const Text(
              //     'Set Up Your Business',
              //     style: TextStyle(color: Colors.black),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
