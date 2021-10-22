import 'package:flutter/material.dart';
import 'package:salon/screens/demo_cut_details_screen.dart';

class DemoProfileScreen extends StatefulWidget {
  DemoProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/DemoProfileScreen';

  @override
  _DemoProfileScreenState createState() => _DemoProfileScreenState();
}

class _DemoProfileScreenState extends State<DemoProfileScreen> {
  List shopList = [
    'Blue Chip HairCutters',
    'Rays Barber Shop',
    'Blue Chip HairCutters'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: const Text('Your Profile'),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 15.0),
      //       child: IconButton(
      //           onPressed: () {
      //             Navigator.of(context)
      //                 .pushNamed(EditCustomerProfileScreen.routeName);
      //           },
      //           icon: const Icon(Icons.edit)),
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Tooltip(
                        message: 'update Image',
                        child: GestureDetector(
                          onTap: () {
                            // getMultipleImageInfos().then((value) {});
                          },
                          child: Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(30)),
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/profileImage.jpg')),
                            ),
                            // child: Container(
                            //   alignment: Alignment.bottomCenter,
                            //   child: const Text(
                            //     'update Image',
                            //   ),
                            // )
                            // child: CircleAvatar(
                            //   backgroundImage: NetworkImage(image),
                            // ),
                            //  FittedBox(
                            //   fit: BoxFit.contain,
                            //   child:
                            //    CachedNetworkImage(
                            //       //  placeholder: (context, url) => const CircularProgressIndicator(),
                            //       imageUrl: image),
                            //   //  Image.memory(
                            //   //   Uint8List.fromList(
                            //   //       imageList[index].cast<int>().toList()),
                            //   // ),
                            // )
                          ),
                        ),
                      ),
                    ),
                    Builder(builder: (context) {
                      return TextButton(
                          onPressed: () {
                            Scaffold.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'This is Edit Page',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            // Navigator.of(context).pushNamed(
                            //     EditCustomerProfileScreen.routeName);
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ));
                    })
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'Hi, John',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text('You Have Not Visited Any Barbers Yet'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'About',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.'),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'Preferences',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'HairStyles:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
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
                                  height: 50,
                                  child: CircleAvatar(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'Length:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
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
                                  height: 50,
                                  child: CircleAvatar(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
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
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    'Facial Hair:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 30),
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
                                  height: 50,
                                  child: CircleAvatar(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Recents:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        )
                      ],
                    )
                  ],
                ),
                ListView.builder(
                  itemCount: shopList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(DemoCutDetails.routeName);
                            },
                            child: ListTile(
                              title: Text(shopList[index]),
                              trailing: IconButton(
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed(
                                    //     CustomerCutDetails.routeName,
                                    //     arguments: {
                                    //       'barberName':
                                    //           bookings[index]
                                    //               .barberName,
                                    //       'shopName': bookings[index]
                                    //           .shopName,
                                    //       'shopImage': bookings[index]
                                    //           .shopImage,
                                    //       'bookedDate':
                                    //           bookings[index]
                                    //               .selectedDate,
                                    //     });
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios)),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        )
                      ],
                    );
                  },
                ),
                // recentImageCuts.isEmpty
                //     ? const SizedBox()
                //     : const Padding(
                //         padding: EdgeInsets.only(top: 8.0, bottom: 8),
                //         child: Text('Your Recent Cuts',
                //             style: TextStyle(
                //                 fontSize: 25,
                //                 fontWeight: FontWeight.bold)),
                //       ),
                // Container(
                //   width: 600,
                //   height: 150,
                //   child: recentImageCuts.isEmpty
                //       ? const SizedBox()
                //       : ListView.builder(
                //           // shrinkWrap: true,
                //           scrollDirection: Axis.horizontal,
                //           itemCount: recentImageCuts.length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Container(
                //                   width: 200,
                //                   height: 150,
                //                   child: FittedBox(
                //                     fit: BoxFit.fill,
                //                     child: CachedNetworkImage(
                //                         //  placeholder: (context, url) => const CircularProgressIndicator(),
                //                         imageUrl: recentImageCuts[index]),
                //                     //  Image.memory(
                //                     //   Uint8List.fromList(
                //                     //       imageList[index].cast<int>().toList()),
                //                     // ),
                //                   )),
                //             );
                //           },
                //         ),
                // ),
                // Container(
                //   width: 600,
                //   height: 150,
                //   child: ListView.builder(
                //     // shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: imageList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //             width: 200,
                //             height: 150,
                //             child: FittedBox(
                //               fit: BoxFit.fill,
                //               child: Image.memory(
                //                 Uint8List.fromList(
                //                     imageList[index].cast<int>().toList()),
                //               ),
                //             )),
                //       );
                //     },
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),

                // imageList.isEmpty
                //     ? const SizedBox()
                //     : ElevatedButton(
                //         style: ButtonStyle(
                //           backgroundColor:
                //               MaterialStateProperty.all(Colors.black),
                //         ),
                //         onPressed: () async {
                //           List images = [];
                //           for (int i = 0; i < imageList.length; i++) {
                //             if (i == 4) {
                //               break;
                //             }
                //             images.add(imageList[i]);
                //           }
                //           Provider.of<ApiCalls>(context, listen: false)
                //               .uploadCuts(images, token, '124565')
                //               .then((value) {
                //             setState(() {
                //               imageList.clear();
                //               // recentImageCuts = value['Cut_Images'];
                //             });
                //           });
                //         },
                //         child: const Text('Upload'))
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(15.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ClipRRect(
      //         borderRadius: BorderRadius.circular(25),
      //         child: Container(
      //           // decoration:
      //           //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
      //           height: 50,
      //           width: 150,
      //           child: ElevatedButton(
      //             style: ButtonStyle(
      //               backgroundColor: MaterialStateProperty.all(Colors.black),
      //             ),
      //             onPressed: () {
      //               pickimages();
      //             },
      //             child: const Text(
      //               'Add Cuts',
      //               style: TextStyle(fontSize: 20),
      //             ),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         width: 30,
      //       ),
      //       ClipRRect(
      //         borderRadius: BorderRadius.circular(25),
      //         child: Container(
      //           // decoration:
      //           //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
      //           height: 50,
      //           width: 150,
      //           child: ElevatedButton(
      //             style: ButtonStyle(
      //               backgroundColor: MaterialStateProperty.all(Colors.black),
      //             ),
      //             onPressed: () {},
      //             child: const Text(
      //               'View History',
      //               style: TextStyle(fontSize: 20),
      //             ),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
