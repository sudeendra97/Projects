import 'package:an_app/screens/message_screen.dart';
import 'package:an_app/widgets/pending_orders_widget.dart';
import 'package:flutter/material.dart';

class FilterDetails {
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

  FilterDetails({
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

  static List<FilterDetails> list = [];
  static List<dynamic> data = [];

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
        DataCell(Text(orderId)),
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

  factory FilterDetails.fromJson(FilterDetails json) {
    return FilterDetails(
      costOfItem: json.costOfItem,
      dateCreated: json.dateCreated,
      itemDescription: json.itemDescription,
      messages: json.messages,
      orderId: json.orderId,
      pdfFiles: json.pdfFiles,
      quantityOrdered: json.quantityOrdered,
      shipDate: json.shipDate,
      status: json.status,
      uId: json.uId,
      vendorSKU: json.vendorSKU,
      beSKU: json.beSKU,
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
