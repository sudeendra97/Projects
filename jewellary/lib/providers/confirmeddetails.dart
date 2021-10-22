import 'dart:typed_data';

import 'package:an_app/screens/message_screen.dart';
import 'package:an_app/screens/orderdetailsscreen.dart';
import 'package:an_app/widgets/pending_orders_widget.dart';
import 'package:flutter/material.dart';

import 'vendorslist.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class ConfirmedDetails {
  final String uId;
  final String status;
  final String itemDescription;
  final String quantityOrdered;
  final String costOfItem;
  final String shipDate;
  final String vendorSKU;
  final String beSKU;
  final String orderId;
  final String dateCreated;
  final List messages;
  final List pdfFiles;

  ConfirmedDetails({
    required this.uId,
    required this.status,
    required this.itemDescription,
    required this.quantityOrdered,
    required this.costOfItem,
    required this.shipDate,
    required this.vendorSKU,
    required this.beSKU,
    required this.orderId,
    required this.dateCreated,
    required this.messages,
    required this.pdfFiles,
  });

  DataRow getRow(
    SelectedCallBack callback,
    List<String> selectedIds,
  ) {
    return DataRow(
      cells: [
        // DataCell(Text(uId)),
        DataCell(Text(status)),
        DataCell(Builder(builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return MessageScreen(messages, orderId);
                  });
            },
            child: const Text('View/Reply'),
          );
        })),
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(dateCreated),
            ),
          ),
        )),
        DataCell(Builder(builder: (context) {
          return TextButton(
              child: Text(orderId),
              onPressed: () {
                Navigator.of(context).pushNamed(OrderDetailsScreen.routeName,
                    arguments: orderId);
              });
        })),
        DataCell(Text(vendorSKU)),
        DataCell(Text(beSKU)),
        DataCell(Text(itemDescription)),
        DataCell(Text(quantityOrdered)),
        DataCell(Text(costOfItem)),
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(shipDate),
            ),
          ),
        )),
        DataCell(
          Text(
            DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(dateCreated),
              ),
            ),
          ),
        ),
      ],
      onSelectChanged: (newState) {
        callback(orderId.toString(), newState ?? false);
      },
      selected: selectedIds.contains(orderId.toString()),
    );
  }

  factory ConfirmedDetails.fromJson(Map<String, dynamic> json) {
    return ConfirmedDetails(
      costOfItem: json['Cost_Of_Item'] as String,
      dateCreated: json['Date_Created'] as String,
      itemDescription: json['Item_Description'] as String,
      messages: json['Messages'] as List,
      orderId: json['Order_Id'] as String,
      pdfFiles: json['Pdf_Files'] as List,
      quantityOrdered: json['Quantity_Ordered'] as String,
      shipDate: json['Ship_Date'] as String,
      status: json['Status'] as String,
      uId: json['uId'] as String,
      vendorSKU: json['Vendor_SKU'] as String,
      beSKU: json['BE_SKU'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Cost_Of_Item': costOfItem,
      'Date_Created': dateCreated,
      'Item_Description': itemDescription,
      'Messages': messages,
      'Order_Id': orderId,
      'Pdf_Files': pdfFiles,
      'Quantity_Ordered': quantityOrdered,
      'Ship_Date': shipDate,
      'Status': status,
      'uId': uId,
      'Vendor_SKU': vendorSKU,
      'BE_SKU': beSKU,
    };
  }
}

Widget showMessage(BuildContext context, var message) {
  var Message;
  return ListView(children: [
    Container(
      height: 100,
      child: Text('data'),
    ),
    Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
      ),
      height: 200,
      width: 600,
      child: TextField(
        maxLines: 10,
        decoration: InputDecoration(labelText: 'Text'),
        onChanged: (value) {
          Message = value;
        },
      ),
    ),
    Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
            ),
          ),
          height: 100,
          width: 150,
          child: TextButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  Uint8List? fileBytes = result.files.first.bytes;
                  String fileName = result.files.first.name;
                  print(fileName);
                  //  print(fileBytes.toString());

                  // Upload file
                  // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
                }
                // var picked = await FilePicker.platform.pickFiles();

                // if (picked != null) {
                //   print(picked.files.first.name);
                // }
              },
              child: const Text('Choose file to upload',
                  style: TextStyle(color: Colors.black))),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
          ),
          child: TextButton(
              onPressed: () {
                Provider.of<VendorsList>(context, listen: false)
                    .sendMessage(Message, 45454.toString());
              },
              child:
                  const Text('Reply', style: TextStyle(color: Colors.black))),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
          ),
          child: TextButton(
              onPressed: () {},
              child: const Text('Mark As Read',
                  style: TextStyle(color: Colors.black))),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
          ),
          child: TextButton(
              onPressed: () {},
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black))),
        ),
      ],
    ),
  ]);
}

// class pushPage extends StatelessWidget {
//   const pushPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  ,
//     );
//   }
// }