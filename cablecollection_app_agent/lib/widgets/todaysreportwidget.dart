import 'dart:io';

import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/widgets/select_area_today.dart';
import 'package:cablecollection_app/widgets/select_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class TodaysReportWidget extends StatefulWidget {
  TodaysReportWidget({Key key}) : super(key: key);

  @override
  _TodaysReportWidgetState createState() => _TodaysReportWidgetState();
}

class _TodaysReportWidgetState extends State<TodaysReportWidget>
    with AutomaticKeepAliveClientMixin {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');
  var myFormatData = DateFormat('yyyy-MM-dd');
  Future<void> _saveForm() async {
    try {
      String fromDate = myFormatData.format(startDate);
      String toDate = myFormatData.format(endDate);
      var selectedArea = SelectArea.areaList;
      setState(() {
        isloading = true;
      });
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<ReportList>(context, listen: false)
              .getReport(fromDate, toDate, token, selectedArea)
              .then((value) {
            if (value != 200) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('An error Occured '),
                  content: Text('Something Went Wrong in fetching bill '),
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
              reRun();
            }
          });
        }
      });
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error Occured '),
          content: Text('Something Went Wrong in fetching bill '),
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
  }

  var isloading = false;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  void share() async {
    String fromDate = myFormat.format(startDate);
    String toDate = myFormat.format(endDate);
    List<Directory> dir = await getExternalStorageDirectories();
    File testFile = new File("${dir.first.path}/${fromDate}to$toDate.xlsx");
    if (!await testFile.exists()) {
      // await testFile.create(recursive: true);
      // testFile.writeAsStringSync("test for share documents file");

    }
    ShareExtend.share(testFile.path, "file");
  }

  @override
  Widget build(BuildContext context) {
    String fromDate = myFormat.format(startDate);
    String toDate = myFormat.format(endDate);
    return isloading == true
        ? Center(child: Text('Loading Report'))
        : Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    // alignment: Alignment.topLeft,
                    child: Text(
                      'Bill From:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        fromDate,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    //alignment: Alignment.centerLeft,
                    child: Text(
                      'Bill To:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        toDate,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SelectArea(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: share,
                    child: Text('Share'),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      // style: ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStateProperty.all(Colors.black)),
                      onPressed: _saveForm,
                      child: Text('Submit'),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
