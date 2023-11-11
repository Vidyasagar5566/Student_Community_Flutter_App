import 'package:flutter/material.dart';
import 'dart:io';
import '../Circular_designs/Cure_clip.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

RATINGS selected_rating = RATINGS();

class Given_Rating extends StatefulWidget {
  double sub_rating;
  Given_Rating(this.sub_rating);

  @override
  State<Given_Rating> createState() => _Given_RatingState();
}

class _Given_RatingState extends State<Given_Rating> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.sub_rating.floor() >= 1
            ? const Icon(Icons.star, color: Colors.white)
            : const Icon(Icons.star_border, color: Colors.white),
        widget.sub_rating.floor() >= 2
            ? const Icon(Icons.star, color: Colors.white)
            : const Icon(Icons.star_border, color: Colors.white),
        widget.sub_rating.floor() >= 3
            ? const Icon(Icons.star, color: Colors.white)
            : const Icon(Icons.star_border, color: Colors.white),
        widget.sub_rating.floor() >= 4
            ? const Icon(Icons.star, color: Colors.white)
            : const Icon(Icons.star_border, color: Colors.white),
        widget.sub_rating.floor() >= 5
            ? const Icon(Icons.star, color: Colors.white)
            : const Icon(Icons.star_border, color: Colors.white),
      ],
    );
  }
}

class Giving_Rating extends StatefulWidget {
  int sub_id;
  Username app_user;
  Giving_Rating(this.sub_id, this.app_user);

  @override
  State<Giving_Rating> createState() => _Giving_RatingState();
}

class _Giving_RatingState extends State<Giving_Rating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Row(children: [
            _build_screen(1),
            _build_screen(2),
            _build_screen(3),
            _build_screen(4),
            _build_screen(5),
          ]),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 240,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  initialValue: selected_rating.description,
                  style: TextStyle(color: Colors.white),
                  minLines: 2,
                  cursorColor: Colors.white,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    counterStyle: TextStyle(color: Colors.white),
                    labelText: "Experience",
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Good Working Environment",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      selected_rating.description = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                  onPressed: () async {
                    if (widget.app_user.email == "guest@nitc.ac.in") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 400),
                          content: Text(
                            "Guests are not allowed.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      List<dynamic> error = await placemeny_servers()
                          .post_sub_rating(
                              selected_rating.rating!,
                              selected_rating.description!,
                              widget.sub_id.toString());
                      if (!error[0]) {
                        selected_rating.id = error[1];
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          "Thanks for your feedback, we will update the details soon.",
                          style: TextStyle(color: Colors.white),
                        )));
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
                  icon: Icon(Icons.cloud_upload, color: Colors.white)
                  // Text("Update Review",
                  //     style: TextStyle(color: Colors.white)),
                  ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _build_screen(int index) {
    return IconButton(
        onPressed: () async {
          if (widget.app_user.email == "guest@nitc.ac.in") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 400),
                content: Text(
                  "Guests are not allowed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            setState(() {
              selected_rating.rating = index;
            });
            List<dynamic> error = await placemeny_servers().post_sub_rating(
                selected_rating.rating!,
                selected_rating.description!,
                widget.sub_id.toString());
            print(error);
            if (!error[0]) {
              selected_rating.id = error[1];
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                "Thanks for your feedback, we will update the details soon.",
                style: TextStyle(color: Colors.white),
              )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                "error occured please try again",
                style: TextStyle(color: Colors.white),
              )));
            }
          }
        },
        icon: selected_rating.rating! >= index
            ? const Icon(Icons.star, color: Colors.white)
            : const Icon(Icons.star_border, color: Colors.white));
  }
}

class Show_all_sub_ratings extends StatefulWidget {
  List<RATINGS> all_sub_ratings;
  Username app_user;
  Show_all_sub_ratings(this.all_sub_ratings, this.app_user);

  @override
  State<Show_all_sub_ratings> createState() => _Show_all_sub_ratingsState();
}

