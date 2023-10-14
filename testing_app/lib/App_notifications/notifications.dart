import 'package:flutter/material.dart';
import '/servers/servers.dart';
import '/models/models.dart';
//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;

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
          future: servers().get_notifications_list(),
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
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(30),
                      child: const Center(
                        child: Text("No Announcements yet",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24)),
                      ));
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
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/event background.jpg"),
                fit: BoxFit.cover)),
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
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 48, //post.profile_pic
                  child: user.fileType == '1'
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic!))
                      : const CircleAvatar(
                          backgroundImage: AssetImage("images/profile.jpg")),
                ),
                const SizedBox(width: 10),
                Container(
                  width: width - 160,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif.username!.username! + " : " + notif.title!,
                            //"vidya sagar",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(notif.description!
                              //"B190838EC",
                              //style: TextStyle(color: Colors.white60),
                              )
                        ]),
                  ),
                ),
              ]),
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
                                            bool error = await servers()
                                                .delete_notification(notif.id!);
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
                                            style:
                                                TextStyle(color: Colors.white),
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
          )),
    );
  }
}
