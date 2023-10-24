import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/User_profile/Servers.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';
import 'package:testing_app/User_profile/User_posts_category.dart';
import 'package:testing_app/Activities/Activities.dart';
import 'package:testing_app/Threads/Threads.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<Tab> tabs = const [
  Tab(
    child: Text(
      "About",
      style: TextStyle(color: Colors.black),
    ),
  ),
  Tab(
      child: Text(
    "fest members",
    style: TextStyle(color: Colors.black),
  )),
  Tab(
    child: Text(
      "Media files",
      style: TextStyle(color: Colors.black),
    ),
  ),
];

class festpagewidget extends StatefulWidget {
  ALL_FESTS fest;
  Username app_user;
  festpagewidget(this.fest, this.app_user);

  @override
  State<festpagewidget> createState() => _festpagewidgetState();
}

class _festpagewidgetState extends State<festpagewidget> {
  @override
  Widget build(BuildContext context) {
    final double coverheight = 100;
    final double profileheight = 50;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.blue, // <-- SEE HERE
            ),
            centerTitle: true,
            title: Text(
              widget.fest.head!.username!,
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white70,
          ),
          body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      //image: post.post_pic,
                      image: AssetImage("images/event background.jpg"),
                      fit: BoxFit.cover)),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              bottom: profileheight / 2,
                              left: 4,
                              right: 4,
                              top: 4),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "images/fests.webp",
                                width: double.infinity,
                                height: coverheight,
                                fit: BoxFit.cover,
                              ))),
                      Positioned(
                        top: coverheight - profileheight / 2,
                        child: CircleAvatar(
                            radius: 2 + profileheight / 2,
                            backgroundColor: Colors.grey[700],
                            child: CircleAvatar(
                              radius: profileheight / 2,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(widget.fest.logo!
                                  //"images/fest-clun-profile.png"
                                  ),
                            )),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.fest.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      height: 50,
                      child: AppBar(
                          backgroundColor: Colors.white,
                          bottom: TabBar(
                            indicator: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(30), // Creates border
                                color: Colors.blue),
                            indicatorColor: Colors.white,
                            isScrollable: true,
                            labelColor: Colors.black,
                            tabs: tabs,
                          ))),
                  Expanded(
                      child: TabBarView(children: [
//  Tab Bar View  Tan contents

                    SingleChildScrollView(
                        child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          //Link
                          Text(
                            utf8convert(widget.fest.description!),
                          ),
                        ],
                      ),
                    )),
                    SingleChildScrollView(
                        child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: fest_members(widget.fest.teamMembers!),
                    )),
                    SingleChildScrollView(
                      child: Container(
                        width: width,
                        height: width * 1.2,
                        padding: EdgeInsets.all(40),
                        margin: EdgeInsets.only(top: 40, bottom: 40),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            )),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return Scaffold(
                                          appBar: AppBar(
                                            centerTitle: true,
                                            iconTheme: IconThemeData(
                                                color: Colors.white),
                                            title: Text(widget.fest.name!,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor:
                                                Colors.indigoAccent[700],
                                          ),
                                          body: SingleChildScrollView(
                                            child: user_postswidget(
                                                '',
                                                widget.app_user,
                                                'fest',
                                                widget.fest.id!),
                                          ));
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Posts (" +
                                              widget.fest.post_count
                                                  .toString() +
                                              ')',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18)),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: width / 3,
                                        width: width / 3,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "images/posts.jpeg"),
                                                fit: BoxFit.cover)),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              content: Container(
                                                margin: EdgeInsets.all(10),
                                                child: const Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "Please wait a min....."),
                                                      SizedBox(height: 10),
                                                      CircularProgressIndicator()
                                                    ]),
                                              ));
                                        });
                                    var event_list =
                                        await user_profile_servers()
                                            .get_user_activity_list(
                                                '', 'fest', widget.fest.id!);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return Scaffold(
                                          appBar: AppBar(
                                            centerTitle: true,
                                            iconTheme: IconThemeData(
                                                color: Colors.white),
                                            title: Text(widget.fest.name!,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor:
                                                Colors.indigoAccent[700],
                                          ),
                                          body: SingleChildScrollView(
                                              child: activitieswidget1(
                                                  event_list,
                                                  widget.app_user,
                                                  widget.app_user.domain!,
                                                  true)));
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Activities (" +
                                              widget.fest.post_count
                                                  .toString() +
                                              ')',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18)),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: width / 3,
                                        width: width / 3,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "images/profile_activities.jpeg"),
                                                fit: BoxFit.cover)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    String web_url = widget.fest.websites!;
                                    final Uri url = Uri.parse(web_url);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.fest.name!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18)),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: width / 3,
                                        width: width / 3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.fest.logo!),
                                                fit: BoxFit.cover)),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              content: Container(
                                                margin: EdgeInsets.all(10),
                                                child: const Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "Please wait a min....."),
                                                      SizedBox(height: 10),
                                                      CircularProgressIndicator()
                                                    ]),
                                              ));
                                        });
                                    var thread_list =
                                        await user_profile_servers()
                                            .get_user_thread_list(
                                                '', 'fest', widget.fest.id!);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return Scaffold(
                                          appBar: AppBar(
                                            centerTitle: true,
                                            iconTheme: IconThemeData(
                                                color: Colors.white),
                                            title: Text(widget.fest.name!,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor:
                                                Colors.indigoAccent[700],
                                          ),
                                          body: SingleChildScrollView(
                                            child: alertwidget1(
                                                thread_list,
                                                widget.app_user,
                                                widget.app_user.domain!,
                                                true),
                                          ));
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Threads (" +
                                              widget.fest.post_count
                                                  .toString() +
                                              ')',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18)),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: width / 3,
                                        width: width / 3,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "images/threads profile.jpeg"),
                                                fit: BoxFit.cover)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),
                ],
              )),
        ));
  }
}