class _Show_all_sub_ratingsState extends State<Show_all_sub_ratings> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ]),
            ListView.builder(
                itemCount: widget.all_sub_ratings.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: width - 80,
                    margin: const EdgeInsets.all(4),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purple.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        children: [
                          Text(
                            widget.all_sub_ratings[index].username!.email!,
                            style: TextStyle(color: Colors.white),
                          ),
                          widget.app_user.email ==
                                      widget.all_sub_ratings[index].username!
                                          .email &&
                                  widget.all_sub_ratings[index].id != -1
                              ? IconButton(
                                  onPressed: () async {
                                    bool error = await placemeny_servers()
                                        .delete_sub_rating(widget
                                            .all_sub_ratings[index].id
                                            .toString());
                                    if (!error) {
                                      RATINGS value =
                                          widget.all_sub_ratings[index];
                                      setState(() {
                                        widget.all_sub_ratings.remove(value);
                                        selected_rating.rating = 0;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.delete_forever,
                                      color: Colors.white))
                              : Container()
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rating : ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Given_Rating(
                              widget.all_sub_ratings[index].rating!.toDouble()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Review: ",
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 10),
                          Container(
                            width: 160,
                            child: Text(
                              widget.all_sub_ratings[index].description!,
                              maxLines: 10,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ]),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

bool InternCompany = false;

class private_switch extends StatefulWidget {
  private_switch();

  @override
  State<private_switch> createState() => _private_switchState();
}

class _private_switchState extends State<private_switch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        "InternCompany?",
        style: TextStyle(fontWeight: FontWeight.w200),
      ),
      activeColor: Colors.blue,
      value: InternCompany,
      onChanged: (bool value) {
        setState(() {
          InternCompany = !InternCompany;
        });
      },
    );
  }
}

class placements extends StatefulWidget {
  Username app_user;
  List<CAL_SUB_NAMES> cal_sub_names;
  String domain;
  placements(this.app_user, this.cal_sub_names, this.domain);

  @override
  State<placements> createState() => _placementsState();
}

class _placementsState extends State<placements> {
  var sub_name;
  List<bool> _extand = [];
  List<bool> _loaded = [];
  double sub_rating = 0.0;

  List<RATINGS> all_sub_ratings = [];

  var year_name;
  var loaded_data = false;
  List<CAL_SUB_NAMES> cal_sub_names = [];

  void load_data_fun() async {
    List<CAL_SUB_NAMES> plac_names = await placemeny_servers()
        .get_sub_place_list("CPC", widget.domain, 'B.Tech');
    setState(() {
      cal_sub_names = plac_names;
      loaded_data = true;
      for (int i = 0; i < cal_sub_names.length; i++) {
        if (cal_sub_names[i].InternCompany == false) {
          widget.cal_sub_names.add(cal_sub_names[i]);
        }
      }
    });
  }

  void initState() {
    super.initState();
    load_data_fun();
  }

  String inter_placement = "Placement";

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.cal_sub_names.length; i++) {
      _extand.add(false);
      _loaded.add(false);
    }
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //color: Colors.pink[100],
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
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
                            height: 230,
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
                          left: 20,
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
                                width: 200,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: "Search Company Name",
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      if (inter_placement == "Placement") {
                                        widget.cal_sub_names = cal_sub_names
                                            .where((element) =>
                                                element.subName!
                                                    .contains(value) &&
                                                !element.InternCompany!)
                                            .toList();
                                      } else {
                                        widget.cal_sub_names = cal_sub_names
                                            .where((element) =>
                                                element.subName!
                                                    .contains(value) &&
                                                element.InternCompany!)
                                            .toList();
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                " (" +
                                    widget.cal_sub_names.length.toString() +
                                    ")",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ))
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: DropdownButton<String>(
                              value: inter_placement,
                              underline: Container(),
                              elevation: 0,
                              items: [
                                'Placement',
                                "Intern"
                              ].map<DropdownMenuItem<String>>((String value) {
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
                                  inter_placement = value!;
                                  widget.cal_sub_names = [];
                                  for (int i = 0;
                                      i < cal_sub_names.length;
                                      i++) {
                                    if (inter_placement == "Placement" &&
                                        cal_sub_names[i].InternCompany ==
                                            false) {
                                      widget.cal_sub_names
                                          .add(cal_sub_names[i]);
                                    } else if (inter_placement == "Intern" &&
                                        cal_sub_names[i].InternCompany ==
                                            true) {
                                      widget.cal_sub_names
                                          .add(cal_sub_names[i]);
                                    }
                                  }
                                });
                              }),
                        )
                      ]),
                  build_screen()
                ]),
          )),
      floatingActionButton: widget.app_user.is_placement_admin!
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
                                    labelText: "Company name",
                                    hintText: "TCS",
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
                            private_switch(),
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: () async {
                                  if (sub_name == null) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 400),
                                        content: Text(
                                          " name cant be null",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    List<dynamic> error =
                                        await placemeny_servers().post_cal_sub(
                                            sub_name, 'CPC', InternCompany);
                                    if (!error[0]) {
                                      var new_sub_name = CAL_SUB_NAMES();
                                      new_sub_name.id = error[1];
                                      new_sub_name.subId = 'CPC';
                                      new_sub_name.subName = sub_name;
                                      new_sub_name.username =
                                          user_min(widget.app_user);
                                      new_sub_name.totRatingsVal = 0;
                                      new_sub_name.numRatings = 0;
                                      new_sub_name.InternCompany =
                                          InternCompany;
                                      setState(() {
                                        widget.cal_sub_names.add(new_sub_name);
                                      });
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
              label: const Text("Add new company",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.edit, color: Colors.white),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
            )
          : Container(),
    );
  }

  funToLoadAllReviews(int index) async {
    for (int i = 0; i < widget.cal_sub_names.length; i++) {
      setState(() {
        _extand[i] = false;
      });
    }
    setState(() {
      _extand[index] = !_extand[index];
      _loaded[index] = false;
    });
    List<RATINGS> sub_ratings1 = await placemeny_servers()
        .get_sub_ratings_list(widget.cal_sub_names[index].id.toString());

    setState(() {
      all_sub_ratings = sub_ratings1;
    });
    bool found = false;
    for (int i = 0; i < all_sub_ratings.length; i++) {
      if (all_sub_ratings[i].username!.email == widget.app_user.email) {
        found = true;
        setState(() {
          selected_rating = all_sub_ratings[i];
        });

        break;
      }
    }
    if (!found) {
      selected_rating.rating = 0;
      selected_rating.id = -1;
      selected_rating.description = "";
      selected_rating.username = user_min(widget.app_user);
      setState(() {
        all_sub_ratings.add(selected_rating);
      });
    }
    setState(() {
      _loaded[index] = true;
    });
  }

  build_screen() {
    var wid = MediaQuery.of(context).size.width;
    return !loaded_data
        ? const CircularProgressIndicator()
        : Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: widget.cal_sub_names.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  sub_rating = 0.0;
                  if (widget.cal_sub_names[index].numRatings != 0) {
                    sub_rating = (widget.cal_sub_names[index].totRatingsVal! /
                        widget.cal_sub_names[index].numRatings!);
                  }

                  return GestureDetector(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => place_years(
                              widget.app_user,
                              widget.cal_sub_names[index], [])));
                    },
                    child: Container(
                      width: wid - 16,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purple.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        //                                          color: Colors.white70,
                      ),
                      margin: const EdgeInsets.all(8),
                      padding:
                          const EdgeInsets.only(top: 3, left: 12, bottom: 3),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: wid / 1.8),
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.cal_sub_names[index].subName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                      color: Colors.white),
                                ),
                              ),
                              !_extand[index]
                                  ? IconButton(
                                      onPressed: () async {
                                        funToLoadAllReviews(index);
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      color: Colors.white,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _extand[index] = !_extand[index];
                                          sub_rating = 0;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        color: Colors.white,
                                      )),
                            ],
                          ),
                          _extand[index]
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      place_years(
                                                          widget.app_user,
                                                          widget.cal_sub_names[
                                                              index],
                                                          [])));
                                        },
                                        icon: Given_Rating(sub_rating)),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                          sub_rating.toString().substring(0, 3),
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                          _extand[index] && widget.app_user.is_placement_admin!
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      Container(
                                        child: const Text(
                                          "Edit name?",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            sub_name = widget
                                                .cal_sub_names[index].subName;
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
                                                                      right:
                                                                          40),
                                                              child:
                                                                  TextFormField(
                                                                initialValue: widget
                                                                    .cal_sub_names[
                                                                        index]
                                                                    .subName,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .emailAddress,
                                                                decoration: const InputDecoration(
                                                                    labelText:
                                                                        'sub_name',
                                                                    hintText:
                                                                        'MATHS-II',
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .text_fields),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10)))),
                                                                onChanged:
                                                                    (String
                                                                        value) {
                                                                  setState(() {
                                                                    sub_name =
                                                                        value;
                                                                    if (value ==
                                                                        "") {
                                                                      sub_name =
                                                                          null;
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (sub_name ==
                                                                      null) {
                                                                    Navigator.pop(
                                                                        context);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        duration:
                                                                            Duration(milliseconds: 400),
                                                                        content:
                                                                            Text(
                                                                          "sub_name cant be null",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    Navigator.pop(
                                                                        context);

                                                                    bool error = await placemeny_servers().edit_cal_sub(
                                                                        sub_name!,
                                                                        widget
                                                                            .cal_sub_names[index]
                                                                            .id
                                                                            .toString());
                                                                    if (!error) {
                                                                      setState(
                                                                          () {
                                                                        widget
                                                                            .cal_sub_names[index]
                                                                            .subName = sub_name;
                                                                      });
                                                                    } else {
                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                          duration: Duration(milliseconds: 400),
                                                                          content: Text(
                                                                            "error occured please try again",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
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
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ))
                                    ])
                              : Container(),
                          _extand[index]
                              ? Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ratings" +
                                              "(" +
                                              widget.cal_sub_names[index]
                                                  .numRatings
                                                  .toString() +
                                              ") : " +
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
                                                            duration: Duration(
                                                                milliseconds:
                                                                    400),
                                                            content: Text(
                                                              "please wait data is loading.",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )));
                                              }
                                            },
                                            child: Given_Rating(sub_rating))
                                      ]),
                                  const SizedBox(height: 10),
                                  _loaded[index]
                                      ? Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Update your Rating : ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        minimumSize:
                                                            Size(30, 30),
                                                        side: const BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                  content: Show_all_sub_ratings(
                                                                      all_sub_ratings,
                                                                      widget
                                                                          .app_user));
                                                            });
                                                      },
                                                      child: const Text(
                                                          "See All",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))),
                                                )
                                              ],
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
                              : Container()
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}

