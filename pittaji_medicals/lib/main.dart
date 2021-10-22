import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pittaji_medicals/providers/data.dart';
import 'package:pittaji_medicals/screens/filterscreen.dart';
import 'package:pittaji_medicals/screens/mis_expiry_based_on_month_screen.dart';
import 'package:pittaji_medicals/screens/sales_report_screen.dart';
import 'package:provider/provider.dart';
import 'screens/total_sales_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (ctx) => ExcelData(),
          ),
        ],
        child:
     MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PittaJis',
      home: MyHome(),
      routes: {
            SalesReport.routeName: (ctx) => SalesReport(),
            FilterScreen.routeName:(ctx)=>FilterScreen(),
            TotalSales.routeName:(ctx)=> TotalSales(),
            ExpiryBasedOnMonth.routeName:(ctx)=>ExpiryBasedOnMonth(),
          },
    ),

    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  
 
 
  void reRun()
  {
    dataReadList=UploadList;
    UploadList.clear;
    setState(() {
      isfileOpened=true;
    });
  }

  List<List<dynamic>> receivedData=[];

  List<List<String>> dataReadList = [];

   List<List<String>> UploadList = [];

   static String tableName='';

   List showList=[];







  var isloading = true;
  var isfileOpened = false;

 

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(drawer: const appDrawer() ,
      appBar: AppBar(title: const Text('Product List'), actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){
            setState(() {
              UploadList.clear();
              dataReadList.clear();
              isfileOpened=false;
            });
          }, icon: const Icon(Icons.refresh)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: IconButton(
              iconSize: 30,
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform
                    .pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                  allowMultiple: false,
                )
                    .then((value) {
                  if (value != null) {
                    var file = value.files.single.bytes;
                    var excel = Excel.decodeBytes(value.files.single.bytes!);
                 
                    for (var table in excel.tables.keys) {
                      tableName=excel.tables[table]!.sheetName;
                      print(excel.tables[table]!.maxCols)
                       if(excel.tables[table]!.maxCols>8)
                      {
                         showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                              const Text('Failed to upload the file'),
                                          content: const Text('data column should be equal To Eight'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                setState(() {
                                                  isfileOpened=false;
                                                });
                                              
                                              },
                                              child: const Text('ok'),
                                            )
                                          ],
                                        ),
                                      );

                      }else if(excel.tables[table]!.maxCols<8)
                      {
                         showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                              const Text('Failed to Display the File'),
                                          content: const Text('data column should be equal To Eight'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                setState(() {
                                                  isfileOpened=false;
                                                });
                                              
                                              },
                                              child: const Text('ok'),
                                            )
                                          ],
                                        ),
                                      );

                      }
                  
                      for (var row in excel.tables[table]!.rows) {
                       
                            UploadList.add(row.map((e)=>e!.value.toString() ).toList())
                            
                      }

                     
                    }

                 
                    //use remove at function to remove the first row 
                    UploadList.removeAt(0);
                    setState(() {
                      dataReadList=UploadList;
                      isfileOpened=true;
                      
                    });
                    

                  }
                },);
              },
              icon: const Icon(Icons.add)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(onPressed: (){
            try {
                          Provider.of<ExcelData>(context,listen:false).sendData(UploadList,_MyHomeState.tableName).then((value) {
                            if(value==201)
                            {
            
                                showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Success'),
                                          content: const Text('Uploaded the File'),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                               
                                                Navigator.of(ctx).pop();
                                                 reRun();
                                              },
                                              child: const Text('ok'),
                                            )
                                          ],
                                        ),
                                      );
                        
                            }
                            else{
                              showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                              const Text('Failed to upload the file'),
                                          content: const Text('Something Went Wrong'),
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
                      } catch (e) {
                        showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                              const Text('Failed to upload the file'),
                                          content: const Text('Something Went Wrong'),
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
          }, icon:const Icon(Icons.upload) ),
        )
      ]),
      body: isfileOpened == false
          ? const Center(child: Text('Choose Excel File to display'))
          : ListView(
            children:[ 
              FittedBox(
              fit: BoxFit.cover,
              child: DataTable(columns: const <DataColumn>[
                
                DataColumn(label: Text('Product name')),
                DataColumn(label: Text('Batch Number')),
                 DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Mrp')),
                   DataColumn(label: Text('Expiry Date')),
                    DataColumn(label: Text('Vendor Name')),
                     DataColumn(label: Text('Margin')),
                      DataColumn(label: Text('Months To Expiry')),
                      
              ], rows: <DataRow>[
                for(var data in dataReadList)
               
                DataRow(cells: <DataCell>[
                   for(var data in data)
                 
                  DataCell(Text(data))
                ],)
              ],),
            ),
            
            ],
          ),
     
    );
    
  }
}
class appDrawer extends StatelessWidget {
  const appDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: Center(child: Text('Welcome',style: TextStyle(fontSize: 30),),),),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
            Navigator.of(context).pushNamed(SalesReport.routeName);

          }, child: const Text('SalesReport'),),
           const SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
             Navigator.of(context)
                              .pushNamed(FilterScreen.routeName);
            // Navigator.of(context).pushNamed(ExpiryBasedOnMonth.routeName);

          }, child: const Text('Filter Screen Based Expiry Month'),),
           const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
            Navigator.of(context).pushNamed(TotalSales.routeName);
            

          }, child: const Text('Total Sales'),), 
        ],
      ),
      
      
    );
  }
}
