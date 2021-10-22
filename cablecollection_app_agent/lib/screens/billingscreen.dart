import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/blist.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customerbill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

class BillingScreen extends StatefulWidget {
  static const routeName = '/BillingScreen';
  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _form = GlobalKey<FormState>();
  var _selectdate;
  var _endDate;
  var fromDate;
  var toDate;
  var numberOfDays = 30;
  var cuId;
  var isloading = true;
  var myFormat = DateFormat('dd-MM-yyyy');
  final Telephony telephony = Telephony.instance;

  Map<String, dynamic> customerData;
  Map<String, dynamic> cusValues = {
    'id': '',
    'name': '',
    'smartCardNumber': '',
    'packageAmount': '',
    'advance': '0',
    'lastPaid': '',
    'mobileNumber': null,
  };
  var customerBillData = CustomerBill(
    advance: '',
    billby: '',
    billdate: DateTime.now().millisecondsSinceEpoch,
    billfrom: 0,
    billno: '',
    billto: 0,
    buid: '',
    cuid: '',
    days: '',
    due: '',
    paidamount: null,
    tax: '0',
  );

  var initValues = {
    'advance': '',
    'billby': '',
    'billdate': '',
    'billfrom': '',
    'billno': '',
    'billto': '',
    'buid': '',
    'cuid': '',
    'days': '',
    'due': '',
    'paidamount': '',
    'tax': '',
  };
  void didChangeDependencies() {
    final customerId = ModalRoute.of(
      context,
    ).settings.arguments;
    if (customerId != '') {
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<CustomerList>(context, listen: false)
              .fetchCustomerBillingDetails(customerId, token)
              .then((value) {
            if (value != null) {
              customerData = value;
              // print(customerData.toString());

              setState(() {
                cusValues = {
                  'id': value['id'],
                  'name': value['name'],
                  'smartCardNumber': value['smartCardNumber'],
                  'packageAmount': value['packageAmount'],
                  'lastPaid': value['paidAmount'],
                  'mobileNumber': value['number'],
                };
              });
              reRun();
            } else {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Failed'),
                  content: Text('Unable to Fetch Bill'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('ok'),
                    )
                  ],
                ),
              );
            }
          });
        }
      });
      // Provider.of<CustomerList>(
      //   context,
      //   listen: false,
      // ).fetchCustomerBill(customerId).then((value) {
      //   print(value.toString());
      //   setState(() {
      //     cusValues = {
      //       'id': value['id'],
      //       'name': value['Name'],
      //       'smartCardNumber': value['SmartCardNumber'],
      //       'packageAmount': value['PackageAmount'],
      //       'advance': value['Advance'],
      //     };
      //   });
      // });
      // var date = _selectdate;
      cuId = customerId;
      // _endDate = numberOfDays >= 30
      //     ? date.add(
      //         Duration(days: numberOfDays, hours: 0, minutes: 0, seconds: 0))
      //     : date.add(Duration(days: 30, hours: 0, minutes: 0, seconds: 0));
    }

    super.didChangeDependencies();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  void _presentdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectdate = pickedDate;
        fromDate = pickedDate.millisecondsSinceEpoch;

        var date = _selectdate;
        _endDate = numberOfDays >= 30
            ? date.add(
                Duration(days: numberOfDays, hours: 0, minutes: 0, seconds: 0))
            : date.add(Duration(days: 30, hours: 0, minutes: 0, seconds: 0));
        toDate = _endDate.millisecondsSinceEpoch;
      });
    });
  }

  Future<void> _saveForm() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid && _selectdate == null) {
      if (_selectdate == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            // duration: Duration(milliseconds: 100),
            content: Text("Please Select the date First"),
          ),
        );
      }
      return;
    }
    _form.currentState.save();
    try {
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          setState(() {
            isloading = true;
          });
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<BillList>(context, listen: false)
              .addBill(customerBillData, token)
              .then((value) async {
            if (value == 201 || value == 200) {
              reRun();
              bool permissionsGranted =
                  await telephony.requestPhoneAndSmsPermissions;
              final SmsSendStatusListener listener = (SendStatus status) {
                print('success');
                // Handle the status
              };
              telephony.sendSms(
                to: cusValues['mobileNumber'].toString(),
                message:
                    "Your Cable Bill of Rs${customerBillData.paidamount} is paid on ${myFormat.format(DateTime.fromMillisecondsSinceEpoch(customerBillData.billdate))}",
                statusListener: listener,
              );
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Bill Successfully Submitted'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
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
                  title: Text('Failed'),
                  content: Text('Something went wrong please try again'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('ok'),
                    )
                  ],
                ),
              );
            }
          });
        }
      });
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error Occured'),
          content: Text('Something Went Wrong'),
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
    //  Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E212D),
        title: Text('Billing Screen'),
      ),
      body: isloading == true
          ? Center(
              child: Text('Loading Data'),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('ID: ${cusValues['id']}'),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${cusValues['name']}',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                            'Smart Card Number: ${cusValues['smartCardNumber']}'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                            'CurrentPackageAmount: ${cusValues['packageAmount']}'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('Advance: ${cusValues['advance']}'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('Last Paid: ${cusValues['lastPaid']}'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('Due/Total Payable:'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('TAX:'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            Card(
                              child: TextFormField(
                                initialValue: numberOfDays.toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText:
                                        'Number Of Days(default 30 days)*'),
                                onChanged: (value) {
                                  if (value == null || value.isEmpty) {
                                    return;
                                  } else if (_selectdate == null) {
                                    numberOfDays = int.tryParse(value);
                                  } else {
                                    setState(
                                      () {
                                        numberOfDays = int.tryParse(value);
                                        _endDate = _selectdate.add(Duration(
                                            days: numberOfDays,
                                            hours: 0,
                                            minutes: 0,
                                            seconds: 0));
                                      },
                                    );
                                  }
                                },
                                onSaved: (value) {
                                  customerBillData = CustomerBill(
                                    advance: customerBillData.advance,
                                    paidamount: customerBillData.paidamount,
                                    billby: customerBillData.billby,
                                    billdate: customerBillData.billdate,
                                    billfrom: customerBillData.billfrom,
                                    billno: customerBillData.billno,
                                    billto: customerBillData.billto,
                                    buid: customerBillData.buid,
                                    cuid: customerBillData.cuid,
                                    days: value,
                                    due: customerBillData.due,
                                    tax: customerBillData.tax,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Bill Number*'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'please Enter The BillNumber';
                                  }
                                  //this returning null ensures that there is no error
                                  return null;
                                },
                                onSaved: (value) {
                                  customerBillData = CustomerBill(
                                    advance: customerBillData.advance,
                                    paidamount: customerBillData.paidamount,
                                    billby: customerBillData.billby,
                                    billdate: customerBillData.billdate,
                                    billfrom: customerBillData.billfrom,
                                    billno: value,
                                    billto: customerBillData.billto,
                                    buid: customerBillData.buid,
                                    cuid: customerBillData.cuid,
                                    days: customerBillData.days,
                                    due: customerBillData.due,
                                    tax: customerBillData.tax,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 80,
                              child: Row(
                                children: [
                                  Text('Start Date*: '),
                                  Expanded(
                                    child: Text(
                                      _selectdate == null
                                          ? 'No Date choosen'
                                          : ' ${DateFormat.yMMMMEEEEd().format(_selectdate)}',
                                    ),
                                  ),
                                  FlatButton(
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed: _presentdatepicker,
                                    child: const Text(
                                      'Choose date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text('End Date:'),
                                  Expanded(
                                    child: Text(_endDate == null
                                        ? ' '
                                        : ' ${DateFormat.yMMMMEEEEd().format(_endDate)}'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Enter Amount*'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please Enter Amount';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                customerBillData = CustomerBill(
                                  advance: customerBillData.advance,
                                  paidamount: int.parse(value),
                                  billby: customerBillData.billby,
                                  billdate: customerBillData.billdate,
                                  billfrom: _selectdate.millisecondsSinceEpoch,
                                  billno: customerBillData.billno,
                                  billto: _endDate.millisecondsSinceEpoch,
                                  buid: customerBillData.buid,
                                  cuid: cuId,
                                  days: customerBillData.days,
                                  due: customerBillData.due,
                                  tax: customerBillData.tax,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: '0',
                              decoration: InputDecoration(labelText: 'Advance'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please Enter Advance';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                customerBillData = CustomerBill(
                                  advance: value,
                                  paidamount: customerBillData.paidamount,
                                  billby: customerBillData.billby,
                                  billdate: customerBillData.billdate,
                                  billfrom: customerBillData.billfrom,
                                  billno: customerBillData.billno,
                                  billto: customerBillData.billto,
                                  buid: customerBillData.buid,
                                  cuid: customerBillData.cuid,
                                  days: customerBillData.days,
                                  due: customerBillData.due,
                                  tax: customerBillData.tax,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: '0',
                              decoration: InputDecoration(labelText: 'DUE'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please Enter Due Amount';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                customerBillData = CustomerBill(
                                  advance: customerBillData.advance,
                                  paidamount: customerBillData.paidamount,
                                  billby: customerBillData.billby,
                                  billdate: customerBillData.billdate,
                                  billfrom: customerBillData.billfrom,
                                  billno: customerBillData.billno,
                                  billto: customerBillData.billto,
                                  buid: customerBillData.buid,
                                  cuid: customerBillData.cuid,
                                  days: customerBillData.days,
                                  due: value,
                                  tax: customerBillData.tax,
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: _saveForm,
                                child: Text('Save Bill'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
