import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/first_page.dart';
import '/models/models.dart';
import '/servers/servers.dart';
import '../Circular_designs/circular indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import 'package:intl/intl.dart';
import 'package:testing_app/Side_menu_bar/switch.dart';

List<bool> _lights1 = [
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
  true
];
Map<int, String> years = {
  0: "1st year",
  1: "2nd year",
  2: "3rd year",
  3: "4rth year"
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
  10: "PE"
};
List<String> notif_years = "1,1,1,1".split(",");
List<String> notif_branchs = "CS,EC,EE,ME,CE,CH,BT,AR,MT,EP,PE".split(',');

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
          try {
            notif_branchs.remove(branchs[index2]);
          } catch (e) {
            notif_branchs.add(branchs[index2]!);
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
                                  child: switch1(3))
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
                            ],
                          )));
                    });
              },
              child: const Text(
                "branch",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}

