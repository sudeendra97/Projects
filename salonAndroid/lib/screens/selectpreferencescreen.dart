// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/screens/payment_screen.dart';

class SelectPreferenceScreen extends StatefulWidget {
  SelectPreferenceScreen({Key? key}) : super(key: key);
  static const routeName = '/SelectPreferenceScreen';

  @override
  _SelectPreferenceScreenState createState() => _SelectPreferenceScreenState();
}

class _SelectPreferenceScreenState extends State<SelectPreferenceScreen> {
  static var selected = false;
  static var hairStyle = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  //   selected = false;
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selected = false;
  }

  List shortHairListNames = [
    'Classic-Crew-Cut-Taper-Fade',
    'Classic-Side-Part-Fade',
    'High-Razor-Fade-with-Textured-Crop',
    'High-Undercut-Fade',
    'Short-Curly-Hair-Fade-Haircut',
    'Cropped-Top-Fade',
    'Undercut-with-Short-Brushed-Back',
  ];
  List mediumHairListNames = [
    'Blowout-Taper',
    'Comb-Over-Fade',
    'Fringe-Hairstyles-Men',
    'Hard-Side-Part',
    'Long-Crop-Top-Fade',
    'Modern-Quiff-Fade',
    'Slicked-Back-Hair',
    'Textured-Pompadour-Fade-Undercut',
  ];
  List longHairListNames = [
    'Half-Up-Half-Down',
    'Long-Braids',
    'Long-Dreadlocks',
    'Long-Hair-Undercut',
    'Man-Bun',
  ];
  List shortHairList = [
    Image.asset('assets/images/shortHairs/Classic-Crew-Cut-Taper-Fade.jpg'),
    Image.asset('assets/images/shortHairs/Classic-Side-Part-Fade.jpg'),
    Image.asset(
        'assets/images/shortHairs/High-Razor-Fade-with-Textured-Crop-1.jpg'),
    Image.asset(
        'assets/images/shortHairs/High-Undercut-Fade-with-Textured-Slicked-Back-Hair.jpg'),
    Image.asset(
        'assets/images/shortHairs/Short-Curly-Hair-Fade-Haircut-For-Men.jpg'),
    Image.asset('assets/images/shortHairs/Cropped-Top-Fade.jpg'),
    Image.asset(
        'assets/images/shortHairs/Undercut-with-Short-Brushed-Back-Hair.jpg'),
  ];
  List mediumHairStyles = [
    Image.asset('assets/images/mediumHairs/Blowout-Taper.jpg'),
    Image.asset('assets/images/mediumHairs/Comb-Over-Fade.jpg'),
    Image.asset('assets/images/mediumHairs/Fringe-Hairstyles-Men.jpg'),
    Image.asset('assets/images/mediumHairs/Hard-Side-Part.jpg'),
    Image.asset('assets/images/mediumHairs/Long-Crop-Top-Fade.jpg'),
    Image.asset('assets/images/mediumHairs/Modern-Quiff-Fade.jpg'),
    Image.asset('assets/images/mediumHairs/Slicked-Back-Hair.jpg'),
    Image.asset(
        'assets/images/mediumHairs/Textured-Modern-Pompadour-Fade-Undercut.jpg'),
  ];

  List longHairStyles = [
    Image.asset(
        'assets/images/longHairs/Half-Up-Half-Down-Hairstyle-For-Men.jpg'),
    Image.asset('assets/images/longHairs/Long-Braids.jpg'),
    Image.asset('assets/images/longHairs/Long-Dreadlocks.jpg'),
    Image.asset('assets/images/longHairs/Long-Hair-Undercut.jpg'),
    Image.asset('assets/images/longHairs/Man-Bun.jpg'),
  ];
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: Colors.black,
          )))
        : SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              body: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 25),
                child: ListView(
                  children: [
                    const Text(
                      'Select Your Preference',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Hair Styles',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '1 out of 3',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: const [
                              Text('Short Hair Styles'),
                            ],
                          ),
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shortHairList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ShortHairListData(
                                shortHairList: shortHairList,
                                shortHairListNames: shortHairListNames,
                                index: index,
                                key: UniqueKey(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, top: 8),
                          child: Row(
                            children: const [
                              Text('Medium Hair Styles'),
                            ],
                          ),
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: mediumHairStyles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MediumHairListData(
                                mediumHairStyles: mediumHairStyles,
                                mediumHairListNames: mediumHairListNames,
                                index: index,
                                key: UniqueKey(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, top: 8),
                          child: Row(
                            children: const [
                              Text('Long Hair Styles'),
                            ],
                          ),
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            //addAutomaticKeepAlives: false,

                            scrollDirection: Axis.horizontal,
                            itemCount: longHairStyles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return LongHairListData(
                                longHairStyles: longHairStyles,
                                longHairListNames: longHairListNames,
                                index: index,
                                key: UniqueKey(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 50,
                      width: 50,
                      child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded)),
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        // decoration:
                        //     BoxDecoration(borderRadius: BorderRadius.circular(20)),
                        height: 50,
                        width: 200,
                        child: Builder(builder: (contextData) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            onPressed: () {
                              if (hairStyle == '') {
                                Scaffold.of(contextData).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please Select the Hair Style First',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isloading = true;
                                });
                                Provider.of<ApiCalls>(context, listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  if (value == true) {
                                    var token = Provider.of<ApiCalls>(context,
                                            listen: false)
                                        .token;
                                    Provider.of<ApiCalls>(context,
                                            listen: false)
                                        .setHairStylePreference(
                                            hairStyle, token)
                                        .then((value) {
                                      if (value == 200 || value == 201) {
                                        setState(() {
                                          isloading = false;
                                        });
                                        // Scaffold.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //     content: Text(
                                        //       'Successfully Added your hairStyle Preference',
                                        //     ),
                                        //     duration: Duration(seconds: 2),
                                        //   ),
                                        // );
                                        Navigator.of(context).pushNamed(
                                          PaymentScreen.routeName,
                                        );
                                      } else {
                                        setState(() {
                                          isloading = false;
                                        });
                                        Scaffold.of(contextData).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Something Went Wrong Please Try Again',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                });
                              }
                              // if (isbarber == true) {
                              //   business = 'BarberShop';
                              // } else {
                              //   business = 'Salon';
                              // }
                              // Navigator.of(context).pushNamed(
                              //     BusinessSignUpFlow10.routeName,
                              //     arguments: business);
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(fontSize: 25),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class LongHairListData extends StatefulWidget {
  const LongHairListData({
    Key? key,
    required this.longHairStyles,
    required this.longHairListNames,
    required this.index,
  }) : super(key: key);

  final List longHairStyles;
  final List longHairListNames;
  final int index;

  @override
  State<LongHairListData> createState() => _LongHairListDataState();
}

class _LongHairListDataState extends State<LongHairListData>
    with AutomaticKeepAliveClientMixin {
  double elevation = 5;
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (elevation == 50) {
            elevation = 5;
            color = Colors.white;
            _SelectPreferenceScreenState.selected = false;
            _SelectPreferenceScreenState.hairStyle = '';
          } else if (elevation == 5 &&
              _SelectPreferenceScreenState.selected == false) {
            elevation = 50;
            color = Colors.redAccent;
            _SelectPreferenceScreenState.selected = true;
            _SelectPreferenceScreenState.hairStyle =
                widget.longHairListNames[widget.index].toString();
            print(_SelectPreferenceScreenState.hairStyle);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: elevation,
          shadowColor: color,
          child: Stack(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: widget.longHairStyles[widget.index],
                  ),
                ),
                Text(widget.longHairListNames[widget.index]),
              ],
            ),
            elevation != 5
                ? Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    child: Icon(
                      Icons.check_circle_outline_sharp,
                      color: Colors.grey.shade300,
                      size: 100,
                    ))
                : const SizedBox(),
          ]),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MediumHairListData extends StatefulWidget {
  const MediumHairListData({
    Key? key,
    required this.mediumHairStyles,
    required this.mediumHairListNames,
    required this.index,
  }) : super(key: key);

  final List mediumHairStyles;
  final List mediumHairListNames;
  final int index;

  @override
  State<MediumHairListData> createState() => _MediumHairListDataState();
}

class _MediumHairListDataState extends State<MediumHairListData>
    with AutomaticKeepAliveClientMixin {
  double elevation = 5;
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (elevation == 50) {
            elevation = 5;
            color = Colors.white;
            _SelectPreferenceScreenState.selected = false;
            _SelectPreferenceScreenState.hairStyle = '';
          } else if (elevation == 5 &&
              _SelectPreferenceScreenState.selected == false) {
            elevation = 50;
            color = Colors.blueGrey;
            _SelectPreferenceScreenState.selected = true;
            _SelectPreferenceScreenState.hairStyle =
                widget.mediumHairListNames[widget.index].toString();
            print(_SelectPreferenceScreenState.hairStyle);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: elevation,
          shadowColor: color,
          child: Stack(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: widget.mediumHairStyles[widget.index],
                  ),
                ),
                Text(widget.mediumHairListNames[widget.index]),
              ],
            ),
            elevation != 5
                ? Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    child: Icon(
                      Icons.check_circle_outline_sharp,
                      color: Colors.grey.shade300,
                      size: 100,
                    ))
                : const SizedBox(),
          ]),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ShortHairListData extends StatefulWidget {
  const ShortHairListData({
    Key? key,
    required this.shortHairList,
    required this.shortHairListNames,
    required this.index,
  }) : super(key: key);

  final List shortHairList;
  final List shortHairListNames;
  final int index;

  @override
  State<ShortHairListData> createState() => _ShortHairListDataState();
}

class _ShortHairListDataState extends State<ShortHairListData>
    with AutomaticKeepAliveClientMixin {
  double elevation = 5;
  Color color = Colors.white;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (elevation == 50) {
            elevation = 5;
            color = Colors.white;
            _SelectPreferenceScreenState.selected = false;
            _SelectPreferenceScreenState.hairStyle = '';
          } else if (elevation == 5 &&
              _SelectPreferenceScreenState.selected == false) {
            elevation = 50;
            color = Colors.blueGrey;
            _SelectPreferenceScreenState.selected = true;
            _SelectPreferenceScreenState.hairStyle =
                widget.shortHairListNames[widget.index].toString();
            print(_SelectPreferenceScreenState.hairStyle);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: elevation,
          shadowColor: color,
          child: Stack(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: widget.shortHairList[widget.index],
                  ),
                ),
                FittedBox(
                    fit: BoxFit.contain,
                    child: Text(widget.shortHairListNames[widget.index])),
              ],
            ),
            elevation != 5
                ? Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    child: Icon(
                      Icons.check_circle_outline_sharp,
                      color: Colors.grey.shade300,
                      size: 100,
                    ))
                : const SizedBox(),
          ]),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
