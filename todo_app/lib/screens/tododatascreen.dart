import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/listdata.dart';

class TodoDataScreen extends StatefulWidget {
  var content;
  var time;
  var id;

  TodoDataScreen(
    Key key,
    this.id,
    this.content,
    this.time,
  ) : super(key: key);

  @override
  State<TodoDataScreen> createState() => _TodoDataScreenState();
}

class _TodoDataScreenState extends State<TodoDataScreen> {
  bool value = false;

  void fetch() {
    Provider.of<TodoListData>(
      context,
      // listen: false,
    ).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    //  final ListItem = Provider.of<TodoListData>(context, listen: false);
    //final scaffold = Scaffold.of(context);

    return ListTile(
      leading: Checkbox(
          value: value,
          onChanged: (change) {
            setState(() {
              value = change!;
            });
          }),
      title: Text(widget.content),
      subtitle: Text(widget.time),
      trailing: IconButton(
        onPressed: () async {
          try {
            if (value == true) {
              await Provider.of<TodoListData>(context, listen: false)
                  .deleteProduct(widget.id);
              fetch();
            } else {
              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Select the checkBox First',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (error) {
            print(error);
            // Scaffold.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Deleting failed'),
            //   ),
            //  );
          }
        },
        icon: const Icon(
          Icons.delete,
          // size: kTextTabBarHeight,
        ),
      ),
    );
  }
}
