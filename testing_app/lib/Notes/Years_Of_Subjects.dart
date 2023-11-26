import 'package:flutter/material.dart';
import '../Circular_designs/Cure_clip.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import 'Files_Of_Years.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

bool _lights = false;

class private_switch extends StatefulWidget {
  Username app_user;
  private_switch(this.app_user);

  @override
  State<private_switch> createState() => _private_switchState();
}

class _private_switchState extends State<private_switch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        "Make Private?",
        style: TextStyle(fontWeight: FontWeight.w200),
      ),
      activeColor: Colors.blue,
      value: _lights,
      onChanged: (bool value) {
        if (widget.app_user.isFaculty!) {
          setState(() {
            _lights = !_lights;
          });
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Students cannot create private sub topics",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }
}

class cal_sub_years extends StatefulWidget {
  Username app_user;
  CAL_SUB_NAMES cal_sub_name;
  List<CAL_SUB_YEARS> cal_sub_years_list;
  String branch;
  cal_sub_years(
      this.app_user, this.cal_sub_name, this.cal_sub_years_list, this.branch);

  @override
  State<cal_sub_years> createState() => _cal_sub_yearsState();
}

class _cal_sub_yearsState extends State<cal_sub_years> {
  var year_name;
  var loaded_data = false;
  List<CAL_SUB_YEARS> sub_years = [];

  void load_data_fun() async {
    List<CAL_SUB_YEARS> sub_years1 = await notes_servers()
        .get_sub_years_list(widget.cal_sub_name.id.toString());
    setState(() {
      sub_years = sub_years1;
      sub_years.sort((a, b) => a.yearName!.compareTo(b.yearName!));
      loaded_data = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun();
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    //sub_years = widget.cal_sub_years_list;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                //color: Colors.pink[100],
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.cover),
                ),
                child: SingleChildScrollView(
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipPath(
                              clipper: profile_Clipper(),
                              child: Container(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purple.shade300
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                              )),
                          Positioned(
                              left: 25,
                              top: 75,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: wid / 1.7,
                                    child: Text(
                                      utf8convert(widget.cal_sub_name.subName!),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      build_screen()
                    ])))),
        floatingActionButton: widget.app_user.isStudentAdmin! &&
                widget.app_user.branch == widget.branch
            ? ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.all(15),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                    padding:
                                        EdgeInsets.only(left: 40, right: 40),
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                          labelText: 'year',
                                          hintText: '2019',
                                          prefixIcon: Icon(Icons.text_fields),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      onChanged: (String value) {
                                        setState(() {
                                          year_name = value;
                                          if (value == "") {
                                            year_name = null;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  private_switch(widget.app_user),
                                  const SizedBox(height: 10),
                                  TextButton(
                                      onPressed: () async {
                                        widget.cal_sub_name.allYears = "";

                                        if (year_name == null) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                " year cant be null",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        } else if (widget.cal_sub_name.allYears!
                                            .contains(year_name)) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                " sub_task was already present. plese check it out.",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.pop(context);

                                          List<dynamic> error =
                                              await notes_servers()
                                                  .add_cal_sub_year(
                                                      widget.cal_sub_name.id
                                                          .toString(),
                                                      year_name,
                                                      _lights);

                                          if (!error[0]) {
                                            CAL_SUB_YEARS new_sub_year =
                                                CAL_SUB_YEARS();
                                            new_sub_year.id = error[1];
                                            new_sub_year.yearName = year_name;
                                            new_sub_year.private = _lights;
                                            new_sub_year.username =
                                                user_min(widget.app_user);
                                            setState(() {
                                              sub_years.add(new_sub_year);
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                content: Text(
                                                  "error occured please try again",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Center(
                                        child: Text("Add"),
                                      ))
                                ]));
                      });
                },
                label: const Text("Add new year",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.edit, color: Colors.white),
                style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              )
            : Container());
  }

  build_screen() {
    var wid = MediaQuery.of(context).size.width;
    return loaded_data == false
        ? Center(
            child: Container(
                margin: const EdgeInsets.all(20),
                child: CircularProgressIndicator()),
          )
        : Container(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: sub_years.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => CalSubFiles(
                                      widget.app_user,
                                      const [],
                                      sub_years[index],
                                      widget.cal_sub_name.subId!,
                                    )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.purple.shade300
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              //                                          color: Colors.white70,
                            ),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            padding: const EdgeInsets.only(
                                top: 7, left: 20, bottom: 7),
                            child: Column(
                              children: [
                                sub_years[index].private!
                                    ? Container(
                                        child: Text(
                                            sub_years[index].username!.email! +
                                                " (Private)",
                                            style: const TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.left),
                                      )
                                    : Container(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: wid / 2),
                                      child: Text(
                                        sub_years[index].yearName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (widget.app_user.isStudentAdmin! &&
                                            widget.app_user.branch ==
                                                widget.branch) {
                                          _lights = sub_years[index].private!;
                                          year_name = sub_years[index].yearName;
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close))
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 40,
                                                                    right: 40),
                                                            child:
                                                                TextFormField(
                                                              initialValue:
                                                                  sub_years[
                                                                          index]
                                                                      .yearName,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              decoration: const InputDecoration(
                                                                  labelText:
                                                                      'Year_Name',
                                                                  hintText:
                                                                      '2019',
                                                                  prefixIcon:
                                                                      Icon(Icons
                                                                          .text_fields),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10)))),
                                                              onChanged: (String
                                                                  value) {
                                                                setState(() {
                                                                  year_name =
                                                                      value;
                                                                  if (value ==
                                                                      "") {
                                                                    year_name =
                                                                        null;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          private_switch(
                                                              widget.app_user),
                                                          const SizedBox(
                                                              height: 10),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (year_name ==
                                                                    null) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      content:
                                                                          Text(
                                                                        "sub_name cant be null",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);

                                                                  bool error = await notes_servers().edit_cal_year(
                                                                      year_name!,
                                                                      sub_years[
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                      _lights);
                                                                  if (!error) {
                                                                    setState(
                                                                        () {
                                                                      sub_years[index]
                                                                              .yearName =
                                                                          year_name;
                                                                      sub_years[index]
                                                                              .private =
                                                                          _lights;
                                                                    });
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(const SnackBar(
                                                                            duration: Duration(milliseconds: 400),
                                                                            content: Text(
                                                                              "error occured please try again",
                                                                              style: TextStyle(color: Colors.white),
                                                                            )));
                                                                  }
                                                                }
                                                              },
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                    "update"),
                                                              ))
                                                        ]));
                                              });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  content: Text(
                                                    "Students not allowed",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )));
                                        }
                                      },
                                      icon: const Icon(Icons.edit),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          );
  }
}
