import 'package:an_app/providers/details.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';

import 'package:provider/provider.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';
// import 'package:flutter_file_manager/flutter_file_manager.dart';
// import 'package:path_provider_ex/path_provider_ex.dart';

//import 'package:path/path.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({Key? key}) : super(key: key);

  static var routeName = '/OrderDetailsScreen';

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  static List<Details> list = [];

  var isloading = true;

  static var duplicateOrderId;
  var id;

  @override
  void didChangeDependencies() {
    final orderId = ModalRoute.of(
      context,
    )!
        .settings
        .arguments;
    if (orderId != null) {
      duplicateOrderId = orderId;
      Provider.of<VendorsList>(context, listen: false)
          .fetchOrderDetails(orderId.toString())
          .then((value) {
        list = value;
        for (var data in list) {
          id = data.orderId.toString();
        }
        run();
      });
    }
    super.didChangeDependencies();
  }

  void run() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              //shrinkWrap: true,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      id,
                      style: const TextStyle(fontSize: 25),
                    )),
                const Divider(),
                const SizedBox(
                  height: 20,
                  width: 20,
                ),
                // Container(
                //     height: 30,
                //     width: 60,
                //     alignment: Alignment.centerLeft,
                //     child: ElevatedButton(
                //         onPressed: () {},
                //         child: const Text('Request To Push'))),

                Container(
                  child: const Text('Items:',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: DataTable(
                          headingRowHeight: 70,
                          headingTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                          ),
                          dividerThickness: 5,
                          columnSpacing: 5,
                          showBottomBorder: true,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: SizedBox(child: Text('BE SKU')),
                            ),
                            DataColumn(
                              label: Text('Vendor SKU'),
                            ),
                            DataColumn(
                              label: Text('Description'),
                            ),
                            DataColumn(
                              label: Text('Quantity Open'),
                            ),
                            DataColumn(
                              label: Text('Total\nQuantityAccepted'),
                            ),
                            DataColumn(
                              label: Text('Quantity\nOrdered'),
                            ),
                            DataColumn(
                              label: Text('Unit'),
                            ),
                            DataColumn(
                              label: Text('Original\nShipDate'),
                            ),
                            DataColumn(
                              label: Text('Ship Date'),
                            ),
                            DataColumn(
                              label: Text('Item Cost'),
                            ),
                            DataColumn(
                              label: Text('Insurance\nValue Per Unit'),
                            ),
                            DataColumn(
                              label: Text('Memo'),
                            ),
                          ],
                          rows: <DataRow>[
                            for (var orderdata in list)
                              DataRow(cells: <DataCell>[
                                DataCell(Text(orderdata.beSKU)),
                                DataCell(Text(orderdata.vendorSKU)),
                                DataCell(Text(orderdata.itemDescription)),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text(orderdata.quantityOrdered)),
                                DataCell(Text('')),
                                DataCell(Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(orderdata.dateCreated),
                                    ),
                                  ),
                                )),
                                DataCell(Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(orderdata.shipDate),
                                    ),
                                  ),
                                )),
                                DataCell(Text(orderdata.costOfItem)),
                                DataCell(Text('')),
                                DataCell(Text('')),
                              ])
                          ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    child: const Text('Shipping Log:',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold))),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: DataTable(
                          headingRowHeight: 80,
                          headingTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                          ),
                          dividerThickness: 5,
                          columnSpacing: 2,
                          showBottomBorder: true,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Shipment'),
                            ),
                            DataColumn(
                              label: Text('Date\nShipped'),
                            ),
                            DataColumn(
                              label: Text('status'),
                            ),
                            DataColumn(
                              label: Text('Be SKU'),
                            ),
                            DataColumn(
                              label: Text('invoice'),
                            ),
                            DataColumn(
                              label: Text('shipment\n tracking'),
                            ),
                            DataColumn(
                              label: Text('Qty\nShipped'),
                            ),
                            DataColumn(
                              label: Text('Qty\nsentBack'),
                            ),
                            DataColumn(
                              label: Text('Qty\nDisputed'),
                            ),
                            DataColumn(
                              label: Text('Quantity\nAccepted'),
                            ),
                            DataColumn(
                              label: Text('Date\nProcessed'),
                            ),
                            DataColumn(
                              label: Text('BE Notes'),
                            ),
                            DataColumn(
                              label: Text('Send\nBackTracking'),
                            ),
                          ],
                          rows: <DataRow>[]),
                    ),
                  ),
                ),
                Container(
                    child: const Text('Receiving:',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: DataTable(
                          headingTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                          ),
                          dividerThickness: 5,
                          columnSpacing: 5,
                          showBottomBorder: true,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Tracking'),
                            ),
                            DataColumn(
                              label: Text('Item'),
                            ),
                            DataColumn(
                              label: Text('Description'),
                            ),
                            DataColumn(
                              label: Text('Quantity'),
                            ),
                            DataColumn(
                              label: Text('Date Received'),
                            ),
                          ],
                          rows: <DataRow>[]),
                    ),
                  ),
                ),
                const Divider(),
                MessagesAndFiles()
              ],
            ),
    );
  }
}

