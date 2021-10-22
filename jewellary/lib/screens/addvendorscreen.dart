import 'package:an_app/providers/vendors.dart';
import 'package:an_app/providers/vendorslist.dart';
import 'package:an_app/screens/editpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class AddVendor extends StatefulWidget {
  AddVendor({Key? key}) : super(key: key);

  @override
  State<AddVendor> createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _newVendors = Vendors(
    name: '',
    address: '',
    email: '',
  );

  var _initValues = {
    'name': '',
    'address': '',
    'email': '',
  };

  var isLoading = true;
  var isEdit = false;

  List<Vendors> list = [];

  @override
  void initState() {
    super.initState();
    Provider.of<VendorsList>(context, listen: false)
        .fetchAndSetVendors()
        .then((value) {
      final vendorList = Provider.of<VendorsList>(context, listen: false).list;
      list = vendorList;
      reRun();
    });
  }

  // void didChangeDependencies() {
  //     Provider.of<VendorsList>(context, listen: false)
  //       .fetchAndSetVendors()
  //       .then((value) {
  //     final vendorList = Provider.of<VendorsList>(context, listen: false).list;
  //     list = vendorList;
  //     reRun();
  //   super.didChangeDependencies();

  // }

  void fetchVendors() {
    Provider.of<VendorsList>(context, listen: false)
        .fetchAndSetVendors()
        .then((value) {
      final vendorList = Provider.of<VendorsList>(context, listen: false).list;
      list = vendorList;
      reRun();
    });
  }

  void reRun() {
    setState(() {
      isLoading = false;
    });
  }

  void reEdit() {
    setState(() {
      isEdit = true;
    });
  }

  Future<void> _saveForm(BuildContext context) async {
    final isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      await Provider.of<VendorsList>(context, listen: false)
          .addVendor(_newVendors);
      //  Provider.of<CustomerList>(context, listen: false).fetchAndSetCustomer();

    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 250, vertical: 50),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: const Text(
                              'Enter the Vendor Details',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            initialValue:
                                isEdit == true ? _initValues['name'] : '',
                            decoration: const InputDecoration(
                                labelText: 'Vendor Name*'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please provide a Name';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                            onSaved: (value) {
                              _newVendors = Vendors(
                                name: value.toString(),
                                address: _newVendors.address,
                                email: _newVendors.email,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            initialValue:
                                isEdit == true ? _initValues['email'] : '',
                            decoration: const InputDecoration(
                                labelText: 'Vendor Email*'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please provide a Email Address';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                            onSaved: (value) {
                              _newVendors = Vendors(
                                name: _newVendors.name,
                                address: _newVendors.address,
                                email: value.toString(),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            initialValue:
                                isEdit == true ? _initValues['address'] : '',
                            decoration: InputDecoration(labelText: 'Address*'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please provide a Address';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                            onSaved: (value) {
                              _newVendors = Vendors(
                                name: _newVendors.name,
                                address: value.toString(),
                                email: _newVendors.email,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                isLoading = true;
                              });
                              await Provider.of<VendorsList>(context,
                                      listen: false)
                                  .addVendor(_newVendors)
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (value == 200 || value == 201) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text(
                                          'Successfully Added the Vendor'),
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
                                  setState(() {
                                    isLoading = true;
                                    fetchVendors();
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Something Went Wrong'),
                                      content: const Text(
                                          'Failed To Add the Vendor'),
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
                            } catch (error) {
                              print(error.toString());
                            }
                          },
                          child: const Text('Save Vendor'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 400, vertical: 10),
                child: const Text(
                  'Vendor List',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              // for (var data in list)
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Card(
              //       elevation: 3,
              //       child: GestureDetector(
              //         onTap: () {
              //           _initValues = {
              //             'name': data.name.toString(),
              //             'address': data.address.toString(),
              //             'email': data.email.toString(),
              //           };
              //           print(_initValues);
              //           reEdit();
              //         },
              //         child: Container(
              //             child: Text(
              //           data.name,
              //         )),
              //       ),
              //     ),
              //   )

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 400, vertical: 10),
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return EditPage(
                                  list[index].name.toString(),
                                  list[index].address.toString(),
                                  list[index].email.toString(),
                                  list[index].uId.toString(),
                                );
                              },
                            );
                          },
                        ),
                        title: Text(list[index].name),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
  }
}
