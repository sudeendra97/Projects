import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pittaji_medicals/providers/data.dart';
import 'package:pittaji_medicals/providers/product_list.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({Key? key}) : super(key: key);

  static const routeName = '/FilterScreen';

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

enum ReportLib {
  lessThanOneMonth,
  lessThanTwoMonts,
  lessThanThreeMonts,
  lessThanFourMonts,
}

class _FilterScreenState extends State<FilterScreen> {
  List<ProductList> productList = [];

  var number;
  int defaultRowsPerPage = 10;

  var isloading = false;

  @override
  // void initState() {
  //   number = ExcelData.expiryMonth;
  //   Provider.of<ExcelData>(context, listen: false)
  //       .fetchProductList(number.toString())
  //       .then((value) {
  //     if (value.isEmpty) {
  //       NewDialog();
  //     }
  //     productList = value;
  //     reRun();
  //   });

  //   super.initState();
  // }

  Future<dynamic> NewDialog() {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('No Records Found'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('ok'),
                )
              ],
            ));
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Based On Expiry Date'),
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150,
                            height: 100,
                            child: TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Enter the Month'),
                              onChanged: (value) {
                                number = value;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<ExcelData>(context, listen: false)
                                  .fetchProductList(number)
                                  .then((value) {
                                if (value.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            title: Text('No Records Found'),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text('ok'),
                                              )
                                            ],
                                          ));
                                }
                                productList = value;
                                setState(() {});
                              });
                            },
                            child: const Text('Submit'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PaginatedDataTable(
                    source: MyFilteredScreenData(),

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

class MyFilteredScreenData extends DataTableSource {
  final List<ProductList> data = ExcelData.filterScreenList;

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
