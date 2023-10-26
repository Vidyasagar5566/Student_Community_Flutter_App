import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Calender_date_event.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Activities/Models.dart';
//import 'package:intl/intl.dart';

List<String> all_dates = [];

List<String> timetable_list = [
  "Upcoming Events",
  "Today Time Table"
/*  "CS",
  "EC",
  "EE",
  "ME",
  "CE",
  "CH",
  "BT",
  "EP",
  "MT",
  "AR"  */
];
List<Tab> get_tabs() {
  List<Tab> tabs = [];
  for (int i = 0; i < timetable_list.length; i++) {
    tabs.add(
      Tab(
        child: Container(
          padding: EdgeInsets.all(6),
          child: Text(
            timetable_list[i],
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
  return tabs;
}

Map<int, String> weeks = {
  1: 'MON',
  2: 'TUE',
  3: 'WED',
  4: 'THU',
  5: 'FRI',
  6: 'SAT',
  7: 'SUN'
};

class calender extends StatefulWidget {
  Username app_user;
  String domain;
  calender(this.app_user, this.domain);

  @override
  State<calender> createState() => _calenderState();
}

class _calenderState extends State<calender> {
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: calendar_servers().get_cal_list(widget.domain),
      builder: (ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            all_dates = snapshot.data;
            return calenderwidget1(widget.app_user, widget.domain);
          }
        }
        print(widget.domain);
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

DateTime today = DateTime.now();

class calenderwidget1 extends StatefulWidget {
  Username app_user;
  String domain;
  calenderwidget1(this.app_user, this.domain);

  @override
  State<calenderwidget1> createState() => _calenderwidget1State();
}

class _calenderwidget1State extends State<calenderwidget1> {
  String week_day = "SUN";
  CalendarFormat _calenderFormat = CalendarFormat.twoWeeks;

  void on_selected(DateTime day, DateTime focusday) {
    setState(() {
      today = day;
      String week_day = weeks[day.weekday].toString();
    });
  }

  List<String> day_events(DateTime day1) {
    for (int i = 0; i < all_dates.length; i++) {
      if (all_dates[i].split(' ')[0] == day1.toString().split(" ")[0]) {
        return ['e'];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 10,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TableCalendar(
                    rowHeight: 35,
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    startingDayOfWeek: StartingDayOfWeek.monday, //{
                    // return widget.all_dates.contains(day);
                    //}, //
                    calendarFormat: _calenderFormat,
                    onFormatChanged: (format) {
                      if (_calenderFormat != format) {
                        setState(() {
                          _calenderFormat = format;
                        });
                      }
                    },
                    focusedDay: today,
                    firstDay: DateTime.utc(2010, 10, 6),
                    lastDay: DateTime(2030, 10, 6),
                    onDaySelected: on_selected,
                    eventLoader: (day1) => day_events(day1),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                      markerSize: 10,
                      markerDecoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: 55,
                child: AppBar(
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      unselectedLabelColor: Colors.blueAccent,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.blueAccent),
                      tabs: get_tabs(),
                    ))),
            Expanded(
                child: TabBarView(
                    children: //get_tabcontents(widget.timetable_list, today)
                        [
                  allEvents(today.toString().split(" ")[0], widget.app_user,
                      widget.domain),
                  dailyTimeTable(
                      today.toString().split(" ")[0], widget.app_user),
                  /*           branch_display(
                      widget.timetable_list, widget.app_user, week_day, "CS"),
                 branch_display(
                      widget.timetable_list, widget.app_user, week_day, "EC"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "EE"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "ME"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "CE"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "CH"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "BT"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "EP"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "MT"),
                  branch_display(
                      widget.timetable_list, widget.app_user, week_day, "AR"),    */
                ]))
          ],
        ));
  }
}

List<String> filter_all_dates = [];
void event_filter_from_today(String selected_day) {
  filter_all_dates = [];
  int int_today = int.parse(selected_day.split('-')[0] +
      selected_day.split('-')[1] +
      selected_day.split('-')[2]);
  for (int i = 0; i < all_dates.length; i++) {
    String date = all_dates[i].split(' ')[0];
    int int_date =
        int.parse(date.split('-')[0] + date.split('-')[1] + date.split('-')[2]);
    if (int_today <= int_date) {
      filter_all_dates.add(all_dates[i]);
    }
  }
}

Map<String, String> months = {
  '01': "JAN",
  '02': "FEB",
  '03': "MAR",
  '04': "APRL",
  '05': "MAY",
  '06': "JUNE",
  '07': "JULY",
  '08': "AUG",
  '09': "SEP",
  '10': "OCT",
  '11': "NOV",
  '12': "DEC",
};

class allEvents extends StatefulWidget {
  String selected_today;
  Username app_user;
  String domain;
  allEvents(this.selected_today, this.app_user, this.domain);

  @override
  State<allEvents> createState() => _allEventsState();
}

class _allEventsState extends State<allEvents> {
  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    event_filter_from_today(widget.selected_today);
    return filter_all_dates.length == 0
        ? Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    //image: post.post_pic,
                    image: AssetImage("images/background.jpg"),
                    fit: BoxFit.cover)),
            child: const Center(
              child: Text("Not found any Events",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          )
        : SingleChildScrollView(
            child: ListView.builder(
                itemCount: filter_all_dates.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  String temp = filter_all_dates[index].split(' ')[0];
                  String new_date = temp.split('-')[2] +
                      ' - ' +
                      months[temp.split('-')[1]].toString() +
                      ' ' +
                      temp.split('-')[0];
                  return GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                                contentPadding: EdgeInsets.all(15),
                                content: Container(
                                  margin: EdgeInsets.all(10),
                                  child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Please wait"),
                                        CircularProgressIndicator()
                                      ]),
                                ));
                          });
                      Map<List<CALENDER_EVENT>, List<EVENT_LIST>> total_data =
                          await calendar_servers()
                              .get_calender_event_list(temp, widget.domain);
                      Navigator.pop(context);
                      List<CALENDER_EVENT> cal_event_data =
                          total_data.keys.toList()[0];
                      List<EVENT_LIST> activity_data =
                          total_data.values.toList()[0];

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              calender_events_display(widget.app_user,
                                  cal_event_data, activity_data, temp)));
                    },
                    child: Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              spreadRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.alarm,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                    new_date +
                                        ' ,  ' +
                                        filter_all_dates[index]
                                            .split(' ')[1]
                                            .substring(0, 5),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Row(children: [
                                const Icon(Icons.event_note),
                                const SizedBox(width: 20),
                                Container(
                                  width: wid / 1.7,
                                  child: Text(
                                      filter_all_dates[index].split('&&')[1],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                )
                              ]))
                        ])),
                  );
                }));
  }
}

