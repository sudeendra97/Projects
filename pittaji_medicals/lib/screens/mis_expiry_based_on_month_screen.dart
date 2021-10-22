import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pittaji_medicals/providers/data.dart';
import 'package:pittaji_medicals/screens/filterscreen.dart';

class ExpiryBasedOnMonth extends StatefulWidget {
  ExpiryBasedOnMonth({Key? key}) : super(key: key);

  static const routeName = '/ExpiryBasedOnMonth';

  @override
  _ExpiryBasedOnMonthState createState() => _ExpiryBasedOnMonthState();
}

class _ExpiryBasedOnMonthState extends State<ExpiryBasedOnMonth> {
  var oneMonthValue = 0;
  var twoMonthValue = 0;
  var threeMonthValue = 0;
  var fourMonthValue = 6;

  var isloading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Sales'),
      ),
      body: Center(
        child: Card(
          elevation: 10,
          shadowColor: Colors.blue,
          child: Container(
            width: 800,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: DataTable(
                headingTextStyle:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                dataTextStyle: const TextStyle(fontSize: 25),
                dataRowHeight: 80,
                // columnSpacing: 50,
                dividerThickness: 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                columns: const <DataColumn>[
                  DataColumn(label: Text('Total Sales On')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('View Details')),
                ],
                rows: <DataRow>[
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('Yesturday')),
                    DataCell(Text(oneMonthValue.toString())),
                    DataCell(TextButton(
                        onPressed: () {
                          ExcelData.expiryMonth = oneMonthValue;
                          Navigator.of(context)
                              .pushNamed(FilterScreen.routeName);
                        },
                        child: const Text(
                          'Details',
                          style: TextStyle(fontSize: 25),
                        )))
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('For The Week')),
                    DataCell(Text(twoMonthValue.toString())),
                    DataCell(TextButton(
                        onPressed: () {
                          ExcelData.expiryMonth = twoMonthValue;
                          Navigator.of(context)
                              .pushNamed(FilterScreen.routeName);
                        },
                        child: const Text(
                          'Details',
                          style: TextStyle(fontSize: 25),
                        )))
                  ]),
                  DataRow(cells: <DataCell>[
                    const DataCell(Text('For The Month')),
                    DataCell(Text(threeMonthValue.toString())),
                    DataCell(TextButton(
                        onPressed: () {
                          ExcelData.expiryMonth = threeMonthValue;
                          Navigator.of(context)
                              .pushNamed(FilterScreen.routeName);
                        },
                        child: const Text(
                          'Details',
                          style: TextStyle(fontSize: 25),
                        )))
                  ]),
                  // DataRow(cells: <DataCell>[
                  //   const DataCell(Text('Less Than 4 Month')),
                  //   DataCell(Text(fourMonthValue.toString())),
                  //   DataCell(TextButton(
                  //       onPressed: () {
                  //         ExcelData.expiryMonth = fourMonthValue;
                  //         Navigator.of(context)
                  //             .pushNamed(FilterScreen.routeName);
                  //       },
                  //       child: const Text(
                  //         'Details',
                  //         style: TextStyle(fontSize: 25),
                  //       )))
                  // ]),
                ]),
          ),
        ),
      ),
    );
  }
}
