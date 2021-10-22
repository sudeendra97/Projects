import 'dart:convert';
import 'dart:developer';

import 'package:cablecollection_app/providers/customerbill.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BillList with ChangeNotifier {
  List<CustomerBill> _allBilllist = [];
  List<CustomerBill> singleBilllist = [];
  // var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
  var baseUrl = 'https://demoeazybill.herokuapp.com/';

  static var cusId;

  var _authToken;

  BillList([this._authToken]);

  List<CustomerBill> get allBillList {
    return [...?_allBilllist];
  }

  List<CustomerBill> get singleBillList {
    return [...?singleBilllist];
  }

  CustomerBill findById(String id) {
    return _allBilllist.firstWhere((element) => element.cuid == id);
  }

  Future<int> addBill(CustomerBill details, var token) async {
    final url = Uri.parse('${baseUrl}agentbill/addbill');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode(
          {
            'cuId': details.cuid,
            'PaidAmount': details.paidamount,
            'Due': details.due,
            'Advance': details.advance,
            'Days': details.days,
            'BillNo': details.billno,
            'BillDate': details.billdate,
            'BillFrom': details.billfrom,
            'BillTo': details.billto,
            'BillBy': details.billby,
            'tax': details.tax,
          },
        ),
      );
      print(response.statusCode);
      log(response.body.toString());
      return response.statusCode;
    } catch (error) {
      rethrow;
    }
    // _list.add(details);
  }
}
