import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:cablecollection_app/providers/customer.dart';
import 'package:cablecollection_app/providers/report.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';

class ReportList with ChangeNotifier {
  List<Report> _reportList = [];
  List<Report> _singlecustomerList = [];
  List<Report> _todaysReportList = [];
  List<Report> _monthlyReportList = [];
  List<Report> yearlyReportList = [];
  List<Customer> _list = [];
  int colletionTotal = 0;
  static var cusId;
  // var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
  var baseUrl = 'https://demoeazybill.herokuapp.com/';

  static var areaSelected = false;
  static var selectedArea = '';

  List<Report> get reportList {
    return [...?_reportList];
  }

  List<Report> get singleCustomerList {
    return [...?_singlecustomerList];
  }

  List<Report> get todaysReportList {
    return [...?_todaysReportList];
  }

  List<Report> get monthlyReportList {
    return [...?_monthlyReportList];
  }

  List<Report> get yearlyReportListData {
    return [...?yearlyReportList];
  }

  List<Customer> get list {
    return [...?_list];
  }

  int get collectionTotalData {
    return colletionTotal;
  }

  var billFromDate;
  var billToDate;

  Future<int> getReport(
      var billFrom, var billTo, var token, List selectedArea) async {
    colletionTotal = 0;
    billFromDate = billFrom;
    billToDate = billTo;
    List Area = [];
    var area;
    if (selectedArea.isEmpty) {
      area = 'All';
    } else {
      for (int i = 0; i < selectedArea.length; i++) {
        Area.add(selectedArea[i]);
      }
    }
    // print(area);
    // print(Area);
    final url = Uri.parse('${baseUrl}agentbill/allbill');
    // var body = json.encode(data);
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({
          'billFrom': billFrom,
          'billTo': billTo,
          'Area': selectedArea.isEmpty ? area : Area,
        }),
      );
      final List<Report> loadedCustomer = [];
      List billdata = [];
      List customerData = [];
      List report = [];
      // print(response.statusCode);
      // log(response.body.toString());
      var responseData = json.decode(response.body);
      if (responseData.isEmpty) {
        return response.statusCode;
      }
      for (var data in responseData['bill']) {
        billdata.add(data);
      }

      for (var data in responseData['customer']) {
        customerData.add(data);
      }
      // print(billdata.length);
      // print(customerData.length);

      // log(responseData.toString());

      // print(billdata);

      for (int i = 0; i < billdata.length; i++) {
        for (int j = 0; j < customerData.length; j++) {
          if (billdata[i]['cuId'] == customerData[j]['cuId']) {
            report.add({
              'agentName': billdata[i]['BillBy'],
              'name': customerData[j]['Name'],
              'scnNumber': customerData[j]['SmartCardNumber'],
              'amount': billdata[i]['PaidAmount'],
              'billDate': billdata[i]['BillDate'],
              'fromDate': billdata[i]['BillFrom'],
              'toDate': billdata[i]['BillTo'],
              'billNo': billdata[i]['BillNo'],
            });
          }
        }
      }
      for (var data in report) {
        colletionTotal = colletionTotal + data['amount'];
        loadedCustomer.add(Report(
          agentName: data['agentName'],
          amount: data['amount'].toString(),
          billDate: data['billDate'],
          fromDate: data['fromDate'],
          name: data['name'],
          scnNumber: data['scnNumber'].toString(),
          toDate: data['toDate'],
          billNo: data['billNo'],
        ));
      }

      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('BillNo');
      range = sheet.getRangeByName('B1');
      range.setText('BillDate');
      range = sheet.getRangeByName('C1');
      range.setText('Amount');
      range = sheet.getRangeByName('D1');
      range.setText('Name');
      range = sheet.getRangeByName('E1');
      range.setText('FromDate');
      range = sheet.getRangeByName('F1');
      range.setText('ToDate');
      range = sheet.getRangeByName('G1');
      range.setText('Scn Number');
      range = sheet.getRangeByName('H1');
      range.setText('Agent Name');

      List reportData = [];
      var myFormat = DateFormat('d-MM-yyyy');

      for (var data in report) {
        reportData.add([
          data['billNo'],
          myFormat.format(DateTime.parse(data['billDate'])),
          data['amount'],
          data['name'],
          myFormat.format(DateTime.parse(
            data['fromDate'],
          )),
          myFormat.format(DateTime.parse(data['toDate'])),
          data['scnNumber'],
          data['agentName'],
        ]);
      }

      for (int i = 0; i < reportData.length; i++) {
        sheet.importList(reportData[i], i + 2, 1, false);
      }
      final List<int> bytes = workbook.saveAsStream();
      // File('InsertRowandColumn.xlsx').writeAsBytes(bytes);
      final file = await _localFile;
      file.writeAsBytes(bytes);

      workbook.dispose();

      yearlyReportList = loadedCustomer;

      // log(response.body);
      log(report.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectories();
    // For your reference print the AppDoc directory

    return directory.first.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${billFromDate}to$billToDate.xlsx');
  }

