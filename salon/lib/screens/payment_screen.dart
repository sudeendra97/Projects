import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';

import 'barber_shop_list_screen.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);

  static const routeName = '/PaymentScreen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

enum paymentMethods {
  netBanking,
  card,
  wallet,
  upi,
}

class _PaymentScreenState extends State<PaymentScreen> {
  paymentMethods payments = paymentMethods.card;
  var token;
  var isloading = false;

  EdgeInsetsGeometry getpadding() {
    return EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 2);
  }

  @override
  void initState() {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        token = Provider.of<ApiCalls>(context, listen: false).token;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Payment Option'),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: ListTile(
                      title: const Text('Card'),
                      leading: Radio(
                        value: paymentMethods.card,
                        groupValue: payments,
                        onChanged: (value) {
                          setState(() {
                            payments = value as paymentMethods;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: ListTile(
                      title: const Text('Net Banking'),
                      leading: Radio(
                          value: paymentMethods.netBanking,
                          groupValue: payments,
                          onChanged: (value) {
                            setState(() {
                              payments = value as paymentMethods;
                            });
                          }),
                    ),
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: ListTile(
                      title: const Text('Wallet'),
                      leading: Radio(
                          value: paymentMethods.wallet,
                          groupValue: payments,
                          onChanged: (value) {
                            setState(() {
                              payments = value as paymentMethods;
                            });
                          }),
                    ),
                  ),
                  // Container(
                  //   width: 200,
                  //   alignment: Alignment.center,
                  //   child: ListTile(
                  //     title: const Text('upi'),
                  //     leading: Radio(
                  //         value: paymentMethods.upi,
                  //         groupValue: payments,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             payments = value as paymentMethods;
                  //           });
                  //         }),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          Provider.of<ApiCalls>(context, listen: false)
                              .setPaymentMethod(token)
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
                                      'Successfully uploaded Your Data'),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pushNamed(
                                            BarberShopList.routeName);
                                      },
                                      child: const Text('ok'),
                                    )
                                  ],
                                ),
                              );
                            }
                          });
                        },
                        child: const Text('Submit'),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(BarberShopList.routeName);
                        },
                        child: const Text('skip'),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