Map<int, String> timings = {
  0: "8AM - 9AM",
  1: "9AM - 10AM",
  2: "10AM - 11AM",
  3: "11AM - 12PM",
  4: "12PM - 1PM",
  5: "1PM - 2PM",
  6: "2PM - 3PM",
  7: "3PM - 4PM",
  8: "4PM - 5PM",
  9: "5PM - 6PM",
  10: "6PM - 7PM"
};

class dailyTimeTable extends StatefulWidget {
  String selected_today;
  Username app_user;
  dailyTimeTable(this.selected_today, this.app_user);

  @override
  State<dailyTimeTable> createState() => _dailyTimeTableState();
}

class _dailyTimeTableState extends State<dailyTimeTable> {
  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    event_filter_from_today(widget.selected_today);
    return filter_all_dates.length == 0
        ? Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    //image: post.post_pic,
                    image: AssetImage("images/background.jpg"),
                    fit: BoxFit.cover)),
            child: const Center(
              child: Text("Not found any Events",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          )
        : Container(
            padding: EdgeInsets.only(top: 30),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    //image: post.post_pic,
                    image: AssetImage("images/event background.jpg"),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
                child: ListView.builder(
                    itemCount: 11,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 10),
                    itemBuilder: (BuildContext context, int index) {
                      String temp = widget.selected_today;
                      String new_date = temp.split('-')[2] +
                          ' - ' +
                          months[temp.split('-')[1]].toString();

                      return GestureDetector(
                        onTap: () async {},
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.alarm,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(timings[index]! + " : " + new_date,
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(children: [
                                    const Icon(Icons.event_note),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: wid / 1.7,
                                      child: const Text("Not Updated",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    )
                                  ]))
                            ])),
                      );
                    })));
  }
}










