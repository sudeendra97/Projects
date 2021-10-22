import 'package:flutter/material.dart';
import 'package:pittaji_medicals/providers/data.dart';
import 'package:pittaji_medicals/providers/received_data.dart';
import 'package:pittaji_medicals/providers/update_sales.dart';
import 'package:pittaji_medicals/widgets/searchwidget.dart';
import 'package:provider/provider.dart';

class SalesReport extends StatefulWidget {
  SalesReport({Key? key}) : super(key: key);

  static const routeName = '/SalesReport';

  @override
  _SalesReportState createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  List<UpdateSales> list = [];

  var newData = UpdateSales(
    id: '',
    saleQty: '',
    returnQty: '',
  );
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    Provider.of<ExcelData>(context, listen: false)
        .fetchReportData()
        .then((value) {
      dataList = value;

      if (dataList.isNotEmpty) {
        reRun();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    finallist = ExcelData.salesReportData;
    finallistShowData = ExcelData.salesReportShowData;
    super.didChangeDependencies();
  }

  var isloading = true;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  List<Map<String, String>> finallistShowData = [];
  List<Map<String, String>> finallist = [];
  List<SalesReportData> dataList = [];
  List<SalesReportData> searchList = [];
  var date = DateTime.now();

  void saveForm() {
    // for (var data in dataList) {
    //   for (var value in list) {
    //     if (data.id == value.id) {
    //       finallist.add(
    //         {
    //           'id': data.id,
    //           'saleQty': value.saleQty,
    //           'returnQty': value.returnQty
    //         },
    //       );
    //     }
    //   }
    // }
    print(finallist.toString());

    Provider.of<ExcelData>(context, listen: false)
        .sendSalesReport(finallist)
        .then((value) {
      if (value == 201) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Successfuly uploaded the Data'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        finallistShowData.clear();
                        Navigator.of(ctx).pop();
                        reRun();
                      },
                      child: const Text('ok'),
                    )
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something Went Wrong'),
                  content: Text('Failed To uploaded the Data'),
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
    });
  }

  String query = '';
  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Filter based on OrderId',
        onChanged: searchBook,
      );
  void searchBook(String query) {
    final customers = ExcelData.salesReportlist.where((customer) {
      final productName = customer.productName.toString();

      final searchNumber = query;

      return productName.contains(searchNumber);
    }).toList();

    setState(() {
      this.query = query;
      searchList = customers;
      print(searchList.isEmpty);
    });
  }

  int _count = 0;

  // Pass this method to the child page.
  void _update(int count) {
    setState(() => _count = count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                buildSearch(),
                Container(
                  height: 500,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Product Name')),
                          DataColumn(label: Text('Batch Number')),
                        ],
                        rows: query == ''
                            ? <DataRow>[
                                for (var data in dataList)
                                  DataRow(cells: <DataCell>[
                                    DataCell(
                                      GestureDetector(
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (_) => ReportEnterScreen(
                                              data.productName,
                                              data.id,
                                              _update),
                                        ),
                                        child: Text(data.productName),
                                      ),
                                    ),
                                    DataCell(
                                      Text(data.batchNumber),
                                    ),
                                  ])
                              ]
                            : <DataRow>[
                                for (var data in searchList)
                                  DataRow(cells: <DataCell>[
                                    DataCell(
                                      GestureDetector(
                                        onTap: () => showDialog(
                                            context: context,
                                            builder: (_) => ReportEnterScreen(
                                                data.productName,
                                                data.id,
                                                _update)),
                                        child: Text(data.productName),
                                      ),
                                    ),
                                    DataCell(
                                      Text(data.batchNumber),
                                    ),
                                  ])
                              ]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveForm();
                  },
                  child: Text('Submit'),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 500,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: finallistShowData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Row(
                          children: [
                            Text(
                              finallistShowData[index]['ProductName']!,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              finallistShowData[index]['Sale_Qty']!,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              finallistShowData[index]['Return_Qty']!,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}

class ReportEnterScreen extends StatelessWidget {
  ReportEnterScreen(this.productName, this.id, this.update);
  var productName;
  var id;
  var saleQty;
  var orderQty;
  var date = DateTime.now().millisecondsSinceEpoch;
  // DateTime formatedDate = newDate.subtract(Duration(hours: newDate.hour, minutes: newDate.minute, seconds: newDate.second, milliseconds: newDate.millisecond, microseconds: newDate.microsecond));
  final ValueChanged<int> update;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void saveForm(BuildContext context) {
    ExcelData.salesReportData.add(
      {
        'id': id,
        'Sale_Qty': saleQty,
        'Return_Qty': orderQty,
        'Sale_Date': date.toString(),
      },
    );
    ExcelData.salesReportShowData.add(
      {
        'ProductName': productName,
        'Sale_Qty': saleQty,
        'Return_Qty': orderQty,
        'Sale_Date': date.toString(),
      },
    );
    update(100);
    print(ExcelData.salesReportData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shadowColor: Colors.blue,
              elevation: 8,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(productName),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'SaleQty'),
                        onSaved: (value) {
                          saleQty = value;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'ReturnQty'),
                        onSaved: (value) {
                          orderQty = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            saveForm(context);
                          },
                          child: Text('Submit'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
