import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/providers/api_calls.dart';
import 'package:salon/providers/barber_details.dart';
import 'package:salon/screens/barber_shop_list_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  static const routeName = '/BookingPage';

  @override
  _BookingPageState createState() => _BookingPageState();
}

enum selectBarber {
  john,
  adam,
  maxy,
  michell,
  james,
  robert,
}
enum selectTime {
  pickTime,
  tenThirty,
  eleven,
  elevenThirty,
  twelThirty,
  oneThirty,
  threeThirty,
  fiveThirty,
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  selectBarber _selected = selectBarber.john;
  selectTime _selectedTime = selectTime.pickTime;
  var time = '';
  var barber = '';
  var token;
  var barberId;
  List barberList = [];
  var isloading = true;
  var barberName = '';

  List<PopupMenuEntry<Object>> list = [];

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    token = Provider.of<ApiCalls>(context, listen: false).token;
    barberId = BarberDetails.id;

    if (token != null) {
      Provider.of<ApiCalls>(context, listen: false)
          .getBarbersList(token, barberId)
          .then((value) {
        barberList = value['BarberNames'];
        print('this $barberList');
        for (int i = 0; i < barberList.length; i++) {
          list.add(
            PopupMenuItem(
                child: Text(barberList[i].toString()),
                value: barberList[i].toString()),
          );
        }
        reRun();
      });
    } else {
      Provider.of<ApiCalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          Provider.of<ApiCalls>(context, listen: false)
              .getBarbersList(token, barberId)
              .then((value) {
            barberList = value['BarberNames'];
            print('this $barberList');
            for (int i = 0; i < barberList.length; i++) {
              list.add(
                PopupMenuItem(
                    child: Text(barberList[i].toString()),
                    value: barberList[i].toString()),
              );
            }
            reRun();
          });
        }
      });
    }

    print(token);
    print(barberId);
  }

  // Text barberSelect() {
  //   if (_selected == selectBarber.john) {
  //     return const Text(
  //       'john',
  //       style: TextStyle(fontSize: 20),
  //     );
  //   } else if (_selected == selectBarber.adam) {
  //     return const Text(
  //       'adam',
  //       style: TextStyle(fontSize: 20),
  //     );
  //   } else if (_selected == selectBarber.james) {
  //     return const Text(
  //       'james',
  //       style: TextStyle(fontSize: 20),
  //     );
  //   } else {
  //     return const Text('');
  //   }
  // }

  // void setBarber() {
  //   if (_selected == selectBarber.john) {
  //     barber = 'john';
  //   } else if (_selected == selectBarber.adam) {
  //     barber = 'adam';
  //   } else if (_selected == selectBarber.james) {
  //     barber = 'james';
  //   }
  // }

  void setTime() {
    if (_selectedTime == selectTime.tenThirty) {
      time = '10:30 AM';
    } else if (_selectedTime == selectTime.elevenThirty) {
      time = '11:30 AM';
    } else if (_selectedTime == selectTime.twelThirty) {
      time = '12:30 PM';
    } else if (_selectedTime == selectTime.eleven) {
      time = '11:00 AM';
    } else if (_selectedTime == selectTime.oneThirty) {
      time = '1:30 PM';
    } else if (_selectedTime == selectTime.threeThirty) {
      time = '3:30 PM';
    } else if (_selectedTime == selectTime.fiveThirty) {
      time = '5:30 PM';
    }
  }

  Text timeSelect() {
    if (_selectedTime == selectTime.tenThirty) {
      return const Text(
        '10:30 AM',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selectedTime == selectTime.elevenThirty) {
      return const Text(
        '11:30 AM',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selectedTime == selectTime.twelThirty) {
      return const Text(
        '12:30 PM',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selectedTime == selectTime.eleven) {
      return const Text(
        '11:00 AM',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selectedTime == selectTime.oneThirty) {
      return const Text(
        '1:30 PM',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selectedTime == selectTime.threeThirty) {
      return const Text(
        '3:30 PM',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selectedTime == selectTime.fiveThirty) {
      return const Text(
        '5:30 PM',
        style: TextStyle(fontSize: 20),
      );
    } else {
      return const Text(
        'Pick Time',
        style: TextStyle(fontSize: 20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book'),
          backgroundColor: Colors.black,
        ),
        body: isloading == true
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        // Use `selectedDayPredicate` to determine which day is currently selected.
                        // If this returns true, then `day` will be marked as selected.

                        // Using `isSameDay` is recommended to disregard
                        // the time-part of compared DateTime objects.
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            print(selectedDay.toString());
                          });
                        }
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          // Call `setState()` when updating calendar format
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        // No need to call `setState()` here
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: barberName == ''
                            ? const Text(
                                'Select Barber',
                                style: TextStyle(fontSize: 20),
                              )
                            : Text(
                                barberName,
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                      PopupMenuButton(
                        child:
                            const Icon(Icons.arrow_drop_down_circle_outlined),
                        onSelected: (value) {
                          setState(() {
                            barberName = value.toString();
                            // setBarber();
                          });
                        },
                        itemBuilder: (context) => list,
                        // [
                        //       const PopupMenuItem(
                        //         child: Text('john'),
                        //         value: selectBarber.john,
                        //       ),
                        //       const PopupMenuItem(
                        //         child: Text('adam'),
                        //         value: selectBarber.adam,
                        //       ),
                        //       const PopupMenuItem(
                        //         child: Text('james'),
                        //         value: selectBarber.james,
                        //       ),
                        //     ]
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(
                        child: timeSelect(),
                      ),
                      PopupMenuButton(
                          child:
                              const Icon(Icons.arrow_drop_down_circle_outlined),
                          onSelected: (value) {
                            setState(() {
                              _selectedTime = value as selectTime;
                              setTime();
                            });
                          },
                          itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: Text('10:30 AM'),
                                  value: selectTime.tenThirty,
                                ),
                                const PopupMenuItem(
                                  child: Text('11:00 AM'),
                                  value: selectTime.eleven,
                                ),
                                const PopupMenuItem(
                                  child: Text('11:30 AM'),
                                  value: selectTime.elevenThirty,
                                ),
                                const PopupMenuItem(
                                  child: Text('12:30 PM'),
                                  value: selectTime.twelThirty,
                                ),
                                const PopupMenuItem(
                                  child: Text('1:30 PM'),
                                  value: selectTime.oneThirty,
                                ),
                                const PopupMenuItem(
                                  child: Text('03:30 PM'),
                                  value: selectTime.threeThirty,
                                ),
                                const PopupMenuItem(
                                  child: Text('05:30 PM'),
                                  value: selectTime.fiveThirty,
                                ),
                              ])
                    ],
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<ApiCalls>(context, listen: false)
                              .bookBarber({
                            'Barber_Name': barberName,
                            'Time': time,
                            'Selected_Date':
                                '${_selectedDay!.millisecondsSinceEpoch}',
                            'Shop_Id': barberId,
                          }, token).then((value) {
                            if (value == 201) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('Successfully booked'),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                                BarberShopList.routeName));
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
                                  title: const Text('Booking Failed'),
                                  content: const Text('Something went wrong'),
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
                        },
                        child: const Text('Book'),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                ],
              ));
  }
}
