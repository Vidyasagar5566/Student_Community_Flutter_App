import 'dart:async';
import 'package:flutter/material.dart';
import '../first_page.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'dart:convert' show utf8;
import 'Uploads.dart';
import 'package:testing_app/Reports/Uploads.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'dart:io';
import '../Files_disply_download/pdf_videos_images.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class all_lostwidget1 extends StatefulWidget {
  Username app_user;
  String tag;
  List<Lost_Found> lst_buy_list;
  String domain;
  all_lostwidget1(this.app_user, this.tag, this.lst_buy_list, this.domain);

  @override
  State<all_lostwidget1> createState() => _all_lostwidget1State();
}

class _all_lostwidget1State extends State<all_lostwidget1> {
  bool total_loaded = false;
  void load_data_fun() async {
    List<Lost_Found> latest_lst_list = await bs_lf_servers()
        .get_lst_list(lst_buy_list.length, domains1[widget.domain]!);
    if (latest_lst_list.length != 0) {
      lst_buy_list += latest_lst_list;
      setState(() {
        widget.lst_buy_list = lst_buy_list;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("all the feed was shown..",
              style: TextStyle(color: Colors.white))));
    }
    setState(() {
      total_loaded = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun();
  }

  @override
  Widget build(BuildContext context) {
    List<Lost_Found> lst_list1 = [];
    for (int i = 0; i < widget.lst_buy_list.length; i++) {
      if (widget.lst_buy_list[i].tag == widget.tag) {
        lst_list1.add(widget.lst_buy_list[i]);
      }
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          title: widget.tag == "lost/found"
              ? const Text(
                  "Lost And Founds",
                  style: TextStyle(color: Colors.black),
                )
              : const Text(
                  "Sharings",
                  style: TextStyle(color: Colors.black),
                ),
          actions: [
            DropdownButton<String>(
                value: widget.domain,
                underline: Container(),
                elevation: 0,
                items:
                    domains_list.map<DropdownMenuItem<String>>((String value) {
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
                    lst_buy_list = [];
                    total_loaded = false;
                    load_data_fun();
                  });
                })
          ],
          backgroundColor: Colors.white70,
        ),
        body: !total_loaded && lst_buy_list.length == 0
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : lst_buy_list.length != 0
                ? _listViewItems(widget.app_user, lst_list1, widget.tag)
                : total_loaded && lst_buy_list.length == 0
                    ? Container(
                        margin: const EdgeInsets.all(30),
                        padding: const EdgeInsets.all(30),
                        child: const Center(
                          child: Text(
                            "No Data Was Found",
                          ),
                        ))
                    : _listViewItems(widget.app_user, lst_list1, widget.tag),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.tag == "lost/found") {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return lst_found_upload(widget.app_user);
              }));
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return buy_sell_upload(widget.app_user);
              }));
            }
          },
          tooltip: 'wann share',
          child: Icon(
            Icons.add,
            color: Colors.blueAccent,
          ),
          elevation: 4.0,
        ));
  }

  Widget _listViewItems(
      Username app_user, List<Lost_Found> lst_list, String tag) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              //image: post.post_pic,
              image: AssetImage("images/event background.jpg"),
              fit: BoxFit.cover)),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              bool isTop = metrics.pixels == 0;
              if (!isTop) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.white,
                    content: Text("loading....",
                        style: TextStyle(color: Colors.black))));
                load_data_fun();
              }
            }
            return true;
          },
          child: ListView.builder(
              itemCount: lst_list.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                Lost_Found lst = lst_list[index];
                var _convertedTimestamp = DateTime.parse(
                    lst.postedDate!); // Converting into [DateTime] object
                String lst_posted_date = GetTimeAgo.parse(_convertedTimestamp);
                return _buildLoadingScreen(
                    lst, index, lst_posted_date, lst_list);
              })),
    );
  }

  Widget _buildLoadingScreen(Lost_Found lst, int index, String lst_posted_date,
      List<Lost_Found> lst_list) {
    const IconData verified = IconData(0xe699, fontFamily: 'MaterialIcons');
    var width = MediaQuery.of(context).size.width;
    SmallUsername user = lst.username!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return lost_photowidget(lst, lst.description!, lst.img!, lst.title!,
              user, widget.app_user, lst_list);
        }));
      },
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48, //post.profile_pic
                            child: user.fileType == '1'
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.profilePic!))
                                : const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("images/profile.jpg")),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            width: (width - 36) / 1.8,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: (width - 36) / 2.4),
                                        child: Text(
                                          user.username!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      userMarkNotation(user.starMark!)
                                    ],
                                  ),
                                  Text(
                                    domains[user.domain!]! +
                                        " (" +
                                        user.userMark! +
                                        ")",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      SizedBox(
                          width: (width - 36) / 4,
                          height: 30,
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return lst_commentwidget(
                                      lst, widget.app_user);
                                }));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ))),
                              child: const Text(
                                "Reply",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              )))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          utf8convert(lst.description!),
                          //'''My black crocs kept outside my room(6A 38) are missing from todays afternoon.if anyone took it by mistake please keep them back. the picture is attached down.''',
                          //lst_list.description
                          style: const TextStyle(
                            fontSize: 13, //color: Colors.white
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${user.email!}  (Tap to see)",
                        //"contact to "  + (lst_list.username.email).toString(),
                        style: const TextStyle(
                          fontSize: 10, //color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        lst_posted_date,
                        style: const TextStyle(
                          fontSize: 10, //color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    lst_buy_list = [];
  }
}

class lost_photowidget extends StatefulWidget {
  Lost_Found lst;
  String description;
  String img;
  String title;
  SmallUsername user;
  Username app_user;
  List<Lost_Found> lst_list;
  lost_photowidget(this.lst, this.description, this.img, this.title, this.user,
      this.app_user, this.lst_list);
//  const lost_photowidget({super.key});

  @override
  State<lost_photowidget> createState() => _lost_photowidgetState();
}

class _lost_photowidgetState extends State<lost_photowidget> {
  @override
  Widget build(BuildContext context) {
    String delete_error = "";
    final SmallUsername lst_user = widget.user;
    final Username app_user = widget.app_user;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.blue, // <-- SEE HERE
        ),
        title: widget.lst.tag! == "lost/found"
            ? Text(
                widget.lst.tag!,
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                "Buy/Sell",
                style: TextStyle(color: Colors.black),
              ),
        actions: [
          lst_user.email == app_user.email
              ? Center(
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
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
                                  const SizedBox(height: 20),
                                  const Center(
                                      child: Text(
                                          "Are you sure do you want to delete this?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    color: Colors.blue[900],
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          bool error = await bs_lf_servers()
                                              .delete_lst(widget.lst.id!);
                                          if (!error) {
                                            Navigator.pop(context);
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return firstpage(
                                                  0, widget.app_user);
                                            }),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }
                                        },
                                        child: const Center(
                                            child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ))),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 31,
                      color: Colors.blue,
                    ),
                  ),
                )
              : Center(
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
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
                                            icon: Icon(Icons.close))
                                      ]),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return report_upload(
                                              widget.app_user,
                                              "lost/found" +
                                                  " with id :" +
                                                  widget.lst.id.toString(),
                                              widget.lst.username!.email!);
                                        }));
                                      },
                                      child: const Text("Report this post?")),
                                  TextButton(
                                      onPressed: () async {
                                        if (widget.app_user.email ==
                                            "guest@nitc.ac.in") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "guest cannot hide contents..",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))));
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    content: Container(
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      child: const Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                "Please wait while updating....."),
                                                            SizedBox(
                                                                height: 10),
                                                            CircularProgressIndicator()
                                                          ]),
                                                    ));
                                              });
                                          bool error = await bs_lf_servers()
                                              .hide_lst(widget.lst.id!);
                                          Navigator.pop(context);
                                          if (!error) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return firstpage(
                                                  0, widget.app_user);
                                            }),
                                                    (Route<dynamic> route) =>
                                                        false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'We will remove These type of posts in your feed,',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ));
                                          } else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Column(
                                                  children: [
                                                    Text(
                                                      'error occured try again',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                          "Hide this type of content?")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return report_upload(
                                              widget.app_user,
                                              "User: " +
                                                  widget.lst.username!.email
                                                      .toString(),
                                              widget.lst.username!.email!);
                                        }));
                                      },
                                      child: Text("Report This User?"))
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.report,
                      size: 31,
                      color: Colors.blue,
                    ),
                  ),
                )
        ],
        backgroundColor: Colors.white70,
      ),
      body: Container(
          color: Colors.indigo,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(utf8convert(widget.title),
                      //'''My black crocs kept outside my room(6A 38) are missing from todays afternoon.if anyone took it by mistake please keep them back. the picture is attached down.''',
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: //Link
                      Text(utf8convert(widget.description),
                          //'''My black crocs kept outside my room(6A 38) are missing from todays afternoon.if anyone took it by mistake please keep them back. the picture is attached down.''',
                          style: const TextStyle(
                            fontSize: 18,
                          )),
                ),
                const SizedBox(height: 10),
                widget.lst.imgRatio == 1
                    ? const Text(
                        "Image : ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    : Container(),
                const SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.all(10),
                    decoration: widget.lst.imgRatio == 1
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white)
                        : BoxDecoration(),
                    child: Column(
                      children: [
                        widget.lst.imgRatio == 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return image_display(false,
                                        File('images/icon.png'), widget.img);
                                  }));
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: width,
                                    width: width,
                                    child: Image.network(widget.img),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}

