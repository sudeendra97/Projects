import 'package:an_app/widgets/pending_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Details {
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

  Details({
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
        DataCell(Text(messages.toList().toString())),
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(dateCreated),
            ),
          ),
        )),
        DataCell(Text(orderId)),
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
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(dateCreated),
            ),
          ),
        )),
      ],
      onSelectChanged: (newState) {
        callback(uId.toString(), newState ?? false);
      },
      selected: selectedIds.contains(uId.toString()),
    );
  }

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
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
