import 'package:flutter/material.dart';
import 'package:pittaji_medicals/providers/data.dart';
import 'package:pittaji_medicals/providers/product_list.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TotalSales extends StatefulWidget {
  TotalSales({Key? key}) : super(key: key);

  static const routeName = '/TotalSales';

  @override
  _TotalSalesState createState() => _TotalSalesState();
}

enum ReportLib {
  yesterDay,
  forTheWeek,
  forTheMonth,
}

class _TotalSalesState extends State<TotalSales> {
  var totalSales = ExcelData.totalSales;
  ReportLib _selected = ReportLib.yesterDay;

  var isloading = false;

  DateTime now = DateTime.now();
  var showDetails = false;

  Text selectReport() {
    if (_selected == ReportLib.yesterDay) {
      return const Text(
        'Yesturday',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selected == ReportLib.forTheWeek) {
      return const Text(
        'For the Week',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selected == ReportLib.forTheMonth) {
      return const Text(
        'For the Month',
        style: TextStyle(fontSize: 20),
      );
    } else {
      return const Text('');
    }
  }

  void fetch() {
    if (_selected == ReportLib.yesterDay) {
      DateTime yesterday = now.subtract(Duration(days: 1));
      print(yesterday.toString());
      DateTime today = DateTime.now();
      print(today);
      var myFormat = DateFormat('yyyy-MM-dd');
      int startDate = yesterday.millisecondsSinceEpoch;
      int endDate = today.millisecondsSinceEpoch;
      if (showDetails == false) {
        Provider.of<ExcelData>(context, listen: false)
            .getTotalSalesReportData(startDate, endDate)
            .then((value) {
          if (value['code'] == 200) {
            setState(() {
              totalSales = value['sales'];
              isloading = false;
              // MyFilteredData.data = [];
            });
          } else {
            setState(() {
              isloading = false;
              // MyFilteredData.data = [];
            });
            dialog();
          }
        });
      } else if (showDetails == true) {
        Provider.of<ExcelData>(context, listen: false)
            .fetchTotalList(startDate, endDate)
            .then((value) {
          if (value == 200) {
            setState(() {
              showDetails = false;
            });
          }
        });
      }
    } else if (_selected == ReportLib.forTheWeek) {
      int currentDay = now.weekday;
      DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay - 1));
      DateTime today = DateTime.now();

      print(firstDayOfWeek.toString());
      var myFormat = DateFormat('yyyy-MM-dd');
      int startDate = firstDayOfWeek.millisecondsSinceEpoch;
      int endDate = today.millisecondsSinceEpoch;
      if (showDetails == false) {
        Provider.of<ExcelData>(context, listen: false)
            .getTotalSalesReportData(startDate, endDate)
            .then((value) {
          if (value['code'] == 200) {
            setState(() {
              totalSales = value['sales'];
              isloading = false;
              // MyFilteredData.data = [];
            });
          } else {
            setState(() {
              isloading = false;
              // MyFilteredData.data = [];
            });
            dialog();
          }
        });
      } else if (showDetails == true) {
        Provider.of<ExcelData>(context, listen: false)
            .fetchTotalList(startDate, endDate)
            .then((value) {
          if (value == 200) {
            setState(() {
              showDetails = false;
            });
          }
        });
      }
    } else if (_selected == ReportLib.forTheMonth) {
      DateTime firstDayCurrentMonth =
          DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
      DateTime lastDayCurrentMonth = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month + 1,
      ).subtract(Duration(days: 1));

      int firstDate = firstDayCurrentMonth.millisecondsSinceEpoch;
      int lastDay = lastDayCurrentMonth.millisecondsSinceEpoch;

      print('$firstDayCurrentMonth $lastDayCurrentMonth');
      if (showDetails == false) {
        Provider.of<ExcelData>(context, listen: false)
            .getTotalSalesReportData(firstDate, lastDay)
            .then((value) {
          if (value['code'] == 200) {
            setState(() {
              totalSales = value['sales'];
              isloading = false;
              //   MyFilteredData.data = [];
            });
          } else {
            setState(() {
              isloading = false;
              // MyFilteredData.data = [];
            });
            dialog();
          }
        });
      } else if (showDetails == true) {
        Provider.of<ExcelData>(context, listen: false)
            .fetchTotalList(firstDate, lastDay)
            .then((value) {
          if (value == 200) {
            setState(() {
              showDetails = false;
            });
          }
        });
      }
    }
  }

  Future<dynamic> dialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Something Went Wrong'),
        content: const Text('Fetching TotalSales Failed'),
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

  int defaultRowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Sales'),
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: selectReport(),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      PopupMenuButton(
                          child:
                              const Icon(Icons.arrow_drop_down_circle_outlined),
                          onSelected: (value) {
                            setState(() {
                              _selected = value as ReportLib;
                              isloading = true;
                              fetch();
                            });
                          },
                          itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: Text('YesturDay'),
                                  value: ReportLib.yesterDay,
                                ),
                                const PopupMenuItem(
                                  child: Text('For The Week'),
                                  value: ReportLib.forTheWeek,
                                ),
                                const PopupMenuItem(
                                  child: Text('For The Month'),
                                  value: ReportLib.forTheMonth,
                                ),
                              ]),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Total Sales: $totalSales',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showDetails = true;
                              fetch();
                            });
                          },
                          child: const Text('Show Details'))
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PaginatedDataTable(
                    source: MyFilteredData(),

                    columns: const [
                      DataColumn(
                          label: Text('Product Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Batch Number',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('QTY',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Mrp',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Expiry Date',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Vendor Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Margin',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Months To Expiry',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    onRowsPerPageChanged: (index) {
                      setState(() {
                        defaultRowsPerPage = index!;
                      });
                    },
                    availableRowsPerPage: const <int>[
                      10,
                      20,
                      40,
                      60,
                      80,
                    ],
                    columnSpacing: 20,
                    //  horizontalMargin: 10,
                    rowsPerPage: defaultRowsPerPage,
                    showCheckboxColumn: false,
                    // addEmptyRows: false,
                    checkboxHorizontalMargin: 30,
                    // onSelectAll: (value) {},
                    showFirstLastButtons: true,
                  ),
                ),
              ],
            ),
    );
  }
}

class MyFilteredData extends DataTableSource {
  final List<ProductList> data = ExcelData.totalScreenList;

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].productName)),
      DataCell(Text(data[index].batchNumber)),
      DataCell(Text(data[index].qty)),
      DataCell(Text(data[index].mrp)),
      DataCell(Text(
        DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            data[index].expiryDate,
          ),
        ),
      )),
      DataCell(Text(data[index].vendorName)),
      DataCell(Text(data[index].margin)),
      DataCell(Text(data[index].monthsToExpiry)),
    ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
