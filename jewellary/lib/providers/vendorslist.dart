import 'dart:convert';

import 'package:an_app/providers/details.dart';
import 'package:an_app/providers/quotationdata.dart';
import 'package:an_app/providers/vendors.dart';
import 'package:an_app/widgets/pending_orders_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'filter_details.dart';

//import 'package:firebase_storage/firebase_storage.dart';

class VendorsList with ChangeNotifier {
  List<Vendors> _list = [];
  List<Details> _allOrderList = [];

  var uId;

  List<Vendors> get list {
    return [..._list];
  }

  List<Details> get allOrderList {
    return [..._allOrderList];
  }
  //https://bennedoseyy.herokuapp.com/orders/fetchOrder/confirmed
  //https://bennedoseyy.herokuapp.com/orders/getAllVendor
  //https://bennedoseyy.herokuapp.com/orders/newOrder
  //https://bennedoseyy.herokuapp.com/orders/addNewVendor
  //https://bennedoseyy.herokuapp.com/orders/fetchOrder/pending
  //https://bennedoseyy.herokuapp.com/orders/fetchOrder/confirmed
  //https://bennedoseyy.herokuapp.com/orders/confirmOrder

  Future<int> addVendor(Vendors data) async {
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/addNewVendor');
    var body = json.encode({
      'Vendor_Name': data.name,
      'Vendor_Email': data.email,
      'Vendor_Address': data.address,
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(body.toString());
      print(response.statusCode.toString());
      final newCustomer = Vendors(
        name: data.name,
        address: data.address,
        email: data.email,
      );
      _list.add(newCustomer);
      return response.statusCode;
    } catch (error) {
      print(error.toString());
    }

    notifyListeners();
    return 500;
  }

  Future<void> fetchAndSetVendors() async {
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/getAllVendor');
    try {
      final response = await http.get(url);

      if (json.decode(response.body) == null) {
        return;
      } else {
        final extratedData = json.decode(response.body) as List<dynamic>;
        print(extratedData.toString());

        final List<Vendors> loadedVendors = [];
        for (var prodData in extratedData) {
          loadedVendors.add(
            Vendors(
              uId: prodData['uId'],
              name: prodData['Vendor_Name'],
              email: prodData['Vendor_Email'],
              address: prodData['Vendor_Address'],
            ),
          );
        }
        print(loadedVendors.toString());
        _list = loadedVendors;
        print(_list.isEmpty.toString());
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<int> addQuotation(QuotationData data) async {
    print(data.initdate);

    final url = Uri.parse('https://bennedoseyy.herokuapp.com/orders/newOrder');
    var body = json.encode({
      'Item_Description': data.itemDescription,
      'Quantity_Ordered': data.quantity,
      'Cost_Of_Item': data.costOfItem,
      'Vendor_SKU': data.vendorSKU,
      'BE_SKU': data.beSKU,
      'uId': data.uid,
      'email': data.emails,
      'Date_Created': data.date.toString(),
      'Ship_Date': data.initdate,
      'vendors': data.vendorNames,
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(body.toString());
      print(response.statusCode.toString());

      return response.statusCode;

      // fetchAndSetCustomer();
    } catch (error) {
      print(error.toString());
    }
    notifyListeners();
    return 500;
  }

  Future<int> acceptOrder(List<sendUid> data) async {
    List<Map> list = [];
    data.forEach((element) => list.add({element.Uid: element.uid}));

    // data.forEach((element) {
    //   value1.addAll({'uid': element.uid});
    // });
    // for (var element in data) {value1.}
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/confirmOrder');

    var body = json.encode(list);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(body.toString());
      print(data.toString());
      print(response.statusCode.toString());

      return response.statusCode;

      // fetchAndSetCustomer();
    } catch (error) {
      print(error.toString());
    }

    notifyListeners();
    return 500;
  }

  // Future<void> fetchAndSetPending() async {
  //   final url = Uri.parse(
  //       'https://bennedoseyy.herokuapp.com/orders/fetchOrder/pending');
  //   try {
  //     final response = await http.get(url);
  //     if (json.decode(response.body) == null) {
  //       return;
  //     } else {
  //       final extratedData = json.decode(response.body) as List<dynamic>;
  //       print(extratedData.toString());

  //       final List<Details> loadedVendors = [];
  //       for (var prodData in extratedData) {
  //         loadedVendors.add(
  //           Details(
  //             costOfItem: prodData['Cost_Of_Item'],
  //             dateCreated: prodData['Date_Created'],
  //             itemDescription: prodData['Item_Description'],
  //             messages: prodData['Messages'],
  //             orderId: prodData['Order_Id'],
  //             pdfFiles: prodData['Pdf_Files'],
  //             quantityOrdered: prodData['Quantity_Ordered'],
  //             shipDate: prodData['Ship_Date'],
  //             status: prodData['Status'],
  //             uId: prodData['uId'],
  //             vendorSKU: prodData['Vendor_SKU'],
  //             beSKU: prodData['BE_SKU'],
  //           ),
  //         );
  //       }
  //       for (var loadedData in loadedVendors) {
  //         print(loadedData.beSKU);
  //         print(loadedData.costOfItem);
  //       }
  //       print(loadedVendors.toString());
  //       _allOrderList = loadedVendors;
  //       print(_allOrderList.isEmpty.toString());
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<int> sendOrder(String id) async {
    print(id);
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/orderStatus');

    try {
      var response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'orderId': id,
          },
        ),
      );
      print(response.statusCode);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> receiveOrderId() async {
    final url =
        Uri.parse('http://localhost:54322/#/ReceiveOrder/51966').toString();
    var uri = Uri.dataFromString(url);
    Map<String, String> params = uri.queryParameters;
    print(params);

    // try {
    //   final response = await http.get(url);
    //   if (json.decode(response.body) == null) {
    //     return;
    //   } else {
    //     final extratedData = json.decode(response.queryParameters) as String;

    //     uId = extratedData;
    //     print(extratedData.toString());
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<List<Details>> fetchOrderDetails(String oId) async {
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/viewDetail/$oId');
    try {
      final response = await http.get(url);
      print(response.body);
      print(response.statusCode);

      if (json.decode(response.body) == null) {
        return [];
      } else {
        final extratedData = json.decode(response.body) as List<dynamic>;
        final List<Details> list = [];
        for (var prodData in extratedData) {
          list.add(Details(
              uId: prodData['uId'],
              status: prodData['Status'],
              itemDescription: prodData['Item_Description'],
              quantityOrdered: prodData['Quantity_Ordered'],
              costOfItem: prodData['Cost_Of_Item'],
              shipDate: prodData['Ship_Date'],
              vendorSKU: prodData['Vendor_SKU'],
              beSKU: prodData['BE_SKU'],
              orderId: prodData['Order_Id'],
              dateCreated: prodData['Date_Created'],
              messages: prodData['Messages'],
              pdfFiles: prodData['Pdf_Files']));
        }
        // notifyListeners();
        print(list.isEmpty);
        return list;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Details>> fetchWaitingOrderDetails(String oId) async {
    final url = Uri.parse(
        'https://bennedoseyy.herokuapp.com/orders/viewWaitingOrderDetail/$oId');
    try {
      final response = await http.get(url);
      print(response.body);
      print(response.statusCode);

      if (json.decode(response.body) == null) {
        return [];
      } else {
        final extratedData = json.decode(response.body) as List<dynamic>;
        final List<Details> list = [];
        for (var prodData in extratedData) {
          list.add(Details(
              uId: prodData['uId'],
              status: prodData['Status'],
              itemDescription: prodData['Item_Description'],
              quantityOrdered: prodData['Quantity_Ordered'],
              costOfItem: prodData['Cost_Of_Item'],
              shipDate: prodData['Ship_Date'],
              vendorSKU: prodData['Vendor_SKU'],
              beSKU: prodData['BE_SKU'],
              orderId: prodData['Order_Id'],
              dateCreated: prodData['Date_Created'],
              messages: prodData['Messages'],
              pdfFiles: prodData['Pdf_Files']));
        }
        // notifyListeners();
        print(list.isEmpty);
        return list;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendMessage(String data, String orderId) async {
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/newMessage');
    var body = json.encode({
      "report": {'Message': data, "orderId": orderId}
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(body.toString());
      print(data.toString());
      print(response.statusCode.toString());
    } catch (e) {
      rethrow;
      print(e.toString());
    }
  }

  Future<void> sendFile(String file, var base64) async {
    Map map = {
      "filename": '$file',
      "base64url": '$base64',
    };

    // var request = http.MultipartRequest('POST',
    //     Uri.parse('https://bennedoseyy.herokuapp.com/orders/newMessage'));
    // request.files.add(
    //   await http.MultipartFile.fromPath('picture', file),
    // );

    // try {
    //   var res = await request.send();
    // } catch (e) {
    //   print(e);
    // }

    String body = json.encode(map);
    try {
      String url = 'https://bennedoseyy.herokuapp.com/orders/newFileUpload';
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      if (200 == response.statusCode) {
        return print('Successfully uploaded file');
      } else {
        return print(response.statusCode);
      }
    } catch (e) {
      return print(e);
    }
  }

  // static uploadFile(MediaInfo mediaInfo, String ref, String fileName) {
  //   try {
  //     String? mimeType = mime(basename(mediaInfo.fileName as String));
  //     var metaData = UploadMetadata(contentType: mimeType);
  //     StorageReference storageReference = storage().ref(ref).child(fileName);

  //     UploadTask uploadTask = storageReference.put(mediaInfo.data, metaData);
  //     var imageUri;
  //     uploadTask.future.then((snapshot) => {
  //           Future.delayed(Duration(seconds: 1)).then((value) => {
  //                 snapshot.ref.getDownloadURL().then((dynamic uri) {
  //                   imageUri = uri;
  //                   print('Download URL: ${imageUri.toString()}');
  //                 })
  //               })
  //         });
  //   } catch (e) {
  //     print('File Upload Error: $e');
  //   }
  // }
  Future<int> uploadSelectedFile(PlatformFile objFile, var orderId) async {
    Stream<List<int>>? data = objFile.readStream;
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("https://bennedoseyy.herokuapp.com/orders/newFileUpload"),
    );
    // request.fields["id"] = orderId.toString();
    //Map<String, String> headers = { "id": "$orderId.toString()"};

    request.headers['id'] = orderId.toString();

    //-----add selected file with request
    request.files.add(http.MultipartFile("File", data!, objFile.size,
        filename: objFile.name));

    try {
      var resp = await request.send();

      //------Read response
      String result = await resp.stream.bytesToString();

      //-------Your response
      print(result);

      return resp.statusCode;
    } catch (e) {
      print(e);
    }

    return 500;

    //-------Send request
  }

  Future<void> fetchList() async {
    final requestUri1 = Uri.parse(
        'https://bennedoseyy.herokuapp.com/orders/fetchOrder/confirmed');
    final response1 = await http.get(requestUri1);
    var response = jsonDecode(response1.body);
    print(response.toString());
    List<FilterDetails> list = [];
    for (var data in response) {
      list.add(FilterDetails(
          uId: data['uId'],
          status: data['Status'],
          itemDescription: data['Item_Description'],
          quantityOrdered: data['Quantity_Ordered'],
          costOfItem: data['Cost_Of_Item'],
          shipDate: data['Ship_Date'],
          vendorSKU: data['Vendor_SKU'],
          beSKU: data['BE_SKU'],
          orderId: data['Order_Id'],
          dateCreated: data['Date_Created'],
          messages: data['Messages'],
          pdfFiles: data['Pdf_Files']));
    }
    FilterDetails.data = response;
    FilterDetails.list = list;
    print(FilterDetails.list.isEmpty);
  }

  Future<String> downloadPdf(String fileName) async {
    final requestUri1 =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/getPDF/$fileName');

    final response1 = await http.get(requestUri1);
    print(response1.statusCode.toString());
    print(response1.body);
    var data = response1.body;
    return data;
  }

  Future<int> updateVendor(Vendors data) async {
    final url =
        Uri.parse('https://bennedoseyy.herokuapp.com/orders/editVendor/');
    var body = json.encode({
      'Vendor_Name': data.name,
      'Vendor_Email': data.email,
      'Vendor_Address': data.address,
      'uId': data.uId,
    });
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(body.toString());
      print(response.statusCode.toString());
      final newCustomer = Vendors(
        name: data.name,
        address: data.address,
        email: data.email,
      );
      _list.add(newCustomer);
      return response.statusCode;
    } catch (error) {
      print(error.toString());
    }

    notifyListeners();
    return 500;
  }
}
