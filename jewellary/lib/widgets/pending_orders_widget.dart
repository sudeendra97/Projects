import 'dart:convert';
import 'dart:math';

import 'package:an_app/providers/details.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:an_app/widgets/allorderswidget.dart';
import 'package:an_app/widgets/searchwidget.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';

import 'package:advanced_datatable/advancedDataTableSource.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PendingOrders extends StatefulWidget {
  PendingOrders({Key? key}) : super(key: key);

  // final router = FluroRouter();

  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  var initval = false;

  List<Details> orderList = [];

  static List<Details> list = [];

  final source = MyData();
  var query = '';
  int defaultRowsPerPage = 10;

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Filter',
        onChanged: (ctx) {},
      );

  var isloading = false;

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.only(top: 10),
            children: [
              AdvancedPaginatedDataTable(
                source: source,
                //  header: buildSearch(),
                columns: const [
                  // DataColumn(label: Text('UID')),
                  DataColumn(
                      label: Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Messages',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Date Created',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Order',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Vendor SKU',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('BE SKU',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Item Description',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Quantity Ordered',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Cost Of Item',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ship Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Original Ship Date',
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
                showCheckboxColumn: true,
                addEmptyRows: false,
                checkboxHorizontalMargin: 30,
                // onSelectAll: (value) {},
                showFirstLastButtons: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<sendUid> list = MyData.selectedIds
                        .map((e) => sendUid('uId', e))
                        .toList();
                    int i = 0;
                    for (var element in MyData.selectedIds) {
                      sendUid.list.add(sendUid('uId', element));
                      i++;
                    }

                    // for (var element in MyData.selectedIds) {
                    //   sendUid.data.addEntries({'uid': element});
                    // }
                    setState(() {
                      isloading = true;
                    });
                    await Provider.of<VendorsList>(context, listen: false)
                        .acceptOrder(sendUid.list)
                        .then(
                      (value) {
                        setState(() {
                          isloading = false;
                        });

                        if (value == 200 || value == 201) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Success'),
                              content: const Text(
                                  'Successfully confirmed the Order'),
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Something Went Wrong'),
                              content:
                                  const Text('Failed To confirm the Order'),
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
                      },
                    );
                    print(list.toString());
                    MyData.selectedIds.clear();
                    sendUid.list.clear();
                  },
                  child: const Text('confirm')),
            ],
          );
  }
}

typedef SelectedCallBack = Function(String id, bool newSelectState);

class MyData extends AdvancedDataTableSource<Details> {
  static List<String> selectedIds = [];
  String lastSearchTerm = '';

  @override
  int get selectedRowCount => selectedIds.length;
  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) =>
      lastDetails!.rows[index].getRow(selectedRow, selectedIds);

  @override
  Future<RemoteDataSourceDetails<Details>> getNextPage(
      NextPageRequest pageRequest) async {
    final requestUri = Uri.parse(
        'https://bennedoseyy.herokuapp.com/orders/fetchOrder/pending');
    final response = await http.get(requestUri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.toString());
      return RemoteDataSourceDetails(
        (data as List<dynamic>).length,
        (data as List<dynamic>).map((json) => Details.fromJson(json)).toList(),
        filteredRows: lastSearchTerm.isNotEmpty ? (data).length : null,
      );
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}

class sendUid {
  final String uid;
  final String Uid;

  sendUid(this.Uid, this.uid);

  static List<sendUid> list = [];

  static Map<String, dynamic> data = {};
}
