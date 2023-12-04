import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '/First_page.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/Servers.dart';
import 'dart:convert' show utf8;
import 'Uploads.dart';
import '/Reports/Uploads.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'dart:io';
import '/Files_disply_download/pdf_videos_images.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<String> BuyCtegory = [
  "All",
  "rideShares",
  "smartDevices",
  "belongings",
  "clothings",
  "usedCampusItems",
  "houseSharings",
  "others"
];

class all_buySellwidget1 extends StatefulWidget {
  Username app_user;
  String tag;
  String category;
  List<Buy_Sell> lst_buy_list;
  String domain;
  String email;
  all_buySellwidget1(this.app_user, this.tag, this.category, this.lst_buy_list,
      this.domain, this.email);

  @override
  State<all_buySellwidget1> createState() => _all_lostwidget1State();
}

class _all_lostwidget1State extends State<all_buySellwidget1> {
  bool total_loaded = false;
  void load_data_fun() async {
    List<Buy_Sell> latest_lst_list = await bs_servers().get_lst_list(
        widget.lst_buy_list.length,
        domains1[widget.domain]!,
        widget.tag,
        widget.category,
        widget.email);
    if (latest_lst_list.length != 0) {
      setState(() {
        widget.lst_buy_list += latest_lst_list;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: const Duration(milliseconds: 500),
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

  var comment;
  List<bool> sending_cmnt = [];
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.lst_buy_list.length; i++) {
      sending_cmnt.add(false);
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            "Sharings",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          actions: [
            Row(
              children: [
                DropdownButton<String>(
                    value: widget.tag,
                    underline: Container(),
                    elevation: 0,
                    items: ["All", "buy", "sell"]
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
                        widget.tag = value!;
                        setState(() {
                          widget.lst_buy_list = [];
                          total_loaded = false;
                          load_data_fun();
                        });
                      });
                    }),
                const SizedBox(width: 10),
                DropdownButton<String>(
                    value: widget.category,
                    underline: Container(),
                    elevation: 0,
                    items: BuyCtegory.map<DropdownMenuItem<String>>(
                        (String value) {
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
                        widget.category = value!;
                        setState(() {
                          widget.lst_buy_list = [];
                          total_loaded = false;
                          load_data_fun();
                        });
                      });
                    }),
              ],
            )
          ],
          backgroundColor: Colors.white70,
        ),
        body: !total_loaded && widget.lst_buy_list.length == 0
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : widget.lst_buy_list.length != 0
                ? _listViewItems(
                    widget.app_user, widget.lst_buy_list, widget.tag)
                : total_loaded && widget.lst_buy_list.length == 0
                    ? Container(
                        margin: const EdgeInsets.all(30),
                        padding: const EdgeInsets.all(30),
                        child: const Center(
                          child: Text(
                            "No Data Was Found",
                          ),
                        ))
                    : _listViewItems(
                        widget.app_user, widget.lst_buy_list, widget.tag),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return buy_sell_upload(widget.app_user, 'buy', 'belongings');
            }));
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
      Username app_user, List<Buy_Sell> lst_list, String tag) {
    return lst_list.isEmpty
        ? Container(
            margin: EdgeInsets.only(top: 100),
            child: const Center(
                child: Text(
              "No Data Was Found",
            )))
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge) {
                    bool isTop = metrics.pixels == 0;
                    if (!isTop) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.white,
                          content: Text("loading....",
                              style: TextStyle(color: Colors.black))));
                      if (total_loaded) {
                        load_data_fun();
                      }
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                    itemCount: lst_list.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      Buy_Sell lst = lst_list[index];
                      var _convertedTimestamp = DateTime.parse(
                          lst.postedDate!); // Converting into [DateTime] object
                      String lst_posted_date =
                          GetTimeAgo.parse(_convertedTimestamp);
                      return _buildLoadingScreen(
                          lst, index, lst_posted_date, lst_list);
                    })),
          );
  }

  Widget _buildLoadingScreen(Buy_Sell lst, int index, String lst_posted_date,
      List<Buy_Sell> lst_list) {
    var width = MediaQuery.of(context).size.width;
    SmallUsername user = lst.username!;
    return GestureDetector(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // Shadow color
                  offset: Offset(
                      0, 1), // Offset of the shadow (horizontal, vertical)
                  blurRadius: 4, // Spread of the shadow
                  spreadRadius: 0, // Expansion of the shadow
                ),
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserProfileMark(widget.app_user, user),
                      SizedBox(
                          width: (width - 36) / 4,
                          height: 30,
                          child: OutlinedButton(
                            onPressed: () {
                              if (widget.app_user.email ==
                                  lst.username!.email) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return lst_commentwidget(
                                      lst, widget.app_user);
                                }));
                              } else if (sending_cmnt[index] == false) {
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
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 40, right: 40),
                                                  child: TextField(
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: const InputDecoration(
                                                        labelText:
                                                            "Write Your Text",
                                                        hintText:
                                                            "i want to sell/buy this",
                                                        prefixIcon: Icon(
                                                            Icons.text_fields),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10)))),
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        comment = value;
                                                        if (comment == "") {
                                                          comment = null;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                OutlinedButton(
                                                    onPressed: () async {
                                                      if (comment == null) {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    400),
                                                            content: Text(
                                                              "name cant be null",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          sending_cmnt[index] =
                                                              true;
                                                        });
                                                        List<dynamic> error =
                                                            await bs_servers()
                                                                .post_lst_cmnt(
                                                                    comment,
                                                                    lst.id!);
                                                        if (!error[0]) {
                                                          setState(() {
                                                            sending_cmnt[
                                                                index] = false;
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      content:
                                                                          Text(
                                                                        "Request was sent successfully",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      content:
                                                                          Text(
                                                                        "error occured please try again",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                        }
                                                      }
                                                    },
                                                    child: const Text("Request",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blue)))
                                              ]));
                                    });
                              }
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
                            child: widget.app_user.email == lst.username!.email
                                ? const Text(
                                    "open?",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                : sending_cmnt[index] == false
                                    ? (lst.tag == "buy"
                                        ? const Text(
                                            "sell?",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          )
                                        : const Text(
                                            "buy?",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ))
                                    : const SizedBox(
                                        height: 13,
                                        width: 13,
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                                width: (width - 20) / 3,
                                child: Text(lst.title!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                if (lst.imgRatio == 1.0) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return image_display(
                                        false,
                                        File('images/buy sell avatar.png'),
                                        lst.img!);
                                  }));
                                }
                              },
                              child: Container(
                                decoration: lst.imgRatio == 1
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: const DecorationImage(
                                            scale: 10,
                                            image: AssetImage(
                                                'images/loading.png')))
                                    : BoxDecoration(),
                                child: Container(
                                  width: (width - 20) / 3,
                                  height: (width - 20) / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: lst.imgRatio == 0
                                        ? const DecorationImage(
                                            image: AssetImage(
                                                'images/buy sell avatar.png'),
                                            fit: BoxFit.cover)
                                        : DecorationImage(
                                            image: NetworkImage(lst.img!),
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(children: [
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
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            width: (width - 20) / 2,
                                            child: Text(
                                              utf8convert(lst.description!),
                                              style: const TextStyle(
                                                fontSize:
                                                    13, //color: Colors.white
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            width: (width - 20) / 2,
                                            child: Text(
                                              user.email!,
                                              style: const TextStyle(
                                                fontSize:
                                                    10, //color: Colors.white
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            width: (width - 20) / 2,
                                            child: Text(
                                              lst_posted_date,
                                              style: const TextStyle(
                                                fontSize:
                                                    10, //color: Colors.white
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return report_upload(
                                                      widget.app_user,
                                                      "lost/found" +
                                                          " with id :" +
                                                          lst.id.toString(),
                                                      lst.username!.email!);
                                                }));
                                              },
                                              child: const Text(
                                                  "Report this post?")),
                                          TextButton(
                                              onPressed: () async {
                                                if (widget.app_user.email!
                                                        .split('@')[0] ==
                                                    "guest") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          content: Text(
                                                              "guest cannot hide contents..",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))));
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            content: Container(
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              child: const Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                        "Please wait while updating....."),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    CircularProgressIndicator()
                                                                  ]),
                                                            ));
                                                      });
                                                  bool error =
                                                      await bs_servers()
                                                          .hide_lst(lst.id!);
                                                  Navigator.pop(context);
                                                  if (!error) {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                      return firstpage(
                                                          0, widget.app_user);
                                                    }),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      content: Text(
                                                          'We will remove These type of posts in your feed,',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ));
                                                  } else {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        content: Column(
                                                          children: [
                                                            Text(
                                                              'error occured try again',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                          lst.username!.email
                                                              .toString(),
                                                      lst.username!.email!);
                                                }));
                                              },
                                              child: Text("Report This User?")),
                                          const SizedBox(height: 20),
                                          widget.app_user.email ==
                                                  lst.username!.email
                                              ? Column(
                                                  children: [
                                                    const Center(
                                                        child: Text(
                                                            "Do you want to delete this?",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              30),
                                                      child: OutlinedButton(
                                                          onPressed: () async {
                                                            bool error =
                                                                await bs_servers()
                                                                    .delete_lst(
                                                                        lst.id!);
                                                            if (!error) {
                                                              setState(() {
                                                                lst_list.remove(
                                                                    lst);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: const Center(
                                                              child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ))),
                                                    ),
                                                  ],
                                                )
                                              : Container()
                                        ])
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Text("Category : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(lst.category!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1)
                                ]),
                                const SizedBox(height: 3),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  width: (width - 20) / 2,
                                  child: Text(
                                    utf8convert(lst.description!),
                                    style: const TextStyle(
                                      fontSize: 13, //color: Colors.white
                                    ),
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  width: (width - 20) / 2,
                                  child: Text(
                                    user.email!,
                                    style: const TextStyle(
                                      fontSize: 10, //color: Colors.white
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  width: (width - 20) / 2,
                                  child: Text(
                                    lst_posted_date,
                                    style: const TextStyle(
                                      fontSize: 10, //color: Colors.white
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ]),
                        )
                      ]),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.lst_buy_list = [];
  }
}

