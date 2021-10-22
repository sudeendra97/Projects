import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pittaji_medicals/providers/product_list.dart';
import 'package:pittaji_medicals/providers/received_data.dart';

class ExcelData with ChangeNotifier {
  var filedata;
  var rowName;
  var columnName;

  static int expiryMonth = 0;

  static var totalSales;

  ExcelData([
    this.filedata,
    this.rowName,
    this.columnName,
  ]);
  static List<Map<String, String>> salesReportData = [];
  static List<Map<String, String>> salesReportShowData = [];

  static List<SalesReportData> salesReportlist = [];

  List<ProductList> productList = [];

  static List<ProductList> filterScreenList = [];
  static List<ProductList> totalScreenList = [];

  Future<int> sendData(List<List<String>> data, String fileName) async {
    // final url = Uri.parse(
    //     'https://simple1-fd47e-default-rtdb.firebaseio.com/NewData.json');

    final url1 = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/newProductList');
    var body = json.encode(data);

    try {
      // final response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'application/json'},
      //   body: body,
      // );
      final response = await http.post(
        url1,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(response.statusCode);
      print(body);
      return response.statusCode;
    } catch (e) {
      print(e);
    }
    return 500;
  }

  Future<List<List<dynamic>>> fetchData() async {
    // final url = Uri.parse(
    //     'https://simple1-fd47e-default-rtdb.firebaseio.com/NewData.json');

    final url = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/getProductList');

    try {
      final response = await http.get(
        url,
      );
      // final response1 = await http.get(
      //   url1,
      // );

      // print(response1.body);
      // print(response1.statusCode);

      if (json.decode(response.body) == null) {
        return [];
      } else {
        List<List<dynamic>> list = [];

        final extratedData = json.decode(response.body) as Map<String, dynamic>;
        extratedData.forEach((prodId, prodData) {
          list.add(prodData);
        });

        return list;
      }

      //  print(list.toString());
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<SalesReportData>> fetchReportData() async {
    final url1 = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/getProductList');

    try {
      final response1 = await http.get(
        url1,
      );

      print(response1.body);
      print(response1.statusCode);

      if (json.decode(response1.body) == null) {
        return [];
      } else {
        final extratedData = json.decode(response1.body);
        List<SalesReportData> list = [];
        for (var prodData in extratedData) {
          list.add(
            SalesReportData(
              id: prodData['_id'],
              productName: prodData['Product_Name'],
              batchNumber: prodData['Batch_Number'],
            ),
          );
        }
        salesReportlist = list;
        return list;
      }

      //  print(list.toString());
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<int> sendSalesReport(List<Map<String, String>> value) async {
    var date = DateTime.now();

    Map<String, dynamic> data = {'dataVal': value, 'date': date.toString()};

    final url = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/newDailyDataEntry');

    var body = json.encode(
      data,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(response.statusCode);
      return (response.statusCode);
    } catch (e) {
      print(e);
    }
    return 500;
  }

  Future<List<ProductList>> fetchProductList(String number) async {
    final url = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/getProductsByExpiryMonth/$number');

    try {
      final response = await http.get(
        url,
      );
      final extratedData = json.decode(response.body);
      List<ProductList> productList = [];
      for (var data in extratedData) {
        productList.add(ProductList(
          productName: data['Product_Name'],
          batchNumber: data['Batch_Number'],
          qty: data['QTY'].toString(),
          mrp: data['MRP'].toString(),
          expiryDate: data['Expiry_Date'],
          vendorName: data['Vendor_Name'],
          margin: data['Margin'],
          monthsToExpiry: data['Months_To_Expiry'].toString(),
        ));
      }
      filterScreenList = productList;
      print(response.body);
      print(response.statusCode);
      return productList;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<int> fetchTotalList(
    int fromDate,
    int toDate,
  ) async {
    var data = {
      'fromDate': fromDate,
      'toDate': toDate,
    };
    // print(data.toString());
    // var request =
    //     Uri.parse("http://localhost:3000/product/getSalesReportByDate/")
    //         .resolveUri(Uri(queryParameters: {
    //   "from": fromDate.toString(),
    //   "to": toDate.toString(),
    // }));

    final url = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/Report');
    var body = json.encode(
      data,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);
      print(response.statusCode);
      final extratedData = json.decode(response.body);
      List<ProductList> productList = [];
      for (var data in extratedData) {
        productList.add(ProductList(
          productName: data['Product_Name'],
          batchNumber: data['Batch_Number'],
          qty: data['Sale_Qty'].toString(),
          mrp: data['MRP'].toString(),
          expiryDate: data['Expiry_Date'],
          vendorName: data['Vendor_Name'],
          margin: data['Margin'],
          monthsToExpiry: data['Months_To_Expiry'].toString(),
        ));
      }
      totalScreenList = productList;

      return response.statusCode;
    } catch (e) {
      print('errorData $e');
    }
    return 500;
  }

//'https://ayursundralifecovidcare.herokuapp.com/product/TotalSales'
  Future<void> getMonthBasedOnExpiry() async {
    final url = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/Report');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, int>> getTotalSalesReportData(
    int fromDate,
    int toDate,
  ) async {
    var data = {
      'fromDate': fromDate,
      'toDate': toDate,
    };
    // print(data.toString());
    // var request =
    //     Uri.parse("http://localhost:3000/product/getSalesReportByDate/")
    //         .resolveUri(Uri(queryParameters: {
    //   "from": fromDate.toString(),
    //   "to": toDate.toString(),
    // }));

    final url = Uri.parse(
        'https://ayursundralifecovidcare.herokuapp.com/product/TotalSales');
    var body = json.encode(
      data,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);
      print(response.statusCode);
      final extratedData = json.decode(response.body);
      totalSales = extratedData['Sum'];
      print(totalSales);
      // List<ProductList> productList = [];
      // for (var data in extratedData) {
      //   productList.add(ProductList(
      //     productName: data['Product_Name'],
      //     batchNumber: data['Batch_Number'],
      //     qty: data['Sale_Qty'].toString(),
      //     mrp: data['MRP'].toString(),
      //     expiryDate: data['Expiry_Date'],
      //     vendorName: data['Vendor_Name'],
      //     margin: data['Margin'],
      //     monthsToExpiry: data['Months_To_Expiry'].toString(),
      //   ));
      // }
      // totalScreenList = productList;
      totalScreenList.clear();

      return {'code': response.statusCode, 'sales': extratedData['Sum']};
    } catch (e) {
      print('errorData $e');
    }
    return {};
  }
}