class place_years extends StatefulWidget {
  Username app_user;
  CAL_SUB_NAMES cal_sub_name;
  List<CAL_SUB_YEARS> cal_sub_years_list;
  place_years(this.app_user, this.cal_sub_name, this.cal_sub_years_list);

  @override
  State<place_years> createState() => _place_yearsState();
}

class _place_yearsState extends State<place_years> {
  var year_name;
  var loaded_data = false;
  List<CAL_SUB_YEARS> sub_years = [];

  void load_data_fun() async {
    List<CAL_SUB_YEARS> sub_years1 = await placemeny_servers()
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
                                    width: wid / 2,
                                    child: Text(
                                      widget.cal_sub_name.subName!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      build_screen()
                    ])))),
        floatingActionButton: widget.app_user.is_placement_admin!
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
                                              await placemeny_servers()
                                                  .add_cal_sub_year(
                                                      widget.cal_sub_name.id
                                                          .toString(),
                                                      year_name,
                                                      false);

                                          if (!error[0]) {
                                            CAL_SUB_YEARS new_sub_year =
                                                CAL_SUB_YEARS();
                                            new_sub_year.id = error[1];
                                            new_sub_year.yearName = year_name;
                                            new_sub_year.private = false;
                                            new_sub_year.username =
                                                user_min(widget.app_user);
                                            setState(() {
                                              sub_years.add(new_sub_year);
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    content: Text(
                                                      "Added Successfully",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )));
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
                                builder: (BuildContext context) => yearFiles(
                                    widget.app_user,
                                    const [],
                                    sub_years[index],
                                    widget.cal_sub_name.subId!)));
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
                                        if (!widget
                                            .app_user.is_placement_admin!) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                "Students are not allowed",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        } else {
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

                                                                  bool error = await placemeny_servers().edit_cal_year(
                                                                      year_name!,
                                                                      sub_years[
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                      false);
                                                                  if (!error) {
                                                                    setState(
                                                                        () {
                                                                      sub_years[index]
                                                                              .yearName =
                                                                          year_name;
                                                                      sub_years[index]
                                                                              .private =
                                                                          false;
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
                                                              },
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                    "update"),
                                                              ))
                                                        ]));
                                              });
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