class lst_commentwidget extends StatefulWidget {
  Buy_Sell lst;
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
        body: FutureBuilder<List<BS_CMNT>>(
          future: bs_servers().get_lst_cmnt_list(widget.lst.id!),
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
                List<BS_CMNT> lst_cmnt_list = snapshot.data;
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
  List<BS_CMNT> lst_cmnt_list;
  Username app_user;
  Buy_Sell lst;
  lst_cmnt_page(this.lst_cmnt_list, this.app_user, this.lst);

  @override
  State<lst_cmnt_page> createState() => _lst_cmnt_pageState();
}

class _lst_cmnt_pageState extends State<lst_cmnt_page> {
  var comment;
  bool sending_cmnt = false;
  @override
  Widget build(BuildContext context) {
    List<BS_CMNT> lst_cmnt_list = widget.lst_cmnt_list;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
            height: height - 110,
            width: width,
            child: SingleChildScrollView(
              reverse: true,
              child: lst_cmnt_list.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 100),
                      child: const Center(
                          child: Text(
                        "No Comments Yet",
                        style: TextStyle(color: Colors.white),
                      )))
                  : ListView.builder(
                      itemCount: widget.lst_cmnt_list.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 10),
                      itemBuilder: (BuildContext context, int index) {
                        BS_CMNT lst_cmnt = lst_cmnt_list[index];

                        return _buildLoadingScreen(lst_cmnt);
                      }),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //     colors: [Colors.deepPurple, Colors.purple.shade300],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   )),
          //   child: Container(
          //     height: 80,
          //     decoration: BoxDecoration(
          //         color: Colors.grey[400],
          //         borderRadius: BorderRadius.circular(20)),
          //     padding: const EdgeInsets.only(right: 12),
          //     margin: const EdgeInsets.all(20),
          //     width: width,
          //     child: Row(
          //       //mainAxisSize: MainAxisSize.max,
          //       children: [
          //         SizedBox(
          //           width: width * 0.70,
          //           child: TextFormField(
          //             style: const TextStyle(color: Colors.black),
          //             keyboardType: TextInputType.multiline,
          //             minLines: 1, //Normal textInputField will be displayed
          //             maxLines: 2,
          //             autofocus: true,
          //             decoration: const InputDecoration(
          //               labelText: 'comment',
          //               hintText: 'add comment',
          //               prefixIcon: Icon(Icons.text_fields),
          //               border: InputBorder.none,
          //             ),
          //             onChanged: (String value) {
          //               setState(() {
          //                 comment = value;
          //                 if (comment == "") {
          //                   comment = null;
          //                 }
          //               });
          //             },
          //             validator: (value) {
          //               return value!.isEmpty ? 'please enter email' : null;
          //             },
          //           ),
          //         ),
          //         const SizedBox(width: 2),
          //         (comment == null && sending_cmnt == false)
          //             ? Container(
          //                 child: IconButton(
          //                 onPressed: () {},
          //                 icon: const Icon(
          //                   Icons.double_arrow,
          //                   size: 30,
          //                   color: Colors.grey,
          //                 ),
          //               ))
          //             : (comment != null)
          //                 ? Container(
          //                     child: IconButton(
          //                       onPressed: () async {
          //                        if (widget.app_user.email!.split('@')[0] == "guest") {
          //                           ScaffoldMessenger.of(context).showSnackBar(
          //                               const SnackBar(
          //                                   duration: const Duration(
          //                                       milliseconds: 500),
          //                                   content: Text(
          //                                       "guest cannot share comments..",
          //                                       style: TextStyle(
          //                                           color: Colors.white))));
          //                         } else {
          //                           LST_CMNT a = LST_CMNT();
          //                           String curr_comment = comment;
          //                           a.username = user_min(widget.app_user);
          //                           a.comment = curr_comment;
          //                           a.lstCmntId = widget.lst.id;
          //                           a.postedDate = "";
          //                           a.messageSent = false;
          //                           a.insertMessage = true;
          //                           lst_cmnt_list.add(a);
          //                           setState(() {
          //                             comment = null;
          //                             sending_cmnt = true;
          //                           });
          //                           List<dynamic> error = await bs_lf_servers()
          //                               .post_lst_cmnt(
          //                                   curr_comment, widget.lst.id!);
          //                           setState(() {
          //                             sending_cmnt = false;
          //                           });

