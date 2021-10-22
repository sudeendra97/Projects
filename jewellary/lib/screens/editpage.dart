import 'package:an_app/providers/vendors.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  EditPage([this.name, this.address, this.email, this.id]);

  var name;
  var address;
  var email;
  var id;

  static const routeName = '/EdirPage';

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  var isloading = false;
  var _newVendors = Vendors(
    name: '',
    address: '',
    email: '',
    uId: '',
  );
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Edit Vendor Details'),
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 300, vertical: 30),
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Vendor Details',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: widget.name,
                          onSaved: (value) {
                            _newVendors = Vendors(
                              name: value.toString(),
                              address: _newVendors.address,
                              email: _newVendors.email,
                              uId: widget.id.toString(),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: widget.email,
                          onSaved: (value) {
                            _newVendors = Vendors(
                              name: _newVendors.name,
                              address: _newVendors.address,
                              email: value.toString(),
                              uId: widget.id.toString(),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: widget.address,
                          onSaved: (value) {
                            _newVendors = Vendors(
                              name: _newVendors.name,
                              address: value.toString(),
                              email: _newVendors.email,
                              uId: widget.id.toString(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final isvalid = _formKey.currentState!.validate();
                          if (!isvalid) {
                            return;
                          }
                          _formKey.currentState!.save();

                          try {
                            setState(() {
                              isloading = true;
                            });
                            Provider.of<VendorsList>(context, listen: false)
                                .updateVendor(
                              _newVendors,
                            )
                                .then((value) {
                              setState(() {
                                isloading = false;
                              });
                              if (value == 200 || value == 201) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'Successfully Updated the Vendor'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          _formKey.currentState!.reset();
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
                                    title: const Text('Something Went Wrong'),
                                    content:
                                        const Text('Failed To Add the Vendor'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          _formKey.currentState!.reset();
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('ok'),
                                      )
                                    ],
                                  ),
                                );
                              }
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text('Edit Vendor'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
