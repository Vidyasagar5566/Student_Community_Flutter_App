import 'package:flutter/material.dart';
import 'dart:io';
import '../circular_designs/cure_clip.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import '/servers/servers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<Tab> get_tabs(List<ALL_BRANCHES> all_branches) {
  List<Tab> tabs = [];
  for (int i = 0; i < all_branches.length; i++) {
    tabs.add(
      Tab(
        child: Text(
          all_branches[i].branchName!,
          style: TextStyle(color: Colors.black),
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
            DropdownButton<String>(
                value: widget.course,
                underline: Container(),
                elevation: 0,
                items:
                    course_list.map<DropdownMenuItem<String>>((String value) {
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
                    widget.course = value!;
                  });
                }),
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
                              BorderRadius.circular(30), // Creates border
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
                                          widget.course)));
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
                                                    widget.course)));
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
  cal_subjects(this.app_user, this.subject_names, this.sub_ids, this.cal_year,
      this.domain, this.course);

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
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
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
                            if (!widget.app_user.isAdmin!) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
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
                                    subject_names.add(new_sub_name);
                                    widget.subject_names.add(new_sub_name);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                    "error occured please try again",
                                    style: TextStyle(color: Colors.white),
                                  )));
                                }
                              }
                            }
                          },
                          child: const Center(child: Text("Add")))
                    ]));
              });
        },
        label: const Text("Add new subject",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.edit, color: Colors.white),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
      ),
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
                                        cal_sub_years(widget.app_user,
                                            widget.subject_names[index], [])));
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
                                                  /*                if (widget.cal_year ==
                                                  "Placements") {
                                                List<RATINGS> sub_ratings1 =
                                                    await notes_servers()
                                                        .get_sub_ratings_list(
                                                            widget
                                                                .subject_names[
                                                                    index]
                                                                .id
                                                                .toString());

                                                setState(() {
                                                  all_sub_ratings =
                                                      sub_ratings1;
                                                });
                                                bool found = false;
                                                for (int i = 0;
                                                    i < all_sub_ratings.length;
                                                    i++) {
                                                  if (all_sub_ratings[i]
                                                          .username!
                                                          .email ==
                                                      widget.app_user.email) {
                                                    found = true;
                                                    setState(() {
                                                      selected_rating =
                                                          all_sub_ratings[i];
                                                    });

                                                    break;
                                                  }
                                                }
                                                if (!found) {
                                                  selected_rating.rating = 0;
                                                  selected_rating.id = -1;
                                                  selected_rating.description =
                                                      "";
                                                  selected_rating.username =
                                                      user_min(widget.app_user);
                                                  setState(() {
                                                    all_sub_ratings
                                                        .add(selected_rating);
                                                  });
                                                }
                                                setState(() {
                                                  _loaded[index] = true;
                                                });
                                               }   */
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
                                    /*                   !_extand[index] && widget.cal_year == "Placements"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      cal_sub_years(
                                                          widget.app_user,
                                                          widget.cal_sub_names[
                                                              index],
                                                          [])));
                                        },
                                        icon: Given_Rating(sub_rating)),
                                    Container()
                                  ],
                                )
                              : Container(),    */
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
                                    /*                 _extand[index] && widget.cal_year == "Placements"
                              ? Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rating: " +
                                              sub_rating
                                                  .toString()
                                                  .substring(0, 3),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              if (_loaded[index]) {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          content:
                                                              Show_all_sub_ratings(
                                                                  all_sub_ratings,
                                                                  widget
                                                                      .app_user));
                                                    });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                  "please wait data is loading.",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )));
                                              }
                                            },
                                            child: Given_Rating(sub_rating))
                                      ]),
                                  const SizedBox(height: 10),
                                  _loaded[index]
                                      ? Column(
                                          children: [
                                            const Text(
                                              "Update your Rating : ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 7),
                                            Giving_Rating(
                                                widget.cal_sub_names[index].id!,
                                                widget.app_user)
                                          ],
                                        )
                                      : const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          )),
                                ])
                              : Container(),  */
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
        if (widget.app_user.isAdmin!) {
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
  cal_sub_years(
    this.app_user,
    this.cal_sub_name,
    this.cal_sub_years_list,
  );

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
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
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
                              labelText: 'year',
                              hintText: '2019',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
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
                            if (!widget.app_user.isAdmin!) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Students are not allowed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else {
                              if (year_name == null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      " year cant be null",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else if (widget.cal_sub_name.allYears!
                                  .contains(year_name)) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      " sub_task was already present. plese check it out.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pop(context);

                                List<dynamic> error = await notes_servers()
                                    .add_cal_sub_year(
                                        widget.cal_sub_name.id.toString(),
                                        year_name,
                                        _lights);

                                if (!error[0]) {
                                  CAL_SUB_YEARS new_sub_year = CAL_SUB_YEARS();
                                  new_sub_year.id = error[1];
                                  new_sub_year.yearName = year_name;
                                  new_sub_year.private = _lights;
                                  new_sub_year.username =
                                      user_min(widget.app_user);
                                  setState(() {
                                    sub_years.add(new_sub_year);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "error occured please try again",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.edit, color: Colors.white),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
      ),
    );
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
                                                                onPressed: () {
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
                                                          child: TextFormField(
                                                            initialValue:
                                                                sub_years[index]
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
                                                            onChanged:
                                                                (String value) {
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
                                                              if (!widget
                                                                  .app_user
                                                                  .isAdmin!) {
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content:
                                                                        Text(
                                                                      "Students are not allowed",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                if (year_name ==
                                                                    null) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
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
                                                                            content: Text(
                                                                      "error occured please try again",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )));
                                                                  }
                                                                }
                                                              }
                                                            },
                                                            child: const Center(
                                                              child: Text(
                                                                  "update"),
                                                            ))
                                                      ]));
                                            });
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