          //                           if (!error[0]) {
          //                             setState(() {
          //                               sending_cmnt = false;
          //                               a.id = error[1];
          //                               a.messageSent = true;
          //                             });
          //                             await Future.delayed(
          //                                 Duration(seconds: 2));

          //                             bool error1 = await servers()
          //                                 .send_notifications(
          //                                     widget.app_user.email!,
          //                                     " Commented on " +
          //                                         " : " +
          //                                         widget.lst.title! +
          //                                         " : " +
          //                                         comment,
          //                                     6);
          //                             if (error1) {
          //                               ScaffoldMessenger.of(context)
          //                                   .showSnackBar(const SnackBar(
          //                                       duration: const Duration(
          //                                           milliseconds: 500),
          //                                       content: Text(
          //                                           "Failed to send notifications",
          //                                           style: TextStyle(
          //                                               color: Colors.white))));
          //                             }
          //                           } else {
          //                             lst_cmnt_list.remove(a);
          //                           }
          //                         }
          //                       },
          //                       icon: const Icon(Icons.double_arrow,
          //                           size: 38, color: Colors.blue),
          //                     ),
          //                   )
          //                 : Container()
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(
    BS_CMNT lst_cmnt,
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
                                            child: OutlinedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.lst_cmnt_list
                                                        .remove(lst_cmnt);
                                                    Navigator.pop(context);
                                                  });
                                                  bool error =
                                                      await bs_servers()
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
                                                      color: Colors.blue),
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
