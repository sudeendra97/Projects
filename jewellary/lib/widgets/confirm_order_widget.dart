import 'dart:convert';
import 'dart:math';

import 'package:an_app/providers/confirmeddetails.dart';
import 'package:an_app/providers/details.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:an_app/widgets/searchwidget.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';

import 'package:advanced_datatable/advancedDataTableSource.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ConfirmedOrders extends StatefulWidget {
  ConfirmedOrders({Key? key}) : super(key: key);

  // final router = FluroRouter();

  @override
  _ConfirmedOrdersState createState() => _ConfirmedOrdersState();
}

class _ConfirmedOrdersState extends State<ConfirmedOrders> {
  var initval = false;
  @override
  void initState() {
    super.initState();
    list = Provider.of<VendorsList>(
      context,
      listen: false,
    ).allOrderList;
    print(list.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initval == true) {}
  }

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

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          showCheckboxColumn: false,
          addEmptyRows: false,
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

typedef SelectedCallBack = Function(String id, bool newSelectState);

class MyData extends AdvancedDataTableSource<ConfirmedDetails> {
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
  Future<RemoteDataSourceDetails<ConfirmedDetails>> getNextPage(
      NextPageRequest pageRequest) async {
    final requestUri = Uri.parse(
        'https://bennedoseyy.herokuapp.com/orders/fetchOrder/confirmed');
    final response = await http.get(requestUri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.toString());
      return RemoteDataSourceDetails(
        (data as List<dynamic>).length,
        (data as List<dynamic>)
            .map((json) => ConfirmedDetails.fromJson(json))
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty ? (data).length : null,
      );
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}