class lst_commentwidget extends StatefulWidget {
  Lost_Found lst;
  Username app_user;
  lst_commentwidget(this.lst, this.app_user);

  @override
  State<lst_commentwidget> createState() => _lst_commentwidgetState();
}

class _lst_commentwidgetState extends State<lst_commentwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          title: const Text(
            "comments",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: FutureBuilder<List<LST_CMNT>>(
          future: bs_lf_servers().get_lst_cmnt_list(widget.lst.id!),
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
                List<LST_CMNT> lst_cmnt_list = snapshot.data;
                return lst_cmnt_page(
                    lst_cmnt_list, widget.app_user, widget.lst);
              }
            }
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ));
  }
}

class lst_cmnt_page extends StatefulWidget {
  List<LST_CMNT> lst_cmnt_list;
  Username app_user;
  Lost_Found lst;
  lst_cmnt_page(this.lst_cmnt_list, this.app_user, this.lst);

  @override
  State<lst_cmnt_page> createState() => _lst_cmnt_pageState();
}

class _lst_cmnt_pageState extends State<lst_cmnt_page> {
  var comment;
  bool sending_cmnt = false;
  @override
  Widget build(BuildContext context) {
    List<LST_CMNT> lst_cmnt_list = widget.lst_cmnt_list;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              reverse: true,
              child: ListView.builder(
                  itemCount: widget.lst_cmnt_list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 10),
                  itemBuilder: (BuildContext context, int index) {
                    LST_CMNT lst_cmnt = lst_cmnt_list[index];

                    return _buildLoadingScreen(lst_cmnt);
                  }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(right: 12),
              margin: const EdgeInsets.all(20),
              width: width,
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: width * 0.70,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1, //Normal textInputField will be displayed
                      maxLines: 2,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'comment',
                        hintText: 'add comment',
                        prefixIcon: Icon(Icons.text_fields),
                        border: InputBorder.none,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          comment = value;
                          if (comment == "") {
                            comment = null;
                          }
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'please enter email' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 2),
                  (comment == null && sending_cmnt == false)
                      ? Container(
                          child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.double_arrow,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ))
                      : (comment != null)
                          ? Container(
                              child: IconButton(
                                onPressed: () async {
                                  if (widget.app_user.email ==
                                      "guest@nitc.ac.in") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "guest cannot share comments..",
                                                style: TextStyle(
                                                    color: Colors.white))));
                                  } else {
                                    LST_CMNT a = LST_CMNT();
                                    String curr_comment = comment;
                                    a.username = user_min(widget.app_user);
                                    a.comment = curr_comment;
                                    a.lstCmntId = widget.lst.id;
                                    a.postedDate = "";
                                    a.messageSent = false;
                                    a.insertMessage = true;
                                    lst_cmnt_list.add(a);
                                    setState(() {
                                      comment = null;
                                      sending_cmnt = true;
                                    });
                                    List<dynamic> error = await bs_lf_servers()
                                        .post_lst_cmnt(
                                            curr_comment, widget.lst.id!);
                                    setState(() {
                                      sending_cmnt = false;
                                    });

                                    if (!error[0]) {
                                      setState(() {
                                        sending_cmnt = false;
                                        a.id = error[1];
                                        a.messageSent = true;
                                      });
                                      await Future.delayed(
                                          Duration(seconds: 2));

                                      bool error1 = await servers()
                                          .send_notifications(
                                              widget.app_user.email!,
                                              " Commented on " +
                                                  " : " +
                                                  widget.lst.title! +
                                                  " : " +
                                                  comment,
                                              5);
                                      if (error1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Failed to send notifications",
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      }
                                    } else {
                                      lst_cmnt_list.remove(a);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.double_arrow,
                                    size: 38, color: Colors.blue),
                              ),
                            )
                          : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(
    LST_CMNT lst_cmnt,
  ) {
    String delete_error = "";
    SmallUsername user = lst_cmnt.username!;
    return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const Icon(
                Icons.person_2_outlined,
                size: 31,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                user.email!,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
              const SizedBox(
                width: 50,
              ),
              (!lst_cmnt.messageSent!)
                  ? const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(color: Colors.blue))
                  : (user.email == widget.app_user.email)
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
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
                                          const SizedBox(height: 20),
                                          const Center(
                                              child: Text(
                                                  "Are you sure do you want to delete this?",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          const SizedBox(height: 10),
                                          Container(
                                            margin: const EdgeInsets.all(30),
                                            color: Colors.blue[900],
                                            child: OutlinedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.lst_cmnt_list
                                                        .remove(lst_cmnt);
                                                    Navigator.pop(context);
                                                  });
                                                  bool error =
                                                      await bs_lf_servers()
                                                          .delete_lst_cmnt(
                                                              lst_cmnt.id!,
                                                              widget.lst.id!);
                                                  if (error) {
                                                    setState(() {
                                                      widget.lst_cmnt_list
                                                          .add(lst_cmnt);
                                                    });
                                                  }
                                                },
                                                child: const Center(
                                                    child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                          ),
                                          const SizedBox(height: 10),
                                          delete_error != ""
                                              ? Center(
                                                  child: Text(delete_error,
                                                      style: const TextStyle(
                                                          color: Colors.black)),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 31,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : Container()
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                "Comment : ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: Text(lst_cmnt.insertMessage!
                        ? lst_cmnt.comment!
                        : utf8convert(lst_cmnt.comment!)
                    //   "This is the ultimate opportunity for us to experience the thrill of competition and spirit of camaraderie"
                    ),
              ),
            ],
          )
        ]));
  }
}
