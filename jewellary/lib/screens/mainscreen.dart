import 'package:an_app/screens/addvendorscreen.dart';
import 'package:an_app/screens/sendquotescreen.dart';

import 'package:an_app/widgets/allorderswidget.dart';
import 'package:an_app/widgets/confirm_order_widget.dart';
import 'package:an_app/widgets/pending_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          const SliverAppBar(
            foregroundColor: Colors.black,
            backgroundColor: Color(0xFFFDFAF6),
            // titleTextStyle: TextStyle(color: Colors.black),
            title: Text('SterlynSilver'),
            //   backgroundColor: Color(0xFF1E212D),
            floating: true,
            pinned: true,
            snap: true,
            bottom: TabBar(
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorColor: Color(0xFF22577A),
              labelColor: Colors.black,
              automaticIndicatorColorAdjustment: true,
              padding: EdgeInsets.only(top: 0),
              tabs: <Widget>[
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Pending Orders',
                ),
                Tab(
                  text: 'Confirmed Orders',
                ),
                Tab(
                  text: 'Ship Page',
                ),
                Tab(
                  text: 'Purchase Order',
                ),
                Tab(
                  text: 'Add Vendor',
                )
              ],
            ),
          )
        ];
      },
      body: TabBarView(
        children: <Widget>[
          Center(
            child: AllOrdersWidget(),
          ),
          Center(
            child: PendingOrders(),
          ),
          Center(
            child: ConfirmedOrders(),
          ),
          Center(
            child: Text('data'),
          ),
          Center(
            child: SendQuoteScreen(),
          ),
          Center(
            child: AddVendor(),
          ),
        ],
      ),
    );
  }
}
