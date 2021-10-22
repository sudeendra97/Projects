import 'package:an_app/screens/message_screen.dart';
import 'package:an_app/screens/orderdetailsscreen.dart';
import 'package:an_app/widgets/pending_orders_widget.dart';
import 'package:flutter/material.dart';

class AllDetails {
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

  AllDetails({
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

  static List<AllDetails> list = [];

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
            child: Text('View/Reply'),
          );
        })),
        DataCell(Text(dateCreated)),
        DataCell(Builder(builder: (context) {
          return TextButton(
              child: Text(orderId),
              onPressed: () {
                print(
                  orderId,
                );
                Navigator.of(context).pushNamed(OrderDetailsScreen.routeName,
                    arguments: orderId);
              });
        })),
        DataCell(Text(vendorSKU)),
        DataCell(Text(beSKU)),
        DataCell(Text(itemDescription)),
        DataCell(Text(quantityOrdered)),
        DataCell(Text(costOfItem)),
        DataCell(Text(shipDate)),
        DataCell(Text(dateCreated)),
      ],
      onSelectChanged: (newState) {
        callback(orderId.toString(), newState ?? false);
      },
      selected: selectedIds.contains(orderId.toString()),
    );
  }

  factory AllDetails.fromJson(Map<String, dynamic> json) {
    return AllDetails(
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
