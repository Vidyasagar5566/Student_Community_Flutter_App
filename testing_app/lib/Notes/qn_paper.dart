import 'package:flutter/material.dart';
import '../Circular_designs/Cure_clip.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import 'dart:convert' show utf8;
import 'Years_Of_Subjects.dart';
import '/Fcm_Notif_Domains/Servers.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<Container> get_tabs(List<ALL_BRANCHES> all_branches) {
  List<Container> tabs = [];
  for (int i = 0; i < all_branches.length; i++) {
    tabs.add(
      Container(
        width: 60,
        child: Tab(
          child: Text(
            all_branches[i].branchName!,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
  return tabs;
}

List<Widget> get_tabcontents(List<ALL_BRANCHES> all_branches, Username app_user,
    String domain, String course) {
  List<Widget> all_tab_views = [];
  for (int i = 0; i < all_branches.length; i++) {
    all_tab_views.add(branch_display(all_branches[i], app_user,
        all_branches[i].branchName!, domain, course));
  }
  return all_tab_views;
}

class branchAndSems extends StatefulWidget {
  Username app_user;
  String domain;
  String course;
  branchAndSems(this.app_user, this.domain, this.course);

  @override
  State<branchAndSems> createState() => _branchAndSemsState();
}

class _branchAndSemsState extends State<branchAndSems> {
  @override
  Widget build(BuildContext context) {
    List<String> domains_list_new = List.from(domains_list);
    domains_list_new.remove('All');
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: false,
          title: const Text(
            "Branches",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            // DropdownButton<String>(
            //     value: widget.course,
            //     underline: Container(),
            //     elevation: 0,
            //     items:
            //         course_list.map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(
            //           value,
            //           style: TextStyle(fontSize: 10),
            //         ),
            //       );
            //     }).toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         widget.course = value!;
            //       });
            //     }),
            DropdownButton<String>(
                value: widget.domain,
                underline: Container(),
                elevation: 0,
                items: domains_list_new
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
                }),
          ],
          backgroundColor: Colors.white70,
        ),
        body: FutureBuilder<List<ALL_BRANCHES>>(
          future: notes_servers()
              .get_branches_list(domains1[widget.domain]!, widget.course),
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
                List<ALL_BRANCHES> all_branches = snapshot.data;
                if (all_branches.isEmpty) {
                  return Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(30),
                      child: const Center(
                        child: Text(
                          "No Data Was Found",
                        ),
                      ));
                } else {
                  return qn_an_branchs(all_branches, widget.app_user,
                      widget.domain, widget.course);
                }
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class qn_an_branchs extends StatefulWidget {
  List<ALL_BRANCHES> all_branches;
  Username app_user;
  String domain;
  String course;
  qn_an_branchs(this.all_branches, this.app_user, this.domain, this.course);

  @override
  State<qn_an_branchs> createState() => _qn_an_branchsState();
}

class _qn_an_branchsState extends State<qn_an_branchs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.all_branches.length,
        child: Column(
          children: [
            SizedBox(
                height: 50,
                child: AppBar(
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      indicator: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20), // Creates border
                          color: Colors.grey),
                      indicatorColor: Colors.white,
                      isScrollable: true,
                      labelColor: Colors.black,
                      tabs: get_tabs(widget.all_branches),
                    ))),
            Expanded(
                child: TabBarView(
                    children: get_tabcontents(widget.all_branches,
                        widget.app_user, widget.domain, widget.course)))
          ],
        ));
  }
}

class branch_display extends StatefulWidget {
  ALL_BRANCHES subject_names;
  Username app_user;
  String branch;
  String domain;
  String course;
  branch_display(
      this.subject_names, this.app_user, this.branch, this.domain, this.course);

  @override
  State<branch_display> createState() => _branch_displayState();
}

