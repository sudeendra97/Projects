import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/customer_booking_details.dart';
import 'package:intl/intl.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CustomerBookings extends StatefulWidget {
  CustomerBookings({Key? key}) : super(key: key);

  static const routeName = '/CustomerBookings';

  @override
  _CustomerBookingsState createState() => _CustomerBookingsState();
}

class _CustomerBookingsState extends State<CustomerBookings> {
  var isloading = true;
  var token;

  void gettoken() {
    var data = Provider.of<ApiCalls>(context, listen: false).token;
    print(data);
    token = data;
  }

  void fetchToken() {
    Provider.of<ApiCalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        token = Provider.of<ApiCalls>(context, listen: false).token;
      }
    });
  }

  List<CustomerBooking> bookings = [];
  List<dynamic> imageList = [];

  void pickimages() async {
    List? bytesFromPicker =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      // bytesFromPicker.forEach((bytes) => debugPrint(bytes.toString()));
      setState(() {
        imageList = bytesFromPicker;
      });
    }
  }

  @override
  void initState() {
    gettoken();
    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getCustomerBookings(token)
          .then((value) {
        if (value.isNotEmpty) {
          bookings = value;
          reRun();
        } else {
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
              .getCustomerBookings(token)
              .then((value) {
            if (value.isNotEmpty) {
              bookings = value;
              reRun();
            } else {
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

  int _count = 0;

  // Pass this method to the child page.
  void _update(int count) {
    if (count == 100) {
      setState(() {
        isloading = true;
      });
    } else {
      reRun();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text('You Currently Have No Bookings'))
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var data in bookings)
                          CustomerBookingData(
                            shopName: data.shopName,
                            barberName: data.barberName,
                            selectedDate: data.selectedDate,
                            time: data.time,
                            id: data.id,
                            token: token,
                            update: _update,
                            parentContext: context,
                          )
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: SizedBox(
                        //     key: UniqueKey(),
                        //     width: 600,
                        //     height: imageList.isEmpty ? 200 : 400,
                        //     child: Card(
                        //       elevation: 5,
                        //       child: Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child:
                        //                 Text('Shop Name: ${data.shopName}'),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text(
                        //                 'Barber Name: ${data.barberName}'),
                        //           ),
                        //           Padding(
                        //             padding:
                        //                 const EdgeInsets.only(bottom: 8.0),
                        //             child: Text(
                        //               DateFormat('dd/MM/yyyy').format(
                        //                 DateTime.fromMillisecondsSinceEpoch(
                        //                   int.parse(data.selectedDate),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding:
                        //                 const EdgeInsets.only(bottom: 8.0),
                        //             child: Text('Time: ${data.time}'),
                        //           ),
                        //           ElevatedButton(
                        //               key: UniqueKey(),
                        //               style: ButtonStyle(
                        //                 backgroundColor:
                        //                     MaterialStateProperty.all(
                        //                         Colors.black),
                        //               ),
                        //               onPressed: () {
                        //                 pickimages();
                        //               },
                        //               child: const Text('Add Cuts')),
                        //           const SizedBox(
                        //             height: 15,
                        //           ),
                        //           imageList.isEmpty
                        //               ? const SizedBox()
                        //               : Container(
                        //                   width: 600,
                        //                   height: 200,
                        //                   child: ListView.builder(
                        //                     // shrinkWrap: true,
                        //                     scrollDirection: Axis.horizontal,
                        //                     itemCount: imageList.length,
                        //                     itemBuilder:
                        //                         (BuildContext context,
                        //                             int index) {
                        //                       return Padding(
                        //                         padding:
                        //                             const EdgeInsets.all(8.0),
                        //                         child: Container(
                        //                             width: 200,
                        //                             height: 150,
                        //                             child: FittedBox(
                        //                               fit: BoxFit.fill,
                        //                               child: Image.memory(
                        //                                 Uint8List.fromList(
                        //                                     imageList[index]
                        //                                         .cast<int>()
                        //                                         .toList()),
                        //                               ),
                        //                             )),
                        //                       );
                        //                     },
                        //                   ),
                        //                 ),
                        //           imageList.isEmpty
                        //               ? const SizedBox()
                        //               : ElevatedButton(
                        //                   style: ButtonStyle(
                        //                     backgroundColor:
                        //                         MaterialStateProperty.all(
                        //                             Colors.black),
                        //                   ),
                        //                   onPressed: () async {
                        //                     List images = [];
                        //                     for (int i = 0;
                        //                         i < imageList.length;
                        //                         i++) {
                        //                       if (i == 4) {
                        //                         break;
                        //                       }
                        //                       images.add(imageList[i]);
                        //                     }
                        //                     print(images.length);
                        //                     setState(() {
                        //                       isloading = true;
                        //                     });
                        //                     Provider.of<ApiCalls>(context,
                        //                             listen: false)
                        //                         .tryAutoLogin()
                        //                         .then((value) {
                        //                       if (value == true) {
                        //                         token = Provider.of<ApiCalls>(
                        //                                 context,
                        //                                 listen: false)
                        //                             .token;
                        //                         Provider.of<ApiCalls>(context,
                        //                                 listen: false)
                        //                             .uploadCuts(images, token,
                        //                                 data.id)
                        //                             .then((value) {
                        //                           setState(() {
                        //                             isloading = false;
                        //                           });
                        //                           if (value == 200 ||
                        //                               value == 201) {
                        //                             showDialog(
                        //                               context: context,
                        //                               builder: (ctx) =>
                        //                                   AlertDialog(
                        //                                 title: const Text(
                        //                                     'Success'),
                        //                                 content: const Text(
                        //                                     'Successfully uploaded Your photos'),
                        //                                 actions: [
                        //                                   FlatButton(
                        //                                     onPressed: () {
                        //                                       Navigator.of(
                        //                                               ctx)
                        //                                           .pop();
                        //                                     },
                        //                                     child: const Text(
                        //                                         'ok'),
                        //                                   )
                        //                                 ],
                        //                               ),
                        //                             );
                        //                           }
                        //                         });
                        //                       }
                        //                     });
                        //                   },
                        //                   child: const Text('Upload'),
                        //                 ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class CustomerBookingData extends StatefulWidget {
  CustomerBookingData({
    Key? key,
    required this.shopName,
    required this.barberName,
    required this.selectedDate,
    required this.time,
    required this.id,
    required this.token,
    required this.update,
    required this.parentContext,
  }) : super(key: key);

  final String shopName;
  final String barberName;
  final String selectedDate;
  final String time;
  var id;
  var token;
  final ValueChanged<int> update;
  final BuildContext parentContext;

  @override
  _CustomerBookingDataState createState() => _CustomerBookingDataState();
}

class _CustomerBookingDataState extends State<CustomerBookingData> {
  List imageList = [];
  void pickimages() async {
    List? bytesFromPicker =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      // bytesFromPicker.forEach((bytes) => debugPrint(bytes.toString()));
      setState(() {
        imageList = bytesFromPicker;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        key: UniqueKey(),
        width: 600,
        height: imageList.isEmpty ? 200 : 400,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Shop Name: ${widget.shopName}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Barber Name: ${widget.barberName}'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.selectedDate),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Time: ${widget.time}'),
              ),
              ElevatedButton(
                  key: UniqueKey(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {
                    pickimages();
                  },
                  child: const Text('Add Cuts')),
              const SizedBox(
                height: 15,
              ),
              imageList.isEmpty
                  ? const SizedBox()
                  : Container(
                      width: 600,
                      height: 200,
                      child: ListView.builder(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: imageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: 200,
                                height: 150,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.memory(
                                    Uint8List.fromList(
                                        imageList[index].cast<int>().toList()),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
              imageList.isEmpty
                  ? const SizedBox()
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        List images = [];
                        for (int i = 0; i < imageList.length; i++) {
                          if (i == 4) {
                            break;
                          }
                          images.add(imageList[i]);
                        }
                        print(images.length);
                        // setState(() {
                        //   isloading = true;
                        // });
                        widget.update(100);
                        Provider.of<ApiCalls>(context, listen: false)
                            .tryAutoLogin()
                            .then((value) {
                          if (value == true) {
                            var token =
                                Provider.of<ApiCalls>(context, listen: false)
                                    .token;
                            Provider.of<ApiCalls>(context, listen: false)
                                .uploadCuts(images, token, widget.id)
                                .then((value) {
                              widget.update(200);
                              // setState(() {
                              //   isloading = false;
                              // });
                              if (value == 200 || value == 201) {
                                showDialog(
                                  context: widget.parentContext,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'Successfully uploaded Your photos'),
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
                        });
                      },
                      child: const Text('Upload'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