/*


class SwitchListTileExample extends StatefulWidget {
  String notif_id;
  Username app_user;
  String title;
  SwitchListTileExample(this.notif_id, this.app_user, this.title);

  @override
  State<SwitchListTileExample> createState() => _SwitchListTileExampleState();
}

class _SwitchListTileExampleState extends State<SwitchListTileExample> {
  @override
  Widget build(BuildContext context) {
    List<String> notif_ids = widget.app_user.notifIds!.split("@");
    bool _lights = false;
    for (int i = 0; i < notif_ids.length; i++) {
      if (notif_ids[i] == widget.notif_id) {
        _lights = true;
        notif_ids.remove(widget.notif_id);
        notif_ids.add(widget.notif_id);
        break;
      }
    }
    return SwitchListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.w200),
      ),
      activeColor: Colors.blue,
      value: _lights,
      onChanged: (bool value) async {
        setState(() {
          _lights = !_lights;
        });
        if (_lights) {
          setState(() {
            notif_ids.add(widget.notif_id);
            widget.app_user.notifIds = notif_ids.join("@");
          });
          await calendar_servers()
              .edit_timetable_subscription(widget.app_user.notifIds!);
        } else {
          setState(() {
            notif_ids.remove(widget.notif_id);
            widget.app_user.notifIds = notif_ids.join("@");
          });
          await calendar_servers()
              .edit_timetable_subscription(widget.app_user.notifIds!);
        }
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}



class year_display extends StatefulWidget {
  Username app_user;
  List<TIMETABLE_LIST> timetable_list;
  String day;
  String branch1;
  int year;
  year_display(
      this.app_user, this.timetable_list, this.day, this.branch1, this.year);

  @override
  State<year_display> createState() => _year_displayState();
}

class _year_displayState extends State<year_display> {
  @override
  Widget build(BuildContext context) {
    String week_day = widget.day;
    List<TIMETABLE_LIST> timetable_list = widget.timetable_list;
    var branch_list;
    for (int i = 0; i < timetable_list.length; i++) {
      TIMETABLE_LIST a = timetable_list[i];
      if (a.branch == widget.branch1 + widget.year.toString()) {
        branch_list = a;
        break;
      }
    }
    String day_menu = "";
    if (week_day == "SUN")
      day_menu = branch_list.sun!;
    else if (week_day == "MON")
      day_menu = branch_list.mon!;
    else if (week_day == "TUE")
      day_menu = branch_list.tue!;
    else if (week_day == "WED")
      day_menu = branch_list.wed!;
    else if (week_day == "THU")
      day_menu = branch_list.thu!;
    else if (week_day == "FRI")
      day_menu = branch_list.fri!;
    else if (week_day == "SAT") day_menu = branch_list.sat!;
    var height = MediaQuery.of(context).size.height;
    return widget.year != 5
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              title: const Text(
                "NIT CALICUT",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white70,
            ),
            body: Container(
                /*                decoration: const BoxDecoration(
                   image: DecorationImage(
                        //image: post.post_pic,
                        image: AssetImage("images/event background.jpg"),
                        fit: BoxFit.cover)),*/
                color: Colors.indigo,
                height: height,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 10),
                        itemBuilder: (BuildContext context, int index) {
                          List<String> batch_table = day_menu.split("@");
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Timetables(
                                      widget.app_user,
                                      batch_table[index],
                                      widget.day,
                                      widget.branch1,
                                      widget.year,
                                      batch_table,
                                      index)));
                            },
                            child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "batch " + (index + 1).toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "branch",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            widget.branch1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Year",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            widget.year.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )
                                        ]),
                                    const Divider(
                                      color: Colors.grey,
                                      height: 25,
                                      thickness: 2,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                    SwitchListTileExample(
                                        widget.branch1 +
                                            widget.year.toString() +
                                            "b" +
                                            (index + 1).toString(),
                                        widget.app_user,
                                        "Subscribe to get notify")
                                  ],
                                )),
                          );
                        }),
                  ],
                ))))
        : Timetables(widget.app_user, day_menu, widget.day, widget.branch1,
            widget.year, day_menu.split("@"), 0);
  }
}

class Timetables extends StatefulWidget {
  Username app_user;
  String batch_list;
  String day;
  String branch1;
  int year;
  List<String> batch_table;
  int index;
  Timetables(this.app_user, this.batch_list, this.day, this.branch1, this.year,
      this.batch_table, this.index);

  @override
  State<Timetables> createState() => _TimetablesState();
}

