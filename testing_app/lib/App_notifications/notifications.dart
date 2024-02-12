import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;
import '../Servers_Fcm_Notif_Domains/servers.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class notifications extends StatefulWidget {
  Username app_user;
  notifications(this.app_user);

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            "Announcements",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: FutureBuilder<List<Notifications>>(
          future: app_notif_servers().get_notifications_list(),
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
                List<Notifications> notif_list = snapshot.data;
                if (notif_list.length == 0) {
                  return Container(
                      margin: const EdgeInsets.all(30),
                      padding: const EdgeInsets.all(30),
                      child: const Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text("😔",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.yellow)),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              "Not Found Any Announcements Yet",
                              //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              "Start Sharing...",
                              //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                            ),
                          ),
                        ],
                      )));
                  ;
                } else {
                  return notifications1(notif_list, widget.app_user);
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

class notifications1 extends StatefulWidget {
  List<Notifications> notif_list;
  Username app_user;
  notifications1(this.notif_list, this.app_user);

  @override
  State<notifications1> createState() => _notifications1State();
}

class _notifications1State extends State<notifications1> {
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Container(
        width: wid, //foo1(img_file),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: ListView.builder(
              itemCount: widget.notif_list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10),
              itemBuilder: (BuildContext context, int index) {
                Notifications notif = widget.notif_list[index];
                return _buildLoadingScreen(notif, widget.notif_list);
              }),
        ));
  }

  Widget _buildLoadingScreen(
      Notifications notif, List<Notifications> notif_list) {
    SmallUsername user = notif.username!;
    var width = MediaQuery.of(context).size.width;
    String delete_error = "";
    return GestureDetector(
      child: Container(
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserProfileMark(widget.app_user, notif.username!),
                  user.username == widget.app_user.username
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
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.close))
                                            ]),
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
                                                bool error =
                                                    await app_notif_servers()
                                                        .delete_notification(
                                                            notif.id!);
                                                if (!error) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    notif_list.remove(notif);
                                                  });
                                                } else {
                                                  setState(() {
                                                    delete_error =
                                                        "check your connection";
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
                                                child: Text(delete_error),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            size: 25,
                            color: Colors.blue,
                          ),
                        )
                      : Container()
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
                    child: Text(
                      utf8convert(notif.title!),
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
                    child: SelectableLinkify(
                      onOpen: (url) async {
                        if (await canLaunch(url.url)) {
                          await launch(url.url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      text: utf8convert(notif.description!),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