class _branch_displayState extends State<branch_display> {
  @override
  Widget build(BuildContext context) {
    List<String> all_sems = widget.subject_names.semisters!.split('@');
    var wid = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(
            image: DecorationImage(
                //image: post.post_pic,
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: (all_sems.length / 2).ceil(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      cal_subjects(
                                          widget.app_user,
                                          [],
                                          widget.branch +
                                              (index * 2 + 1).toString(),
                                          all_sems[index * 2],
                                          domains1[widget.domain]!,
                                          widget.course,
                                          widget.branch)));
                            },
                            child: Container(
                                width: wid / 2.8,
                                height: 60,
                                margin: const EdgeInsets.all(20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.deepPurple,
                                      Colors.purple.shade300
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    all_sems[index * 2],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                )),
                          ),
                          all_sems.length > index * 2 + 1
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                cal_subjects(
                                                    widget.app_user,
                                                    [],
                                                    widget.branch +
                                                        (index * 2 + 2)
                                                            .toString(),
                                                    all_sems[index * 2 + 1],
                                                    domains1[widget.domain]!,
                                                    widget.course,
                                                    widget.branch)));
                                  },
                                  child: Container(
                                      width: wid / 2.8,
                                      height: 60,
                                      margin: const EdgeInsets.all(20),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.deepPurple,
                                            Colors.purple.shade300
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          all_sems[index * 2 + 1],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      )),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  );
                })));
  }
}

class cal_subjects extends StatefulWidget {
  Username app_user;
  List<CAL_SUB_NAMES> subject_names;
  String sub_ids;
  String cal_year;
  String domain;
  String course;
  String branch;
  cal_subjects(this.app_user, this.subject_names, this.sub_ids, this.cal_year,
      this.domain, this.course, this.branch);

  @override
  State<cal_subjects> createState() => _cal_subjectsState();
}

class _cal_subjectsState extends State<cal_subjects> {
  var sub_name;
  List<bool> _extand = [];
  List<bool> _loaded = [];
  double sub_rating = 0.0;

  var loaded_data = false;
  List<CAL_SUB_NAMES> subject_names = [];

