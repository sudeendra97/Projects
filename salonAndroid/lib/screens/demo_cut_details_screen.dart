import 'package:flutter/material.dart';

class DemoCutDetails extends StatefulWidget {
  DemoCutDetails({Key? key}) : super(key: key);

  static const routeName = '/DemoCutDetails';

  @override
  _DemoCutDetailsState createState() => _DemoCutDetailsState();
}

class _DemoCutDetailsState extends State<DemoCutDetails> {
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.symmetric(horizontal: 30, vertical: 8);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 60;
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
                      child: Image.asset('assets/images/barberShopImage.jpg')),
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: const [Text('6/27/21,03:00 PM')],
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
                  children: const [
                    Text(
                      'Bo WieKnife',
                      style: TextStyle(fontSize: 18),
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
              Padding(
                padding: getPadding(),
                child: Row(
                  children: const [
                    Text('Treatment'),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Shampoo'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('\$5.00'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Hair-Cut'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('\$5.00'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Shave'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('\$5.00'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.horizontal_rule,
                      size: 50,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 8),
                    //   child: Text('\$5.00'),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('\$15.00'),
                    ),
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
                    Text('Photos',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Container(
                  width: width,
                  height: 250,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            width: width / 2 - 32,
                            height: 200,
                            child: Image.asset(
                              'assets/images/demoHairStyle1.jpg',
                              fit: BoxFit.fill,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                decoration: BoxDecoration(border: Border.all()),
                                width: width / 2 - 32,
                                height: 200 / 2 - 5,
                                child: Image.asset(
                                  'assets/images/demoHairStyle2.jpg',
                                  fit: BoxFit.fill,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all()),
                              width: width / 2 - 32,
                              height: 200 / 2 - 5,
                              child: Image.asset(
                                'assets/images/demoHairStyle3.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    Text('Rating',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star_border_purple500_outlined,
                          size: 60,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star_border,
                          size: 60,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star_border,
                          size: 60,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star_border,
                          size: 60,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star_border,
                          size: 60,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
