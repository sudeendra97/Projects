import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tododata.dart';
import 'package:todo_app/providers/listdata.dart';
import 'package:intl/intl.dart';

class TodoAddScreen extends StatefulWidget {
  static const routeName = '/TodoAddScreen';

  @override
  State<TodoAddScreen> createState() => _TodoAddScreenState();
}

class _TodoAddScreenState extends State<TodoAddScreen> {
  var _editedProduct = TodoData(data: '', time: '');
  var _selectdate;

  final _form = GlobalKey<FormState>();

  void saveForm() {
    Provider.of<TodoListData>(
      context,
      listen: false,
    ).addData(_editedProduct);
    Navigator.of(context).pop();
  }

  void notify(BuildContext context) {
    Provider.of<TodoListData>(
      context,
    ).fetchAndSetProduct();
  }

  void _presentdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2023),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectdate = pickedDate;
        _editedProduct = TodoData(
          data: _editedProduct.data,
          time: DateFormat.yMEd().format(_selectdate).toString(),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddTask'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  labelText: 'Task',
                ),
                onChanged: (value) {
                  _editedProduct = TodoData(
                    data: value,
                    time: _editedProduct.time,
                  );
                },
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectdate == null
                            ? 'No Date choosen'
                            : 'picked date: ${DateFormat.yMEd().format(_selectdate)}',
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _presentdatepicker,
                      child: const Text(
                        'Choose date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                width: 80,
                child: ElevatedButton(
                  onPressed: saveForm,
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(elevation: MaterialStateProperty.all(10)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