class fest_members extends StatefulWidget {
  final String team_mem;
  fest_members(this.team_mem);
  //const fest_members({super.key});

  @override
  State<fest_members> createState() => _fest_membersState();
}

class _fest_membersState extends State<fest_members> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Username>>(
      future: all_fests_servers().get_club_sprt_fest_membs(widget.team_mem),
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
            List<Username> fest_mem_list = snapshot.data;
            if (fest_mem_list.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Text("No fest members",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 24)));
            } else {
              return fest_members1(fest_mem_list);
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

class fest_members1 extends StatefulWidget {
  List<Username> fest_mem_list;
  fest_members1(this.fest_mem_list);

  @override
  State<fest_members1> createState() => _fest_members1State();
}

class _fest_members1State extends State<fest_members1> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.fest_mem_list.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Username fest_mem = widget.fest_mem_list[index];
          return _buildLoadingScreen(fest_mem);
        });
  }

  Widget _buildLoadingScreen(Username fest_mem) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        width: 48,
                        child: fest_mem.fileType! == '1'
                            ? CircleAvatar(
                                backgroundImage:
                                    //post.profile_pic
                                    NetworkImage(fest_mem.profilePic!))
                            : const CircleAvatar(
                                backgroundImage:
                                    //post.profile_pic
                                    AssetImage("images/profile.jpg"))),
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
                                    fest_mem.username!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    //"Vidya Sagar",
                                    //lst_list[index].username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      //color: Colors.white
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                userMarkNotation(fest_mem.starMark!)
                              ],
                            ),
                            Text(
                              //"B190838EC",
                              domains[fest_mem.domain!]! +
                                  " (" +
                                  fest_mem.userMark! +
                                  ")",
                              overflow: TextOverflow.ellipsis,
                              //lst_list.username.rollNum,
                              //style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                            )
                          ]),
                    )
                  ],
                ),
                Icon(Icons.more_horiz)
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "contact no " + fest_mem.phnNum!,
              //post.description,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}
