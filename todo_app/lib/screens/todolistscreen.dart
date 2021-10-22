import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/listdata.dart';
import 'package:todo_app/screens/tododatascreen.dart';
import 'package:todo_app/widgets/buildlistdata.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  var _isInit = true;
  var _IsLoading = false;

  @override
  void initState() {
    super.initState();
    if (_isInit) {
      setState(() {
        _IsLoading = true;
      });
      Provider.of<TodoListData>(
        context,
        listen: false,
      ).fetchAndSetProduct().then((value) {
        _IsLoading = false;
      });

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void didChangeDependencies() {
    if (_IsLoading == true) {
      Provider.of<TodoListData>(
        context,
      ).fetchAndSetProduct();
    }

    super.didChangeDependencies();
  }

  // void fetch() {
  //   Provider.of<TodoListData>(
  //     context,
  //     listen: false,
  //   ).fetchAndSetProduct().then((value) {
  //     _IsLoading = false;
  //   });
  // }

  @override
  // void didChangeDependencies() {
  //   Provider.of<TodoListData>(
  //     context,
  //   ).fetchAndSetProduct();
  // }

  @override
  Widget build(BuildContext context) {
    return _IsLoading
        ? Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Loading Data', style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 5,
                  ),
                  CircularProgressIndicator(),
                ]),
          )
        : BuildingListData();
  }
}
