import 'package:an_app/providers/filter_details.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:an_app/screens/message_screen.dart';
import 'package:an_app/screens/orderdetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'searchwidget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AllOrdersWidget extends StatefulWidget {
  AllOrdersWidget({Key? key}) : super(key: key);

  @override
  _AllOrdersWidgetState createState() => _AllOrdersWidgetState();
}

class _AllOrdersWidgetState extends State<AllOrdersWidget> {
  var loading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<VendorsList>(context, listen: false).fetchList().then((value) {
      changeload();
    });
  }

  void changeload() {
    setState(() {
      loading = false;
    });
  }

  // final source = MyData();

  DataTableSource filteredSource = MyFilteredData();
  var query = '';
  int defaultRowsPerPage = 10;
  static List<FilterDetails> list = [];

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Filter based on OrderId',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    final customers = FilterDetails.list.where((customer) {
      final cusNumber = customer.orderId.toString();

      final searchNumber = query.toLowerCase();

      return cusNumber.contains(searchNumber);
    }).toList();

    setState(() {
      this.query = query;
      list = customers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              PaginatedDataTable(
                source: query == '' ? MyFilteredData() : MySearchData(),
                header: buildSearch(),
                columns: const [
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
                showCheckboxColumn: false,
                // addEmptyRows: false,
                checkboxHorizontalMargin: 30,
                // onSelectAll: (value) {},
                showFirstLastButtons: true,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
  }
}

// typedef SelectedCallBack = Function(String id, bool newSelectState);

// class MyData extends AdvancedDataTableSource<AllDetails> {
//   static List<String> selectedIds = [];
//   String lastSearchTerm = '';

//   @override
//   int get selectedRowCount => selectedIds.length;
//   void selectedRow(String id, bool newSelectState) {
//     if (selectedIds.contains(id)) {
//       selectedIds.remove(id);
//     } else {
//       selectedIds.add(id);
//     }
//     notifyListeners();
//   }

//   @override
//   DataRow getRow(int index) =>
//       lastDetails!.rows[index].getRow(selectedRow, selectedIds);

//   @override
//   Future<RemoteDataSourceDetails<AllDetails>> getNextPage(
//       NextPageRequest pageRequest) async {
//     final requestUri = Uri.parse(
//         'https://bennedoseyy.herokuapp.com/orders/fetchOrder/confirmed');

//     final response = await http.get(requestUri);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       print(data.toString());
//       return RemoteDataSourceDetails(
//         (data as List<dynamic>).length,
//         (data as List<dynamic>)
//             .map((json) => AllDetails.fromJson(json))
//             .toList(),
//         filteredRows: lastSearchTerm.isNotEmpty ? (data).length : null,
//       );
//     } else {
//       throw Exception('Unable to query remote server');
//     }
//   }
// }

class MyFilteredData extends DataTableSource {
  final List<dynamic> data = FilterDetails.data;

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index]['Status'])),
      DataCell(Builder(builder: (context) {
        return TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return MessageScreen(
                      data[index]['Messages'], data[index]['Order_Id']);
                });
          },
          child: const Text('View/Reply'),
        );
      })),
      DataCell(
        Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(data[index]['Date_Created']!),
            ),
          ),
        ),
      ),
      DataCell(Builder(builder: (context) {
        return TextButton(
            child: Text(data[index]['Order_Id']),
            onPressed: () {
              Navigator.of(context).pushNamed(OrderDetailsScreen.routeName,
                  arguments: data[index]['Order_Id']);
            });
      })),
      DataCell(Text(data[index]['Vendor_SKU'])),
      DataCell(Text(data[index]['BE_SKU'])),
      DataCell(Text(data[index]['Item_Description'])),
      DataCell(Text(data[index]['Quantity_Ordered'])),
      DataCell(Text(data[index]['Cost_Of_Item'])),
      DataCell(Text(
        DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(data[index]['Ship_Date']),
          ),
        ),
      )),
      DataCell(Text(
        DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(data[index]['Date_Created']),
          ),
        ),
      )),
    ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}

class MySearchData extends DataTableSource {
  final List<dynamic> data = FilterDetails.data;
  final List<FilterDetails> list = _AllOrdersWidgetState.list;

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(cells: [
      DataCell(Text(list[index].status)),
      DataCell(Builder(builder: (context) {
        return TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return MessageScreen(
                      list[index].messages, list[index].orderId);
                });
          },
          child: const Text('View/Reply'),
        );
      })),
      DataCell(Text(
        DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(list[index].dateCreated),
          ),
        ),
      )),
      DataCell(Builder(builder: (context) {
        return TextButton(
            child: Text(list[index].orderId),
            onPressed: () {
              Navigator.of(context).pushNamed(OrderDetailsScreen.routeName,
                  arguments: list[index].orderId);
            });
      })),
      DataCell(Text(list[index].vendorSKU)),
      DataCell(Text(list[index].beSKU)),
      DataCell(Text(list[index].itemDescription)),
      DataCell(Text(list[index].quantityOrdered)),
      DataCell(Text(list[index].costOfItem)),
      DataCell(Text(
        DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(list[index].shipDate),
          ),
        ),
      )),
      DataCell(Text(
        DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(list[index].dateCreated),
          ),
        ),
      )),
    ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => list.length;
}
