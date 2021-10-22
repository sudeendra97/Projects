import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/listdata.dart';
import 'package:todo_app/screens/tododatascreen.dart';

class BuildingListData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<TodoListData>(
      context,
    );
    return ListView.builder(
      itemCount: listData.list.length,
      itemBuilder: (BuildContext context, int index) => Column(
        children: [
          TodoDataScreen(
            UniqueKey(),
            listData.list[index].id,
            listData.list[index].data,
            listData.list[index].time,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