class yearFiles extends StatefulWidget {
  Username app_user;
  List<CAL_SUB_FILES> cal_sub_files;
  CAL_SUB_YEARS sub_year;
  String sub_id;
  yearFiles(this.app_user, this.cal_sub_files, this.sub_year, this.sub_id);

  @override
  State<yearFiles> createState() => _yearFilesState();
}

class _yearFilesState extends State<yearFiles> {
  var file_name;
  var file;
  String file_type = "";
  var loaded_data = false;
  List<CAL_SUB_FILES> sub_files = [];

  void load_data_fun() async {
    List<CAL_SUB_FILES> sub_files1 = await placemeny_servers()
        .get_sub_files_list(widget.sub_year.id.toString());
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
    List<dynamic> error = await placemeny_servers()
        .post_cal_sub_files(file, widget.sub_year.id.toString(), file_type);
    if (!error[0]) {
      setState(() {
        new_file.id = error[1];
        new_file.uploaded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 400),
          content: Text(
            "Added Successfully",
            style: TextStyle(color: Colors.white),
          )));
    } else {
      setState(() {
        widget.cal_sub_files.remove(new_file);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 400),
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
                duration: Duration(milliseconds: 400),
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
              duration: Duration(milliseconds: 400),
              content: Text(
                "Guests are not allowed",
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
                              bool error = await placemeny_servers()
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
                                        duration: Duration(milliseconds: 400),
                                        content: Text(
                                          "error occured please try again",
                                          style: TextStyle(color: Colors.white),
                                        )));
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
                                    List<dynamic> error =
                                        await placemeny_servers()
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
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                "edited successfully you ca go back and came again.",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                                duration:
                                                    Duration(milliseconds: 400),
                                                content: Text(
                                                  "error occured please go back and come again.",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
