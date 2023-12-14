import 'package:flutter/material.dart';

List<bool> _lights1 = [
  true,
  true,
  true,
  true,
  true,
];
List<bool> _lights2 = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
];

List<bool> _lights3 = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
];

Map<int, String> years = {
  0: "1st year",
  1: "2nd year",
  2: "3rd year",
  3: "4rth year",
  4: "5th year"
};
Map<int, String> branchs = {
  0: "CS",
  1: "EC",
  2: "EE",
  3: "ME",
  4: "CE",
  5: "CH",
  6: "BT",
  7: "AR",
  8: "MT",
  9: "EP",
  10: "PE",
  11: "Other"
};
Map<int, String> courses = {
  0: "B.Tech",
  1: "M.Tech",
  2: "PG",
  3: "Phd",
  4: "MBA",
  5: "Other",
  6: "B.Arch"
};

List<String> notif_years = "1,1,1,1,1".split(",");
List<String> notif_branchs =
    "CS,EC,EE,ME,CE,CH,BT,AR,MT,EP,PE,Other".split(',');
List<String> notif_courses = "B.Tech,M.Tech,PG,Phd,MBA,Other,B.Arch".split(",");

class switch1 extends StatefulWidget {
  int index1;
  switch1(this.index1);

  @override
  State<switch1> createState() => _switch1State();
}

class _switch1State extends State<switch1> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        years[widget.index1]!,
        style: const TextStyle(fontWeight: FontWeight.w200),
      ),
      activeColor: Colors.blue,
      value: _lights1[widget.index1],
      onChanged: (bool value) async {
        setState(() {
          _lights1[widget.index1] = !_lights1[widget.index1];
          if (notif_years[widget.index1] == "1") {
            notif_years[widget.index1] = "0";
          } else {
            notif_years[widget.index1] = "1";
          }
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}

class switch2 extends StatefulWidget {
  int index2;
  switch2(this.index2);

  @override
  State<switch2> createState() => _switch2State();
}

class _switch2State extends State<switch2> {
  @override
  Widget build(BuildContext context) {
    int index2 = widget.index2;
    return SwitchListTile(
      title: Text(
        branchs[index2]!,
        style: const TextStyle(fontWeight: FontWeight.w200),
      ),
      activeColor: Colors.blue,
      value: _lights2[index2],
      onChanged: (bool value) async {
        setState(() {
          _lights2[index2] = !_lights2[index2];
          if (notif_branchs.contains(branchs[index2])) {
            notif_branchs.remove(branchs[index2]);
          } else {
            notif_branchs.add(branchs[index2]!);
          }
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}

class switch3 extends StatefulWidget {
  int index3;
  switch3(this.index3);

  @override
  State<switch3> createState() => _switch3State();
}

class _switch3State extends State<switch3> {
  @override
  Widget build(BuildContext context) {
    int index3 = widget.index3;
    return SwitchListTile(
      title: Text(
        courses[index3]!,
        style: const TextStyle(fontWeight: FontWeight.w200),
      ),
      activeColor: Colors.blue,
      value: _lights3[index3],
      onChanged: (bool value) async {
        setState(() {
          _lights3[index3] = !_lights3[index3];
          if (notif_courses.contains(courses[index3])) {
            notif_courses.remove(courses[index3]);
          } else {
            notif_courses.add(courses[index3]!);
          }
        });
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}

class select_branch_year extends StatefulWidget {
  const select_branch_year({super.key});

  @override
  State<select_branch_year> createState() => _select_branch_yearState();
}

class _select_branch_yearState extends State<select_branch_year> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    //barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          content: SingleChildScrollView(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch1(0)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch1(1)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch1(2)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch1(3)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch1(4))
                            ],
                          )));
                    });
              },
              child: const Text(
                "Year",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    //barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          content: SingleChildScrollView(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(0)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(1)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(2)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(3)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(4)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(5)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(6)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(7)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(8)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(9)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(10)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch2(11)),
                            ],
                          )));
                    });
              },
              child: const Text(
                "branch",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    //barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          content: SingleChildScrollView(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(0)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(1)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(2)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(3)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(4)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(5)),
                              Container(
                                  padding: EdgeInsets.all(15),
                                  child: switch3(6))
                            ],
                          )));
                    });
              },
              child: const Text(
                "Courses",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
