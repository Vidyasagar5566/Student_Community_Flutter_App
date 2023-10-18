import 'package:flutter/material.dart';
import 'package:testing_app/Threads/threads.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'package:get_time_ago/get_time_ago.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import '/first_page.dart';
import 'Upload_opinion.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';

//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class alertwidget extends StatefulWidget {
  Username app_user;
  String domain;
  alertwidget(this.app_user, this.domain);

  @override
  State<alertwidget> createState() => _alertwidgetState();
}

class _alertwidgetState extends State<alertwidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ALERT_LIST>>(
      future: threads_servers().get_alert_list(widget.domain, 0),
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
            List<ALERT_LIST> alert_list = snapshot.data;
            if (alert_list.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Center(
                    child: Text(
                      "No Data Was Found",
                    ),
                  ));
            } else {
              all_alerts = alert_list;
              return alertwidget1(alert_list, widget.app_user, widget.domain);
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class alertwidget1 extends StatefulWidget {
  List<ALERT_LIST> alert_list;
  Username app_user;
  String domain;
  alertwidget1(this.alert_list, this.app_user, this.domain);

  @override
  State<alertwidget1> createState() => _alertwidget1State();
}

class _alertwidget1State extends State<alertwidget1> {
  bool total_loaded = true;
  void load_data_fun() async {
    List<ALERT_LIST> latest_alert_list = await threads_servers()
        .get_alert_list(widget.domain, all_alerts.length);
    if (latest_alert_list.length != 0) {
      all_alerts += latest_alert_list;
      setState(() {
        widget.alert_list = all_alerts;
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              itemCount: widget.alert_list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              itemBuilder: (BuildContext context, int index) {
                ALERT_LIST alert = widget.alert_list[index];
                return _buildLoadingScreen(alert, widget.alert_list);
              }),
          total_loaded
              ? widget.alert_list.length > 10
                  ? Container(
                      width: width,
                      height: 100,
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  total_loaded = false;
                                });
                                load_data_fun();
                              },
                              child: const Column(
                                children: [
                                  Icon(Icons.add_circle_outline,
                                      size: 40, color: Colors.blueGrey),
                                  Text(
                                    "Tap To Load more",
                                    style: TextStyle(color: Colors.blueGrey),
                                  )
                                ],
                              ))))
                  : Container()
              : Container(
                  width: 100,
                  height: 100,
                  child: Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(ALERT_LIST alert, List<ALERT_LIST> alert_list) {
    SmallUsername user = alert.username!;
    var wid = MediaQuery.of(context).size.width;
    var _convertedTimestamp =
        DateTime.parse(alert.postedDate!); // Converting into [DateTime] object
    String alert_posted_date = GetTimeAgo.parse(_convertedTimestamp);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return alert_commentwidget(
              alert, widget.app_user); //event_photowidget
        }));
      },
      child: Container(
          margin: const EdgeInsets.only(top: 8, left: 10, right: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(19)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: wid - 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    alert.category == 'student'
                        ? UserProfileMark(alert.username!)
                        : UserProfileMarkAdmin(alert, alert.username),
                    Text(alert_posted_date.substring(0, 7),
                        style: const TextStyle(
                            //     color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13))
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: wid - 50,
                child: Text(
                  alert.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    // color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: wid - 50,
                child: Text(
                  alert.description!,
                  style: const TextStyle(
                    //    color: Colors.white,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          )),
    );
  }
}

List<ALERT_CMNT> alert_cmnt_list = [];

class alert_commentwidget extends StatefulWidget {
  ALERT_LIST alert;
  Username app_user;
  alert_commentwidget(this.alert, this.app_user);

  @override
  State<alert_commentwidget> createState() => _alert_commentwidgetState();
}

class _alert_commentwidgetState extends State<alert_commentwidget> {
  var comment;
  bool sending_msg = false;

  bool load_data = false;
  load_data_fun(int id) async {
    alert_cmnt_list = await threads_servers().get_alert_cmnt_list(id);
    setState(() {
      load_data = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun(widget.alert.id!);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          title: Text(
            "Opinions (" + alert_cmnt_list.length.toString() + ")",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            widget.app_user.email == widget.alert.username!.email!
                ? IconButton(
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
                                          "Are you sure do you want to delete this thread?",
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
                                          bool error = await threads_servers()
                                              .delete_alert(widget.alert.id!);
                                          if (!error) {
                                            Navigator.pop(context);
                                            Navigator.of(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Error occured plz try again",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white))));
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
                      Icons.delete_forever,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                : Container()
          ],
          backgroundColor: Colors.indigoAccent[700]),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.alert.title!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              widget.alert.category == 'student'
                  ? UserProfileMark(widget.alert.username!)
                  : UserProfileMarkAdmin(widget.alert, widget.alert.username),
              const SizedBox(height: 20),
              Text(widget.alert.description!,
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 30),
              all_files_display(
                  widget.app_user, widget.alert.imgRatio!, widget.alert.img!),
              Divider(
                color: Colors.grey[350],
                height: 25,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
              load_data
                  ? alert_cmnt_list.length == 0
                      ? Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          child: Text("No Opinions yet"),
                        )
                      : lst_cmnt_page(widget.app_user, widget.alert)
                  : Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return upload_alert_cmnt(widget.app_user, widget.alert);
          })).then((value) async {
            setState(() {
              load_data = false;
            });
            await load_data_fun(widget.alert.id!);
            setState(() {
              load_data = true;
            });
          });
        },
        tooltip: 'wann share',
        child: Icon(
          Icons.add,
          color: Colors.blueAccent,
        ),
        elevation: 4.0,
      ),
    );
  }
}

class lst_cmnt_page extends StatefulWidget {
  Username app_user;
  ALERT_LIST alert;
  lst_cmnt_page(this.app_user, this.alert);

  @override
  State<lst_cmnt_page> createState() => _lst_cmnt_pageState();
}

class _lst_cmnt_pageState extends State<lst_cmnt_page> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          reverse: true,
          child: ListView.builder(
              itemCount: alert_cmnt_list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10),
              itemBuilder: (BuildContext context, int index) {
                ALERT_CMNT alert_cmnt = alert_cmnt_list[index];
                return _buildLoadingScreen(alert_cmnt, alert_cmnt_list);
              }),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen(
      ALERT_CMNT alert_cmnt, List<ALERT_CMNT> alert_cmnt_list) {
    SmallUsername user = alert_cmnt.username!;
    Username app_user = widget.app_user;
    var width = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserProfileMark(user),
              (user.email == app_user.email)
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
                                                alert_cmnt_list
                                                    .remove(alert_cmnt);
                                                Navigator.pop(context);
                                              });
                                              bool error =
                                                  await threads_servers()
                                                      .delete_alert_cmnt(
                                                          alert_cmnt.id!,
                                                          widget.alert.id!);
                                              if (error) {
                                                setState(() {
                                                  alert_cmnt_list
                                                      .add(alert_cmnt);
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
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          const SizedBox(height: 20),
          Text(
              alert_cmnt.insertMessage!
                  ? alert_cmnt.comment!
                  : utf8convert(alert_cmnt.comment!),
              style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 30),
          all_files_display(
              widget.app_user, alert_cmnt.imgRatio!, alert_cmnt.img!),
          Divider(
            color: Colors.grey[200],
            height: 25,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ]));
  }
}
