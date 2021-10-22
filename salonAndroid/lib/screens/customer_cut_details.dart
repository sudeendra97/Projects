import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerCutDetails extends StatefulWidget {
  CustomerCutDetails({Key? key}) : super(key: key);

  static const routeName = '/CustomerCutDetails';

  @override
  _CustomerCutDetailsState createState() => _CustomerCutDetailsState();
}

class _CustomerCutDetailsState extends State<CustomerCutDetails> {
  var barberName;
  var ShopImage;
  var dateTime;

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      barberName = data['barberName'];
      ShopImage = data['shopImage'];
      dateTime = data['bookedDate'];
    }

    super.didChangeDependencies();
  }

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.symmetric(horizontal: 30, vertical: 8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(children: const [
                  Text(
                    'Cut Details',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: CachedNetworkImage(imageUrl: ShopImage)),
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(dateTime),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: const Divider(
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: const [
                    Text('Your Barber',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: [
                    Text(
                      barberName,
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: const [Text('Style:')],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 50,
                                height: 30,
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/scissor.png',
                                        fit: BoxFit.contain),
                                  ),
                                  backgroundColor: Colors.white,
                                  // backgroundImage: AssetImage(
                                  //   'assets/images/scissor.png',
                                  // ),
                                )),
                            const Text(
                              'Short-High Fade',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 50,
                                height: 30,
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/trimmer.png',
                                        fit: BoxFit.contain),
                                  ),
                                  backgroundColor: Colors.white,
                                  // backgroundImage: AssetImage(
                                  //   'assets/images/scissor.png',
                                  // ),
                                )),
                            const Text(
                              'Number 3',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 50,
                                height: 30,
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Image.asset(
                                        'assets/images/beard.png',
                                        fit: BoxFit.contain),
                                  ),
                                  backgroundColor: Colors.white,
                                  // backgroundImage: AssetImage(
                                  //   'assets/images/scissor.png',
                                  // ),
                                )),
                            const Text(
                              'Clean Shaven Straight Razor',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
