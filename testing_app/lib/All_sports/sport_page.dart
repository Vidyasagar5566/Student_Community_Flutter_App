import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/Servers.dart';
import 'Servers.dart';
import '/User_profile/Servers.dart';
//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import '/User_profile/User_posts_category.dart';
import '/Threads/Threads.dart';
import '/Activities/Activities.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<Tab> tabs = [
  Tab(
    child: Container(
      width: 60,
      child: const Text(
        "About",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    ),
  ),
  Tab(
      child: Container(
    width: 105,
    child: const Text(
      "Fest mem",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    ),
  )),
  Tab(
    child: Container(
      width: 105,
      child: const Text(
        "Media files",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    ),
  ),
  Tab(
    child: Container(
      width: 60,
      child: const Text(
        "Ground",
        style: TextStyle(color: Colors.black),
      ),
    ),
  ),
];

class sportpagewidget extends StatefulWidget {
  ALL_SPORTS sport;
  Username app_user;
  sportpagewidget(this.sport, this.app_user);
  //const dndpagewidget({super.key});

  @override
  State<sportpagewidget> createState() => _sportpagewidgetState();
}

class _sportpagewidgetState extends State<sportpagewidget> {
  @override
  Widget build(BuildContext context) {
    final double coverheight = 100;
    final double profileheight = 50;
    SmallUsername head = widget.sport.head!;
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.blue, // <-- SEE HERE
            ),
            centerTitle: true,
            title: Text(
              widget.sport.head!.username!,
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white70,
          ),
          body: Container(
              color: Colors.indigo,
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
                              "images/all sports.jpg",
                              width: double.infinity,
                              height: coverheight,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Positioned(
                        top: coverheight - profileheight / 2,
                        child: CircleAvatar(
                            radius: 2 + profileheight / 2,
                            backgroundColor: Colors.grey[700],
                            child: CircleAvatar(
                              radius: profileheight / 2,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(widget.sport.logo!
                                  //"images/sports/cricket-profile.jpg"
                                  ),
                            )),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    head.username! + " SPORT",
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
                            unselectedLabelColor: Colors.blueAccent,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueAccent),
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
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey, // Shadow color
                              offset: Offset(0,
                                  2), // Offset of the shadow (horizontal, vertical)
                              blurRadius: 6, // Spread of the shadow
                              spreadRadius: 0, // Expansion of the shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          //Link
                          SelectableLinkify(
                            onOpen: (url) async {
                              if (await canLaunch(url.url)) {
                                await launch(url.url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            text: utf8convert(widget.sport.description!),
                          ),
                        ],
                      ),
                    )),
                    SingleChildScrollView(
                        child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: sport_members(
                          widget.app_user, widget.sport.teamMembers!),
                    )),
                    SingleChildScrollView(
                      child: Container(
                        width: width,
                        height: width * 1.2,
                        padding: EdgeInsets.all(40),
                        margin: EdgeInsets.only(top: 20, bottom: 40),
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Shadow color
                                offset: Offset(0,
                                    2), // Offset of the shadow (horizontal, vertical)
                                blurRadius: 6, // Spread of the shadow
                                spreadRadius: 0, // Expansion of the shadow
                              ),
                            ],
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
                                            title: Text(widget.sport.name!,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor:
                                                Colors.indigoAccent[700],
                                          ),
                                          body: SingleChildScrollView(
                                            child: user_postswidget(
                                                '',
                                                widget.app_user,
                                                'sport',
                                                widget.sport.id!),
                                          ));
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Posts(" +
                                              widget.sport.post_count
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
                                                '', 'sport', widget.sport.id!);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return Scaffold(
                                          appBar: AppBar(
                                            centerTitle: true,
                                            iconTheme: IconThemeData(
                                                color: Colors.white),
                                            title: Text(widget.sport.name!,
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
                                          "Activities(" +
                                              widget.sport.post_count
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
                                    String web_url = widget.sport.websites!;

                                    final Uri url = Uri.parse(web_url);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.sport.name!,
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
                                                    widget.sport.logo!),
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
                                                '', 'sport', widget.sport.id!);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return Scaffold(
                                          appBar: AppBar(
                                            centerTitle: true,
                                            iconTheme: IconThemeData(
                                                color: Colors.white),
                                            title: Text(widget.sport.name!,
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
                                          "Threads(" +
                                              widget.sport.post_count
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
                    ),
                    SingleChildScrollView(
                        child: Container(
                            // height: 300,
                            width: width,
                            margin: EdgeInsets.only(top: 100),
                            padding: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey, // Shadow color
                                    offset: Offset(0,
                                        2), // Offset of the shadow (horizontal, vertical)
                                    blurRadius: 6, // Spread of the shadow
                                    spreadRadius: 0, // Expansion of the shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: GestureDetector(
                              onTap: () async {
                                String web_url = widget.sport.sportGround!;

                                final Uri url = Uri.parse(web_url);
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text("Maps to Ground : "),
                                      SizedBox(width: 5),
                                      Icon(Icons.location_pin, size: 23),
                                    ],
                                  ),
                                  const SizedBox(width: 5),
                                  Center(
                                    child: Container(
                                      height: width / 2,
                                      width: width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.sport.sportGroundImg!),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  ])),
                ],
              )),
        ));
  }
}

class sport_members extends StatefulWidget {
  Username app_user;
  final String team_mem;
  sport_members(this.app_user, this.team_mem);
  //const sport_members({super.key});

  @override
  State<sport_members> createState() => _sport_membersState();
}

class _sport_membersState extends State<sport_members> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SmallUsername>>(
      future: all_sports_servers().get_club_sprt_fest_membs(widget.team_mem),
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
            List<SmallUsername> sport_mem_list = snapshot.data;
            return sport_members1(widget.app_user, sport_mem_list);
          }
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
    );
  }
}

class sport_members1 extends StatefulWidget {
  Username app_user;
  List<SmallUsername> sport_mem_list;
  sport_members1(this.app_user, this.sport_mem_list);

  @override
  State<sport_members1> createState() => _sport_members1State();
}

class _sport_members1State extends State<sport_members1> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.sport_mem_list.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          SmallUsername sport_mem = widget.sport_mem_list[index];
          return _buildLoadingScreen(sport_mem);
        });
  }

  Widget _buildLoadingScreen(SmallUsername sport_mem) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Shadow color
            offset: Offset(0, 2), // Offset of the shadow (horizontal, vertical)
            blurRadius: 6, // Spread of the shadow
            spreadRadius: 0, // Expansion of the shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [UserProfileMark(widget.app_user, sport_mem)],
                ),
                Icon(Icons.more_horiz)
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "contact no " + sport_mem.phnNum!,
              //post.description,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}