  Future<String> getCustomerList(var number, var token) async {
    final Url = Uri.parse('${baseUrl}agentbill/allcustomer/inUse');
    var cuid;

    try {
      final responseData = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      if (json.decode(responseData.body) == null) {
        return '';
      } else {
        final extratedData = json.decode(responseData.body);
        for (var data in extratedData) {
          if (data['Mobile'] == int.parse(number)) {
            cuid = data['cuId'];
            break;
          }
        }

        return cuid;
      }
    } catch (e) {}
    return '';
  }

  Future<int> getSingleCustomerReport(
      var billFrom, var billTo, var mobileNumber, var token) async {
    final url = Uri.parse('${baseUrl}agentbill/allbill');
    var myFormat = DateFormat('d-MM-yyyy');
    var statusCode = 500;
    billFromDate = billFrom;
    billToDate = billTo;
    colletionTotal = 0;

    await getCustomerList(mobileNumber, token).then((value) async {
      if (value != '') {
        try {
          var response = await http.post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": token,
            },
            body: json.encode({
              'billFrom': billFrom,
              'billTo': billTo,
              'customer': value,
            }),
          );
          final List<Report> loadedCustomer = [];
          List billdata = [];
          List customerData = [];
          List report = [];
          var responseData = json.decode(response.body);
          // print(response.statusCode);
          // print(responseData);
          if (responseData.isNotEmpty) {
            for (var data in responseData['bill']) {
              billdata.add(data);
            }
            for (var data in responseData['customer']) {
              customerData.add(data);
            }
            for (int i = 0; i < billdata.length; i++) {
              for (int j = 0; j < customerData.length; j++) {
                if (billdata[i]['cuId'] == customerData[j]['cuId']) {
                  report.add({
                    'billNo': billdata[i]['BillNo'],
                    'agentName': billdata[i]['BillBy'],
                    'name': customerData[j]['Name'],
                    'scnNumber': customerData[j]['SmartCardNumber'],
                    'amount': billdata[i]['PaidAmount'],
                    'billDate': billdata[i]['BillDate'].toString(),
                    'fromDate': billdata[i]['BillFrom'].toString(),
                    'toDate': billdata[i]['BillTo'].toString(),
                  });
                }
              }
            }
            for (var data in report) {
              colletionTotal = colletionTotal + data['amount'];
              loadedCustomer.add(Report(
                agentName: data['agentName'],
                amount: data['amount'].toString(),
                billDate: data['billDate'],
                fromDate: data['fromDate'],
                name: data['name'],
                scnNumber: data['scnNumber'].toString(),
                toDate: data['toDate'],
                billNo: data['billNo'],
              ));
            }

            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];
            Range range = sheet.getRangeByName('A1');
            range.setText('BillNo');
            range = sheet.getRangeByName('B1');
            range.setText('AgentName');
            range = sheet.getRangeByName('C1');
            range.setText('Name');
            range = sheet.getRangeByName('D1');
            range.setText('Scn Number');
            range = sheet.getRangeByName('E1');
            range.setText('Amount');
            range = sheet.getRangeByName('F1');
            range.setText('BillDate');
            range = sheet.getRangeByName('G1');
            range.setText('FromDate');
            range = sheet.getRangeByName('H1');
            range.setText('ToDate');

            List reportData = [];
            var myFormat = DateFormat('d-MM-yyyy');

            for (var data in report) {
              reportData.add([
                data['billNo'],
                data['agentName'],
                data['name'],
                data['scnNumber'],
                data['amount'],
                myFormat.format(DateTime.parse(data['billDate'])),
                myFormat.format(DateTime.parse(data['fromDate'])),
                myFormat.format(DateTime.parse(data['toDate'])),
              ]);
            }

            for (int i = 0; i < reportData.length; i++) {
              sheet.importList(reportData[i], i + 2, 1, false);
            }
            final List<int> bytes = workbook.saveAsStream();
            // File('InsertRowandColumn.xlsx').writeAsBytes(bytes);
            final file = await _localFile;
            file.writeAsBytes(bytes);

            workbook.dispose();

            yearlyReportList = loadedCustomer;

            print(response.statusCode);

            // log(response.body);
            log(report.toString());
            notifyListeners();
            statusCode = response.statusCode;
          } else {
            yearlyReportList = [];
            statusCode = response.statusCode;
          }
        } catch (e) {
          rethrow;
        }
      }
    });
    return statusCode;
    // var body = json.encode(data);
  }

  Future<Map<String, dynamic>> getAllReport(var todayDate, var monthStartDate,
      var monthEndDate, var yearStartDate, var yearEndDate, var token) async {
    final url = Uri.parse('${baseUrl}agentbill/getTotalCollections');

    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode(
          {
            'TodayDate': todayDate,
            'MonthStartDate': monthStartDate,
            'MonthEndDate': monthEndDate,
            'YearStartDate': yearStartDate,
            'YearEndDate': yearEndDate,
          },
        ),
      );
      print(response.statusCode);
      print(response.body);

      var responseData = json.decode(response.body);
      return {'StatusCode': response.statusCode, 'ResponseBody': responseData};
    } catch (e) {
      rethrow;
    }
  }
}
