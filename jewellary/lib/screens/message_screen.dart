import 'package:an_app/providers/vendorslist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class MessageScreen extends StatefulWidget {
  List message;
  var orderId;
  MessageScreen(this.message, this.orderId);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var isloading = true;

  @override
  void didChangeDependencies() {
    Provider.of<VendorsList>(context, listen: false)
        .fetchOrderDetails(widget.orderId)
        .then((list) {
      for (var data in list) {
        widget.message = data.messages;
      }

      reRun();
    });

    super.didChangeDependencies();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  void fetchMessageAndPdf() {
    Provider.of<VendorsList>(context, listen: false)
        .fetchOrderDetails(widget.orderId)
        .then((list) {
      for (var data in list) {
        widget.message = data.messages;
      }

      didChangeDependencies();
    });
  }

  String newMessage = '';

  TextEditingController mycontroller = TextEditingController();
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
              title: const Text('Message'),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 3,
                    child: SizedBox(
                      height: 300,
                      child: widget.message.isEmpty
                          ? const Text('No Messages To Display')
                          : ListView.builder(
                              itemCount: widget.message.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(widget.message[index]);
                              },
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                      ),
                      height: 200,
                      width: 600,
                      child: TextField(
                        maxLines: 10,
                        decoration: const InputDecoration(labelText: 'Text'),
                        controller: mycontroller,
                        onChanged: (value) {
                          newMessage = value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        height: 100,
                        width: 150,
                        child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(withReadStream: true);

                              PlatformFile? objFile = null;

                              if (result != null) {
                                objFile = result.files.single;
                                var orderId = widget.orderId;
                                setState(() {
                                  isloading = true;
                                });

                                Provider.of<VendorsList>(context, listen: false)
                                    .uploadSelectedFile(objFile, orderId)
                                    .then((value) {
                                  setState(() {
                                    isloading = false;
                                  });
                                  if (value == 200) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Success'),
                                        content:
                                            const Text('Uploaded the File'),
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
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                            'Failed to upload the file'),
                                        content:
                                            const Text('Something Went Wrong'),
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
                                });
                              }
                            },
                            child: const Text('Choose file to upload',
                                style: TextStyle(color: Colors.black))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                        ),
                        child: TextButton(
                            onPressed: () {
                              Provider.of<VendorsList>(context, listen: false)
                                  .sendMessage(newMessage, widget.orderId);

                              setState(() {
                                isloading = false;
                                fetchMessageAndPdf();
                                mycontroller.clear();
                              });
                            },
                            child: const Text('Reply',
                                style: TextStyle(color: Colors.black))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                        ),
                        child: TextButton(
                            onPressed: () {},
                            child: const Text('Mark As Read',
                                style: TextStyle(color: Colors.black))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                        ),
                        child: TextButton(
                            onPressed: () {},
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.black))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