class MessagesAndFiles extends StatefulWidget {
  const MessagesAndFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesAndFiles> createState() => _MessagesAndFilesState();
}

class _MessagesAndFilesState extends State<MessagesAndFiles> {
  List messages = [];
  @override
  // void initState() {
  //   super.initState();
  //   _OrderDetailsScreenState.list.map((e) {
  //     messages.add(e.messages);
  //   }).toList();
  //   for (var data in _OrderDetailsScreenState.list) {
  //     pdfFiles = data.pdfFiles;
  //   }
  // }

  var isloading = true;
  @override
  void didChangeDependencies() {
    Provider.of<VendorsList>(context, listen: false)
        .fetchOrderDetails(_OrderDetailsScreenState.duplicateOrderId.toString())
        .then((list) {
      for (var data in list) {
        messages = data.messages;
      }

      for (var data in list) {
        pdfFiles = data.pdfFiles;
      }
      reRun();
    });
    super.didChangeDependencies();
  }

  void fetchMessageAndPdf() {
    Provider.of<VendorsList>(context, listen: false)
        .fetchOrderDetails(_OrderDetailsScreenState.duplicateOrderId.toString())
        .then((list) {
      for (var data in list) {
        messages = data.messages;
      }

      for (var data in list) {
        pdfFiles = data.pdfFiles;
      }
      reRun();
    });
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  var files;

  String Message = '';
  List pdfFiles = [];

  String getOrderId() {
    var orderId;
    for (var data in _OrderDetailsScreenState.list) orderId = data.orderId;

    return orderId;
  }

  void openDownloadLink(String href, String filename) {
    html.document.createElement('a') as html.AnchorElement
      ..href = href
      ..download = filename
      ..dispatchEvent(html.Event.eventType('MouseEvent', 'click'));
  }

  void downloadFile(String url) {
    html.AnchorElement anchorElement = new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }

  Uri getHref() => Uri.parse(html.window.location.href);

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? Container(
            height: 600,
            child: const Center(child: CircularProgressIndicator()))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text('Messages:',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    Card(
                      elevation: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                        ),
                        height: 300,
                        width: 800,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              for (var data in messages) Text(data.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                      ),
                      height: 200,
                      width: 800,
                      child: TextField(
                        maxLines: 10,
                        decoration: InputDecoration(labelText: 'Text'),
                        onChanged: (value) {
                          Message = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 150,
                          child: ElevatedButton(
                            onPressed:
                                // imagePicker,
                                () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(withReadStream: true);

                              PlatformFile? objFile = null;

                              if (result != null) {
                                objFile = result.files.single;
                                var orderId = getOrderId();

                                Provider.of<VendorsList>(context, listen: false)
                                    .uploadSelectedFile(objFile, orderId)
                                    .then((value) {
                                  setState(() {
                                    isloading = true;
                                    fetchMessageAndPdf();
                                  });
                                });
                              }
                            },
                            child: const Text(
                              'Choose File to Upload',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: ElevatedButton(
                              onPressed: () {
                                var orderId = getOrderId();
                                Provider.of<VendorsList>(context, listen: false)
                                    .sendMessage(Message, orderId.toString())
                                    .then((value) {
                                  setState(() {
                                    isloading = true;
                                    fetchMessageAndPdf();
                                  });
                                });
                              },
                              child: const Text('Reply',
                                  style: TextStyle(color: Colors.black))),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const ElevatedButton(
                            autofocus: false,
                            onPressed: null,
                            child: Text('Mark As Read',
                                style: TextStyle(color: Colors.black))),
                        const SizedBox(
                          width: 10,
                        ),
                        const ElevatedButton(
                            onPressed: null,
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black))),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: const Text('Attachments:',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                          ),
                          height: 600,
                          width: 200,
                          child: ListView.builder(
                            itemCount: pdfFiles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                  onPressed: () {
                                    Provider.of<VendorsList>(context,
                                            listen: false)
                                        .downloadPdf(pdfFiles[index].toString())
                                        .then((value) {
                                      // openDownloadLink(
                                      //     value, pdfFiles[index].toString());
                                      html.window
                                          .open('https://$value', '_blank');
                                      // js.context.callMethod('open', [value]);
                                      // downlo  adFile(value);
                                    });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(pdfFiles[index].toString())));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