  void load_data_fun() async {
    List<CAL_SUB_NAMES> subject_names1 = await notes_servers()
        .get_sub_place_list(widget.sub_ids, widget.domain, widget.course);
    subject_names1.sort((a, b) => a.subName!.compareTo(b.subName!));
    setState(() {
      subject_names = subject_names1;
      loaded_data = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun();
  }

  @override
  Widget build(BuildContext context) {
    widget.subject_names = subject_names;
    for (int i = 0; i < widget.subject_names.length; i++) {
      _extand.add(false);
      _loaded.add(false);
    }
    var wid = MediaQuery.of(context).size.width;
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
            margin: const EdgeInsets.only(bottom: 20),
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
                                )))),
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
                                  width: wid / 0.5,
                                  child: Text(
                                    widget.cal_year,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                  ]),
            )),
      ),
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
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              padding: EdgeInsets.only(left: 40, right: 40),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: "sub_name",
                                    hintText: 'MATHS-II',
                                    prefixIcon: Icon(Icons.text_fields),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                onChanged: (String value) {
                                  setState(() {
                                    sub_name = value;
                                    if (value == "") {
                                      sub_name = null;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: () async {
                                  if (sub_name == null) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 400),
                                        content: Text(
                                          "sub name cant be null",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);

                                    List<dynamic> error = await notes_servers()
                                        .post_cal_sub(sub_name, widget.sub_ids);
                                    if (!error[0]) {
                                      var new_sub_name = CAL_SUB_NAMES();
                                      new_sub_name.id = error[1];
                                      new_sub_name.subId = widget.sub_ids;
                                      new_sub_name.subName = sub_name;
                                      new_sub_name.username =
                                          user_min(widget.app_user);
                                      new_sub_name.totRatingsVal = 0;
                                      new_sub_name.numRatings = 0;
                                      setState(() {
                                        widget.subject_names.add(new_sub_name);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                "error occured please try again",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                "error occured please try again",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )));
                                    }
                                  }
                                },
                                child: const Center(child: Text("Add")))
                          ]));
                    });
              },
              label: const Text("Add new subject",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.edit, color: Colors.white),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
            )
          : Container(),
    );
  }

  build_screen() {
    var wid = MediaQuery.of(context).size.width;
    return !loaded_data
        ? const CircularProgressIndicator()
        : subject_names.isEmpty
            ? const Center(
                child: Text("No subjects was added",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              )
            : Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                          itemCount: widget.subject_names.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 10),
                          itemBuilder: (BuildContext context, int index) {
                            sub_rating = 0.0;
                            if (widget.subject_names[index].numRatings != 0) {
                              sub_rating =
                                  (widget.subject_names[index].totRatingsVal! /
                                      widget.subject_names[index].numRatings!);
                            }

                            return GestureDetector(
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        cal_sub_years(
                                            widget.app_user,
                                            widget.subject_names[index],
                                            [],
                                            widget.branch)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.deepPurple,
                                      Colors.purple.shade300
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                padding: const EdgeInsets.only(
                                    top: 7, left: 20, bottom: 7),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth: wid / 1.8),
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            utf8convert(widget
                                                .subject_names[index].subName!),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 21,
                                                color: Colors.white),
                                          ),
                                        ),
                                        !_extand[index]
                                            ? IconButton(
                                                onPressed: () async {
                                                  if (widget.app_user
                                                          .isStudentAdmin! &&
                                                      widget.app_user.branch ==
                                                          widget.branch) {
                                                    for (int i = 0;
                                                        i <
                                                            widget.subject_names
                                                                .length;
                                                        i++) {
                                                      setState(() {
                                                        _extand[i] = false;
                                                      });
                                                    }
                                                    setState(() {
                                                      _extand[index] =
                                                          !_extand[index];
                                                      _loaded[index] = false;
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        400),
                                                                content: Text(
                                                                  "Students not allowed",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )));
                                                  }
                                                },
                                                icon: const Icon(Icons
                                                    .keyboard_arrow_down_outlined),
                                                color: Colors.white,
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _extand[index] =
                                                        !_extand[index];
                                                    sub_rating = 0;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .keyboard_arrow_up_outlined,
                                                  color: Colors.white,
                                                )),
                                      ],
                                    ),
                                    _extand[index]
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Container(
                                                  child: const Text(
                                                    "Edit name?",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      sub_name = widget
                                                          .subject_names[index]
                                                          .subName;
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                content: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
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
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                40,
                                                                            right:
                                                                                40),
                                                                        child:
                                                                            TextFormField(
                                                                          initialValue: widget
                                                                              .subject_names[index]
                                                                              .subName,
                                                                          keyboardType:
                                                                              TextInputType.emailAddress,
                                                                          decoration: const InputDecoration(
                                                                              labelText: 'sub_name',
                                                                              hintText: 'MATHS-II',
                                                                              prefixIcon: Icon(Icons.text_fields),
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                                                          onChanged:
                                                                              (String value) {
                                                                            setState(() {
                                                                              sub_name = value;
                                                                              if (value == "") {
                                                                                sub_name = null;
                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (!widget.app_user.isAdmin!) {
                                                                              Navigator.pop(context);
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  duration: Duration(milliseconds: 400),
                                                                                  content: Text(
                                                                                    "Students are not allowed",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            } else {
                                                                              if (sub_name == null) {
                                                                                Navigator.pop(context);
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    duration: Duration(milliseconds: 400),
                                                                                    content: Text(
                                                                                      "sub_name cant be null",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } else {
                                                                                Navigator.pop(context);

                                                                                bool error = await notes_servers().edit_cal_sub(sub_name!, widget.subject_names[index].id.toString());
                                                                                if (!error) {
                                                                                  setState(() {
                                                                                    widget.subject_names[index].subName = sub_name;
                                                                                  });
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                      duration: Duration(milliseconds: 400),
                                                                                      content: Text(
                                                                                        "error occured please try again",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      )));
                                                                                }
                                                                              }
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Center(
                                                                            child:
                                                                                Text("update"),
                                                                          ))
                                                                    ]));
                                                          });
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ))
                                              ])
                                        : Container(),
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
