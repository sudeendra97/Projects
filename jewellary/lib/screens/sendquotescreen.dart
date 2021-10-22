import 'package:an_app/providers/quotationdata.dart';
import 'package:an_app/providers/vendors.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SendQuoteScreen extends StatefulWidget {
  // String selectdate;

  // SendQuoteScreen([this.selectdate]);

  @override
  _SendQuoteScreenState createState() => _SendQuoteScreenState();
}

class _SendQuoteScreenState extends State<SendQuoteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool value1 = false;
  List<PopupMenuEntry<Object>> list = [];
  static List emailList = [];
  static List vendorName = [];
  static int selectdate = 0;
  var initdate = DateTime.now().millisecondsSinceEpoch;
  static List uid = [];
  var myFormat = DateFormat('d-MM-yyyy');
  // var initdate = DateTime.now();

  var _newVendors = QuotationData(
    emails: emailList,
    uid: uid,
    vendorNames: vendorName,
    itemDescription: '',
    beSKU: '',
    costOfItem: '',
    quantity: '',
    vendorSKU: '',
    date: '',
    initdate: '',
  );
  var _reSet = QuotationData(
    emails: emailList,
    uid: uid,
    vendorNames: vendorName,
    itemDescription: '',
    beSKU: '',
    costOfItem: '',
    quantity: '',
    vendorSKU: '',
    date: '',
    initdate: '',
  );

  List<Vendors> vendorlist = [];
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    // initdate = myFormat.format(DateTime.now()).toString();

    Provider.of<VendorsList>(context, listen: false)
        .fetchAndSetVendors()
        .then((value) {
      final vendorList = Provider.of<VendorsList>(context, listen: false).list;
      vendorlist = vendorList;

      // print(vendorList.isEmpty.toString());
      for (int i = 0; i < vendorList.length; i++) {
        list.add(
          PopupMenuItem(
            child: DataWidget(vendorList: vendorList, i: i, value1: value1),
          ),
        );
      }
      reRun();
    });
  }

  void reRun() {
    setState(() {
      isLoading = false;
    });
  }

  void refreshList() {
    list.clear();
    for (int i = 0; i < vendorlist.length; i++) {
      list.add(
        PopupMenuItem(
          child: DataWidget(vendorList: vendorlist, i: i, value1: value1),
        ),
      );
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<VendorsList>(context, listen: false)
          .addQuotation(_newVendors)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value == 200) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Successfully Sent the Quotation'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _newVendors = _reSet;
                    refreshList();
                    emailList.clear();
                    uid.clear();
                    vendorName.clear();
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
              title: const Text('Failed to upload the file'),
              content: const Text('Something Went Wrong'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _newVendors = _reSet;
                    refreshList();
                    emailList.clear();
                    uid.clear();
                    vendorName.clear();
                  },
                  child: const Text('ok'),
                )
              ],
            ),
          );
        }
        _formKey.currentState!.reset();
      });
      // print(_newVendors.date.toString());
      //  print(selectdate);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 300, vertical: 30),
              child: Card(
                shadowColor: Theme.of(context).primaryColor,
                borderOnForeground: true,
                elevation: 10,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Select Vendors',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: PopupMenuButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  enableFeedback: true,
                                  iconSize: 25,
                                  elevation: 3,
                                  tooltip: 'Vendors',
                                  // child: const Text('Vendors'),
                                  onSelected: (value1) {},
                                  itemBuilder: (context) => list,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Item Description*'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a Description for Item';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            _newVendors = QuotationData(
                              itemDescription: value.toString(),
                              beSKU: _newVendors.beSKU,
                              costOfItem: _newVendors.costOfItem,
                              emails: _newVendors.emails,
                              quantity: _newVendors.quantity,
                              uid: _newVendors.uid,
                              vendorSKU: _newVendors.vendorSKU,
                              date: initdate.toString(),
                              vendorNames: _newVendors.vendorNames,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Quantity*'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a Quantity';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            _newVendors = QuotationData(
                              itemDescription: _newVendors.itemDescription,
                              beSKU: _newVendors.beSKU,
                              costOfItem: _newVendors.costOfItem,
                              emails: _newVendors.emails,
                              quantity: value.toString(),
                              uid: _newVendors.uid,
                              vendorSKU: _newVendors.vendorSKU,
                              date: _newVendors.date,
                              vendorNames: _newVendors.vendorNames,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Cost Of Item*'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a Cost Of Item';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            _newVendors = QuotationData(
                              itemDescription: _newVendors.itemDescription,
                              beSKU: _newVendors.beSKU,
                              costOfItem: value.toString(),
                              emails: _newVendors.emails,
                              quantity: _newVendors.quantity,
                              uid: _newVendors.uid,
                              vendorSKU: _newVendors.vendorSKU,
                              date: _newVendors.date,
                              vendorNames: _newVendors.vendorNames,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Vendor_SKU*'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a Vendor SKU';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            _newVendors = QuotationData(
                              itemDescription: _newVendors.itemDescription,
                              beSKU: _newVendors.beSKU,
                              costOfItem: _newVendors.costOfItem,
                              emails: _newVendors.emails,
                              quantity: _newVendors.quantity,
                              uid: _newVendors.uid,
                              vendorSKU: value.toString(),
                              date: _newVendors.date,
                              vendorNames: _newVendors.vendorNames,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Client_SKU*'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a BE SKU';
                            }
                            //this returning null ensures that there is no error
                            return null;
                          },
                          onSaved: (value) {
                            _newVendors = QuotationData(
                              itemDescription: _newVendors.itemDescription,
                              beSKU: value.toString(),
                              costOfItem: _newVendors.costOfItem,
                              emails: _newVendors.emails,
                              quantity: _newVendors.quantity,
                              uid: _newVendors.uid,
                              vendorSKU: _newVendors.vendorSKU,
                              date: _newVendors.date,
                              initdate: initdate.toString(),
                              vendorNames: _newVendors.vendorNames,
                            );
                          },
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   child: TextFormField(
                      //     // initialValue: initdate,
                      //     decoration: const InputDecoration(labelText: 'ship Date'),
                      //     onSaved: (value) {
                      //       _newVendors = QuotationData(
                      //         itemDescription: _newVendors.itemDescription,
                      //         beSKU: _newVendors.beSKU,
                      //         costOfItem: _newVendors.costOfItem,
                      //         emails: _newVendors.emails,
                      //         quantity: _newVendors.quantity,
                      //         uid: _newVendors.uid,
                      //         vendorSKU: _newVendors.vendorSKU,
                      //         date: _newVendors.date,
                      //         initdate: value.toString(),
                      //       );
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      DateWidget(false),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: _saveForm, child: const Text('Send')),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class DataWidget extends StatefulWidget {
  DataWidget({
    Key? key,
    required this.vendorList,
    required this.i,
    required this.value1,
  }) : super(key: key);

  final List<Vendors> vendorList;
  final int i;
  bool value1;

  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  bool initval = true;
  int _count = 0;

  // Pass this method to the child page.
  void _update(int count) {
    setState(() => _count = count);
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: widget.value1,
      onChanged: (value) {
        setState(
          () {
            widget.value1 = value!;
            if (value == true) {
              _SendQuoteScreenState.emailList
                  .add(widget.vendorList[widget.i].email);
              _SendQuoteScreenState.uid.add(widget.vendorList[widget.i].uId);
              _SendQuoteScreenState.vendorName
                  .add(widget.vendorList[widget.i].name);
            } else if (value == false) {
              _SendQuoteScreenState.emailList
                  .remove(widget.vendorList[widget.i].email);
              _SendQuoteScreenState.uid.remove(widget.vendorList[widget.i].uId);
              _SendQuoteScreenState.vendorName
                  .remove(widget.vendorList[widget.i].name);
            }
          },
        );
        // print(_SendQuoteScreenState.emailList.toString());
        // print(_SendQuoteScreenState.uid.toString());
        // print(_SendQuoteScreenState.vendorName.toString());
      },
      title: Text(widget.vendorList[widget.i].name),
    );
  }
}

class DateWidget extends StatefulWidget {
  DateWidget(this.reRun);

  var reRun = false;

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  // void didChangeDependencies() {
  //   if (widget.reRun == true) {
  //     rerun();
  //   }
  //   super.didChangeDependencies();
  // }

  var selectingDate;
  var myFormat = DateFormat('d-MM-yyyy');
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
        selectingDate = pickedDate;

        _SendQuoteScreenState.selectdate = (pickedDate.millisecondsSinceEpoch);

        // pickedDate.toString();
        print(_SendQuoteScreenState.selectdate);
      });
      // assign();
    });
  }

  void rerun() {
    setState(() {});
  }
  // void assign() {
  //   SendQuoteScreen(selectingDate.toString());
  //   print(selectingDate.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: const ButtonStyle(
              enableFeedback: true,
            ),
            // textColor: Theme.of(context).primaryColor,
            onPressed: _presentdatepicker,
            child: const Text(
              'Choose date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(
            selectingDate == null
                ? 'No Date chosen'
                : 'Ship date: ${DateFormat.yMEd().format(selectingDate)}',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
