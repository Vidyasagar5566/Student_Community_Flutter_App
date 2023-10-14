import 'package:flutter/material.dart';
//import 'package:testing_app/dataset.dart';
import 'Servers.dart';
import 'Models.dart';
import '/servers/servers.dart';

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

class all_mess_menu extends StatefulWidget {
  final String day;
  List<MESS_LIST> mess_list;
  all_mess_menu(this.day, this.mess_list);
  //const all_mess_menu({super.key});

  @override
  State<all_mess_menu> createState() => _all_mess_menuState();
}

class _all_mess_menuState extends State<all_mess_menu> {
  @override
  Widget build(BuildContext context) {
    List<MESS_LIST> mess_list = widget.mess_list;
    mess_list.reversed;
    return widget.mess_list.isEmpty
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
            child: ListView.builder(
                itemCount: mess_list.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  MESS_LIST hostel_menu = mess_list[index];
                  return _buildLoadingScreen(hostel_menu);
                }));
  }

  Widget _buildLoadingScreen(MESS_LIST hostel_menu) {
    String day_menu = "";
    if (widget.day == "SUN")
      day_menu = hostel_menu.sun!;
    else if (widget.day == "MON")
      day_menu = hostel_menu.mon!;
    else if (widget.day == "TUE")
      day_menu = hostel_menu.tue!;
    else if (widget.day == "WED")
      day_menu = hostel_menu.wed!;
    else if (widget.day == "THU")
      day_menu = hostel_menu.thu!;
    else if (widget.day == "FRI")
      day_menu = hostel_menu.fri!;
    else if (widget.day == "SAT") day_menu = hostel_menu.sat!;

    List<String> day_menu_lst = day_menu.toString().split('@');

    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              hostel_menu.hostel! + " hostel mess",
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: 300,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const Center(
                    child: Text(
                      "Breakfast",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[0],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[1],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  )
                ],
              )),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: 300,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const Center(
                    child: Text(
                      "Lunch",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[2],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[3],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: 300,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Center(
                    child: const Text(
                      "Snacks",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[4],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[5],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: 300,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Dinner",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[6],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(day_menu_lst[7],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}

List<Widget> tabscontent(List<MESS_LIST> mess_list) {
  List<Widget> tabscontent = [
    all_mess_menu("SUN", mess_list),
    all_mess_menu("MON", mess_list),
    all_mess_menu("TUE", mess_list),
    all_mess_menu("WED", mess_list),
    all_mess_menu("THU", mess_list),
    all_mess_menu("FRI", mess_list),
    all_mess_menu("SAT", mess_list),
  ];
  return tabscontent;
}

class messMenu extends StatefulWidget {
  String domain;
  messMenu(this.domain);

  @override
  State<messMenu> createState() => _messMenuState();
}

class _messMenuState extends State<messMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
            appBar: AppBar(
                leading: const BackButton(
                  color: Colors.blue, // <-- SEE HERE
                ),
                centerTitle: false,
                title: const Text("Mess Menu",
                    style: TextStyle(color: Colors.black)),
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
            body: FutureBuilder<List<MESS_LIST>>(
              future: mess_menu_servers().get_mess_list(domains1[widget.domain]!),
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
                    List<MESS_LIST> mess_list = snapshot.data;
                    return _buildListView(mess_list);
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }

  Widget _buildListView(List<MESS_LIST> mess_list) {
    return Container(child: TabBarView(children: tabscontent(mess_list)));
  }
}
