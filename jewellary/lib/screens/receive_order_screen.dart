import 'package:an_app/providers/details.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReceiveOrderScreen extends StatefulWidget {
  var itemDescription;
  var quantity;
  var orderId;

  ReceiveOrderScreen([this.orderId]);

  static var routeName = '/ReceiveOrder/:id';

  @override
  _ReceiveOrderScreenState createState() => _ReceiveOrderScreenState();
}

class _ReceiveOrderScreenState extends State<ReceiveOrderScreen> {
  @override
  List<Details> list = [];
  var initValues = {
    'itemDescription': '',
    'quantityOrdered': '',
    'costOfItem': '',
    'vendorSku': '',
    'dateCreated': '',
    'shipDate': '',
  };
  var date;

  var myDateFormat;

  var isloading = true;
  @override
  void initState() {
    Provider.of<VendorsList>(context, listen: false)
        .fetchWaitingOrderDetails(widget.orderId.toString())
        .then((value) {
      list = value;
      for (var data in value) {
        initValues = {
          'itemDescription': data.itemDescription,
          'quantityOrdered': data.quantityOrdered,
          'costOfItem': data.costOfItem,
          'vendorSku': data.vendorSKU,
          'dateCreated': data.dateCreated,
          'shipDate': data.shipDate,
        };
      }
      var milli = int.parse(initValues['shipDate']!);
      date = DateTime.fromMillisecondsSinceEpoch(milli);
      myDateFormat = DateFormat('dd/MM/yyyy').format(date);

      run();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void run() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
              child: Card(
                shadowColor: Colors.amber,
                margin: const EdgeInsets.all(15),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Order Details',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Container(
                              child: Text('Item Description:'),
                            ),
                            Container(
                              child: Text(
                                  initValues['itemDescription'].toString()),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text('Quantity: '),
                              ),
                              Container(
                                child: Text(
                                    initValues['quantityOrdered'].toString()),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                child: const Text('Cost Of Item: '),
                              ),
                              Container(
                                child:
                                    Text(initValues['costOfItem'].toString()),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                child: const Text('vendor Sku: '),
                              ),
                              Container(
                                child: Text(initValues['vendorSku'].toString()),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                child: const Text('shipdate: '),
                              ),
                              Container(
                                child: Text(myDateFormat.toString()),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                child: const Text('Order Id: '),
                              ),
                              Container(
                                child: Text(widget.orderId.toString()),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isloading = true;
                                  });

                                  await Provider.of<VendorsList>(context,
                                          listen: false)
                                      .sendOrder(widget.orderId.toString())
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
                                              'Successfully Accepted the Order'),
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
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text(
                                              'Something Went Wrong'),
                                          content: const Text(
                                              'Failed To Accept The Order'),
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
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              child: const Text('Order'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