class CalSubFiles extends StatefulWidget {
  Username app_user;
  List<CAL_SUB_FILES> cal_sub_files;
  CAL_SUB_YEARS sub_year;
  String sub_id;
  CalSubFiles(
    this.app_user,
    this.cal_sub_files,
    this.sub_year,
    this.sub_id,
  );

  @override
  State<CalSubFiles> createState() => _CalSubFilesState();
}

class _CalSubFilesState extends State<CalSubFiles> {
  var file_name;
  var file;
  String file_type = "";
  var loaded_data = false;
  List<CAL_SUB_FILES> sub_files = [];

  void load_data_fun() async {
    List<CAL_SUB_FILES> sub_files1 =
        await notes_servers().get_sub_files_list(widget.sub_year.id.toString());
    setState(() {
      sub_files = sub_files1;
      sub_files.sort((a, b) => a.fileName!.compareTo(b.fileName!));
      loaded_data = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun();
  }

  void uploading() async {
    var new_file = CAL_SUB_FILES();
    new_file.fileName = file.path.split("/").last;
    new_file.uploaded = false;
    new_file.insert = true;
    new_file.file = file;
    new_file.fileType = file_type;
    new_file.qnAnsFile = "";
    new_file.username = user_min(widget.app_user);
    setState(() {
      widget.cal_sub_files.add(new_file);
    });
    List<dynamic> error = await notes_servers()
        .post_cal_sub_files(file, widget.sub_year.id.toString(), file_type);
    if (!error[0]) {
      setState(() {
        new_file.id = error[1];
        new_file.uploaded = true;
      });
    } else {
      setState(() {
        widget.cal_sub_files.remove(new_file);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "error occured please try again",
          style: TextStyle(color: Colors.white),
        )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    widget.cal_sub_files = sub_files;
    widget.cal_sub_files.sort((a, b) => a.fileName!.compareTo(b.fileName!));
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              //color: Colors.pink[100],
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.cover)),
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
                                    width: wid / 2,
                                    child: Text(
                                      widget.sub_year.yearName!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ))
                      ],
                    ),
                    !loaded_data
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                    child: ListView.builder(
                                        itemCount: widget.cal_sub_files.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (widget.app_user.email ==
                                              widget.sub_year.username!.email) {
                                            return build_screen(index);
                                          } else if (widget.sub_year.private!) {
                                            if (widget.cal_sub_files[index]
                                                        .username!.email ==
                                                    widget.app_user.email ||
                                                widget.cal_sub_files[index]
                                                        .username!.email ==
                                                    widget.sub_year.username!
                                                        .email) {
                                              return build_screen(index);
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return build_screen(index);
                                          }
                                          //return Container();
                                        }))
                              ],
                            ),
                          )
                  ])))),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          if (widget.app_user.email == "guest@nitc.ac.in") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Guests are not allowed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            const SizedBox(height: 10),
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? image1 = await _picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 35);
                                  //final bytes = await File(image1!.path).readAsBytes();
                                  setState(() {
                                    file = File(image1!.path);
                                    file_type = "1";
                                    //final img.Image image = img.decodeImage(bytes)!;
                                  });
                                  Navigator.pop(context);
                                  uploading();
                                },
                                icon: const Icon(Icons.photo_library_outlined,
                                    size: 20)),
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final image1 = await _picker.pickVideo(
                                    source: ImageSource.gallery,
                                  );

                                  //final bytes = await File(image1!.path).readAsBytes();
                                  setState(() {
                                    file = File(image1!.path);
                                    file_type = "2";
                                    //final img.Image image = img.decodeImage(bytes)!;
                                  });
                                  Navigator.pop(context);
                                  uploading();
                                },
                                icon: const Icon(
                                  Icons.video_collection_outlined,
                                  size: 20,
                                )),
                            IconButton(
                                onPressed: () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );

                                  setState(() {
                                    file = File(result!.paths.first ?? '');
                                    file_type = "3";
                                    //final img.Image image = img.decodeImage(bytes)!;
                                  });
                                  Navigator.pop(context);
                                  uploading();
                                },
                                icon: const Icon(Icons.file_copy_sharp,
                                    size: 20)),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }
        },
        label: widget.sub_year == "Placements"
            ? const Text("Add new review",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            : const Text("Add new file",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.edit, color: Colors.white),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
      ),
    );
  }

  build_screen(int index) {
    var wid = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (widget.app_user.email == "guest@nitc.ac.in") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Guests are not allowed open files",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          if (widget.cal_sub_files[index].fileType == "1") {
            print(widget.cal_sub_files[index].qnAnsFile);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => image_display(
                    widget.cal_sub_files[index].insert,
                    widget.cal_sub_files[index].file!,
                    widget.cal_sub_files[index].qnAnsFile!)));
          } else if (widget.cal_sub_files[index].fileType == "2") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => video_display4(
                    widget.cal_sub_files[index].insert,
                    widget.cal_sub_files[index].file!,
                    widget.cal_sub_files[index].qnAnsFile!)));
          } else {
            if (widget.cal_sub_files[index].insert) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      pdfviewer(widget.cal_sub_files[index].file!)));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => pdfviewer1(
                      widget.cal_sub_files[index].qnAnsFile!, false)));
            }
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          //                                          color: Colors.white70,
        ),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 7, left: 20, bottom: 7),
        child: Column(
          children: [
            Container(
              child: Text(widget.cal_sub_files[index].username!.email!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.left),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: wid / 2),
                  child: Text(
                    widget.cal_sub_files[index].fileName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                widget.cal_sub_files[index].uploaded == false
                    ? IconButton(
                        onPressed: () {},
                        icon: const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(color: Colors.white),
                        ))
                    : widget.app_user.email ==
                            widget.cal_sub_files[index].username!.email
                        ? IconButton(
                            onPressed: () async {
                              if (widget.app_user.email == "guest@nitc.ac.in") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Guests are not allowed",
                                  style: TextStyle(color: Colors.white),
                                )));
                              } else {
                                bool error = await notes_servers()
                                    .delete_sub_files_list(widget
                                        .cal_sub_files[index].id
                                        .toString());

                                if (!error) {
                                  setState(() {
                                    widget.cal_sub_files
                                        .remove(widget.cal_sub_files[index]);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                    "error occured please try again",
                                    style: TextStyle(color: Colors.white),
                                  )));
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                          )
                        : (widget.sub_year.username!.email ==
                                    widget.app_user.email &&
                                widget.sub_year.private!)
                            ? IconButton(
                                onPressed: () {
                                  void uploading1() async {
                                    widget.cal_sub_files[index].fileName =
                                        file.path.split("/").last;
                                    widget.cal_sub_files[index].uploaded =
                                        false;
                                    widget.cal_sub_files[index].insert = true;
                                    widget.cal_sub_files[index].file = file;
                                    widget.cal_sub_files[index].fileType =
                                        file_type;
                                    widget.cal_sub_files[index].qnAnsFile = "";
                                    widget.cal_sub_files[index].username =
                                        widget.cal_sub_files[index].username;
                                    List<dynamic> error = await notes_servers()
                                        .edit_cal_sub_files(
                                            widget.cal_sub_files[index]
                                                .username!.email!,
                                            widget.cal_sub_files[index].id!,
                                            file,
                                            widget.sub_year.id.toString(),
                                            file_type);
                                    if (!error[0]) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                        "edited successfully you ca go back and came again.",
                                        style: TextStyle(color: Colors.white),
                                      )));
                                      widget.cal_sub_files[index].uploaded =
                                          true;
                                      setState(() {
                                        widget.cal_sub_files[index].uploaded =
                                            true;
                                      });
                                    } else {
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                          "error occured please go back and come again.",
                                          style: TextStyle(color: Colors.white),
                                        )));
                                      });
                                    }
                                  }

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.all(15),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(),
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.close))
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  IconButton(
                                                      onPressed: () async {
                                                        final ImagePicker
                                                            _picker =
                                                            ImagePicker();
                                                        final XFile? image1 =
                                                            await _picker.pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .gallery,
                                                                imageQuality:
                                                                    35);
                                                        //final bytes = await File(image1!.path).readAsBytes();
                                                        setState(() {
                                                          file = File(
                                                              image1!.path);
                                                          file_type = "1";
                                                          //final img.Image image = img.decodeImage(bytes)!;
                                                        });
                                                        Navigator.pop(context);
                                                        uploading1();
                                                      },
                                                      icon: const Icon(
                                                          Icons
                                                              .photo_library_outlined,
                                                          size: 20)),
                                                  IconButton(
                                                      onPressed: () async {
                                                        final ImagePicker
                                                            _picker =
                                                            ImagePicker();
                                                        final image1 =
                                                            await _picker
                                                                .pickVideo(
                                                          source: ImageSource
                                                              .gallery,
                                                        );

                                                        //final bytes = await File(image1!.path).readAsBytes();
                                                        setState(() {
                                                          file = File(
                                                              image1!.path);
                                                          file_type = "2";
                                                          //final img.Image image = img.decodeImage(bytes)!;
                                                        });
                                                        Navigator.pop(context);
                                                        uploading1();
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .video_collection_outlined,
                                                        size: 20,
                                                      )),
                                                  IconButton(
                                                      onPressed: () async {
                                                        final result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                            'pdf'
                                                          ],
                                                        );

                                                        setState(() {
                                                          file = File(result!
                                                                  .paths
                                                                  .first ??
                                                              '');
                                                          file_type = "3";
                                                          //final img.Image image = img.decodeImage(bytes)!;
                                                        });
                                                        Navigator.pop(context);
                                                        uploading1();
                                                      },
                                                      icon: const Icon(
                                                          Icons.file_copy_sharp,
                                                          size: 20)),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.file_copy,
                                  color: Colors.white,
                                ),
                              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