class _TimetablesState extends State<Timetables> {
  @override
  Widget build(BuildContext context) {
    List<String> class_slots = widget.batch_list.split('#');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "NIT CALICUT",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
      ),
      body: Container(
          width: width,
          color: Colors.indigo,
          child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: class_slots.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  List<String> class_slot_division =
                      class_slots[index].split('&');
                  return Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(class_slot_division[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              contentPadding: EdgeInsets.all(0),
                                              content: SingleChildScrollView(
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Center(
                                                                child: Text(
                                                                    "Edit the Class Slot?",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold))),
                                                            const SizedBox(
                                                                height: 10),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(30),
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  98, 150, 228),
                                                              child: OutlinedButton(
                                                                  onPressed: () async {
                                                                    if (widget
                                                                            .app_user
                                                                            .isFaculty ==
                                                                        true) {
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (BuildContext context) => edit_timetable(
                                                                              class_slot_division,
                                                                              widget.day,
                                                                              widget.branch1,
                                                                              widget.year,
                                                                              widget.app_user,
                                                                              class_slots,
                                                                              index,
                                                                              widget.batch_table,
                                                                              widget.index)));
                                                                    }
                                                                  },
                                                                  child: const Center(
                                                                      child: Text(
                                                                    "Edit",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ))),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            widget.year == 5
                                                                ? SwitchListTileExample(
                                                                    widget.branch1 +
                                                                        widget
                                                                            .year
                                                                            .toString() +
                                                                        "e" +
                                                                        index
                                                                            .toString(),
                                                                    widget
                                                                        .app_user,
                                                                    "Subscribe to get notify")
                                                                : Container(),
                                                          ]))));
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    size: 30,
                                  ))
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 25,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Container(
                            child: ListView.builder(
                                itemCount: class_slot_division.length - 1,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 10),
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  Map<int, String> sub_details = {
                                    0: "Faculty: ",
                                    1: "Time Slot: ",
                                    2: "Place: ",
                                    3: "Class status: "
                                  };
                                  return Container(
                                    margin: EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          sub_details[index1]!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            class_slot_division[index1 + 1],
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ));
                }),
          )),
    );
  }
}

class edit_timetable extends StatefulWidget {
  List<String> class_slot_division;
  String day;
  String branch;
  int year;
  Username app_user;
  List<String> class_slot;
  int index;
  List<String> batch_table;
  int index2;
  edit_timetable(
      this.class_slot_division,
      this.day,
      this.branch,
      this.year,
      this.app_user,
      this.class_slot,
      this.index,
      this.batch_table,
      this.index2);

  @override
  State<edit_timetable> createState() => _edit_timetableState();
}

class _edit_timetableState extends State<edit_timetable> {
  var day_timetable;
  bool _lights = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            "NIT CALICUT",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Update you branch timetable",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                    child: Column(
                  children: [
                    Container(
                        child: ListView.builder(
                            itemCount: widget.class_slot_division.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 10),
                            itemBuilder: (BuildContext context, int index) {
                              Map<int, String> sub_details = {
                                0: "Subject name",
                                1: "Time Slot: ",
                                2: "Faculty: ",
                                3: "Place: ",
                                4: "Class status: "
                              };
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: TextFormField(
                                  initialValue:
                                      widget.class_slot_division[index],
                                  keyboardType: TextInputType.multiline,
                                  minLines:
                                      2, //Normal textInputField will be displayed
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: sub_details[index],
                                    hintText: '8AM - 9AM  IE CLASS@......',
                                    prefixIcon: const Icon(Icons.text_fields),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      widget.class_slot_division[index] = value;
                                    });
                                  },
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? 'please enter password'
                                        : null;
                                  },
                                ),
                              );
                            })),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text(
                        "Send notification",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      activeColor: Colors.blue,
                      value: _lights,
                      onChanged: (bool value) async {
                        setState(() {
                          _lights = !_lights;
                        });
                      },
                      secondary: const Icon(Icons.lightbulb_outline),
                    ),
                    const SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        margin: EdgeInsets.only(top: 40),
                        width: 270,
                        height: 60,
                        child: MaterialButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          minWidth: double.infinity,
                          onPressed: () async {
                            String class_slot_division =
                                widget.class_slot_division.join("&");
                            widget.class_slot[widget.index] =
                                class_slot_division;
                            widget.batch_table[widget.index2] =
                                widget.class_slot.join("#");
                            String day_timetable = widget.batch_table.join("@");

                            String notif_id = "";
                            if (widget.year == 5) {
                              String notif_id = widget.branch +
                                  widget.year.toString() +
                                  "e" +
                                  widget.index.toString();
                            } else {
                              String notif_id = widget.branch +
                                  widget.year.toString() +
                                  "b" +
                                  widget.index2.toString();
                            }

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      contentPadding: EdgeInsets.all(15),
                                      content: Container(
                                        margin: EdgeInsets.all(10),
                                        child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Please wait while uploading....."),
                                              SizedBox(height: 10),
                                              CircularProgressIndicator()
                                            ]),
                                      ));
                                });

                            /*               bool error = await servers().edit_timetable(
                                widget.branch + widget.year.toString(),
                                day_timetable,
                                widget.day,
                                class_slot_division,
                                notif_id,
                                _lights);

                            Navigator.pop(context);
                            if (!error) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return firstpage(1, widget.app_user);
                              }));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Failed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }   */
                          },
                          color: Colors.indigo[200],
                          textColor: Colors.black,
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ))
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}


*/

