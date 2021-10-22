import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/main.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_booking_details.dart';
import 'package:intl/intl.dart';
import 'package:salon/screens/shop_profil_screen.dart';

class BarberBookingListScreen extends StatefulWidget {
  BarberBookingListScreen({Key? key}) : super(key: key);
  static const routeName = '/BarberBookingListScreen';

  @override
  _BarberBookingListScreenState createState() =>
      _BarberBookingListScreenState();
}

class _BarberBookingListScreenState extends State<BarberBookingListScreen> {
  var token;
  var isloading = true;
  List<BarberBookingDetails> bookings = [];
  void gettoken() {
    var data = Provider.of<ApiCalls>(context, listen: false).token;
    //print(data);
    token = data;
  }

  @override
  void initState() {
    gettoken();
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getBarberBookings(token)
          .then((value) {
        bookings = value;
        if (value.isNotEmpty) {
          reRun();
        }
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          var token = Provider.of<ApiCalls>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .getBarberBookings(token)
              .then((value) {
            bookings = value;
            if (value.isNotEmpty) {
              reRun();
            }
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
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text('Welcome', style: TextStyle(fontSize: 25)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                onPressed: () {
                  Navigator.of(context).pushNamed(ShopProfilScreen.routeName);
                },
                child: const Text('My Profile'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                onPressed: () {
                  Provider.of<ApiCalls>(context, listen: false)
                      .logout()
                      .then((value) {});
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      WelcomePage.routeName, (Route<dynamic> route) => false);
                },
                child: const Text('LogOut'),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Your Customer Bookings'),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? const Center(child: Text('No new orders yet!'))
          : Center(
              child: Column(
                children: [
                  for (var data in bookings)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 250,
                        height: 150,
                        child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'CustomerName: ${data.customerName}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(DateFormat('dd/MM/yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      data.date,
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text('Time: ${data.time}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child:
                                      Text('Barber Name: ${data.barberName}'),
                                ),
                              ],
                            )),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
