import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'Uploads.dart';

DateTime today_day = DateTime.now();

List<Tab> tabs = const [
  Tab(
    child: Text(
      "SUN",
      style: TextStyle(color: Colors.black),
    ),
  ),
  Tab(
      child: Text(
    "MON",
    style: TextStyle(color: Colors.black),
  )),
  Tab(
    child: Text(
      "TUES",
      style: TextStyle(color: Colors.black),
    ),
  ),
  Tab(
    child: Text(
      "WED",
      style: TextStyle(color: Colors.black),
    ),
  ),
  Tab(
    child: Text(
      "THU",
      style: TextStyle(color: Colors.black),
    ),
  ),
  Tab(
    child: Text(
      "FRI",
      style: TextStyle(color: Colors.black),
    ),
  ),
  Tab(
    child: Text(
      "SAT",
      style: TextStyle(color: Colors.black),
    ),
  )
];

class Acadamic_timings extends StatefulWidget {
  final String day;
  Username app_user;
  List<ACADEMIC_LIST> academic_list;
  Acadamic_timings(this.day, this.app_user, this.academic_list);

  @override
  State<Acadamic_timings> createState() => _Acadamic_timingsState();
}

class _Acadamic_timingsState extends State<Acadamic_timings> {
  @override
  Widget build(BuildContext context) {
    List<ACADEMIC_LIST> academic_list = widget.academic_list;
    return widget.academic_list.isEmpty
        ? Container(
            margin: EdgeInsets.all(100),
            child: Center(child: Text("No Data Was Found")),
          )
        : Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    //image: post.post_pic,
                    image: AssetImage("images/event background.jpg"),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ListView.builder(
                        itemCount: academic_list.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 10),
                        itemBuilder: (BuildContext context, int index) {
                          ACADEMIC_LIST academic_menu = academic_list[index];
                          return _buildLoadingScreen(academic_menu);
                        }))));
  }

  Widget _buildLoadingScreen(ACADEMIC_LIST academic_menu) {
    String day_menu = "";
    if (widget.day == "SUN")
      day_menu = academic_menu.sun!;
    else if (widget.day == "MON")
      day_menu = academic_menu.mon!;
    else if (widget.day == "TUE")
      day_menu = academic_menu.tue!;
    else if (widget.day == "WED")
      day_menu = academic_menu.wed!;
    else if (widget.day == "THU")
      day_menu = academic_menu.thu!;
    else if (widget.day == "FRI")
      day_menu = academic_menu.fri!;
    else if (widget.day == "SAT") day_menu = academic_menu.sat!;

    List<String> academic_name_timings = day_menu.toString().split('@');
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                academic_menu.academic_name!,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              widget.app_user.clzSacsHead!
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return academic_create(
                            academic_menu.id!,
                            widget.app_user,
                            academic_menu.academic_name,
                            academic_menu.sun,
                            academic_menu.mon,
                            academic_menu.tue,
                            academic_menu.wed,
                            academic_menu.thu,
                            academic_menu.fri,
                            academic_menu.sat,
                          );
                        }));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ))
                  : Container()
            ]),
            ListView.builder(
                itemCount: academic_name_timings.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int idx) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(academic_name_timings[idx],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      )
                    ],
                  );
                })
          ],
        ));
  }
}

List<Widget> tabscontent1(
    List<ACADEMIC_LIST> academic_list, Username app_user) {
  List<Widget> tabscontent1 = [
    Acadamic_timings(
      "SUN",
      app_user,
      academic_list,
    ),
    Acadamic_timings("MON", app_user, academic_list),
    Acadamic_timings("TUE", app_user, academic_list),
    Acadamic_timings("WED", app_user, academic_list),
    Acadamic_timings("THU", app_user, academic_list),
    Acadamic_timings("FRI", app_user, academic_list),
    Acadamic_timings("SAT", app_user, academic_list),
  ];
  return tabscontent1;
}

class AcademicTimings extends StatefulWidget {
  String domain;
  Username app_user;
  AcademicTimings(this.domain, this.app_user);

  @override
  State<AcademicTimings> createState() => _AcademicTimingsState();
}

class _AcademicTimingsState extends State<AcademicTimings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: today_day.weekday,
      length: 8,
      child: Scaffold(
          appBar: AppBar(
              leading: const BackButton(
                color: Colors.blue, // <-- SEE HERE
              ),
              centerTitle: false,
              title: const Text(
                "Timings",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                DropdownButton<String>(
                    value: widget.domain,
                    underline: Container(),
                    elevation: 0,
                    items: domains_list
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.domain = value!;
                      });
                    })
              ],
              backgroundColor: Colors.white70,
              bottom: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Creates border
                    color: Colors.grey),
                indicatorColor: Colors.grey,
                isScrollable: true,
                labelColor: Colors.black,
                tabs: tabs,
              )),
          body: FutureBuilder<List<ACADEMIC_LIST>>(
            future:
                timings_servers().get_academic_list(domains1[widget.domain]!),
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
                  List<ACADEMIC_LIST> academic_list = snapshot.data;
                  return _buildListView(academic_list);
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          floatingActionButton: widget.app_user.clzSacsHead!
              ? FloatingActionButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return academic_create(
                          0, widget.app_user, '', '', '', '', '', '', '', '');
                    }));
                  },
                  tooltip: 'wann share',
                  elevation: 4.0,
                  child: const Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                )
              : Container()),
    );
  }

  Widget _buildListView(List<ACADEMIC_LIST> academic_list) {
    return Container(
        child:
            TabBarView(children: tabscontent1(academic_list, widget.app_user)));
  }
}
