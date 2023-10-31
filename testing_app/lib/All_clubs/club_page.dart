import 'package:flutter/material.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '/User_profile/Servers.dart';
import 'Servers.dart';
//import 'package:link_text/link_text.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import 'dart:convert' show utf8;
import '/User_profile/User_posts_category.dart';
import '/Threads/threads.dart';
import '/Activities/activities.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, dynamic> team_mems = {};

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

List<Tab> tabs = [
  Tab(
    child: Container(
      width: 60,
      margin: EdgeInsets.all(6),
      child: const Text(
        "About",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    ),
  ),
  Tab(
      child: Container(
    width: 85,
    margin: EdgeInsets.all(6),
    child: const Text(
      textAlign: TextAlign.center,
      "Club Mems",
      style: TextStyle(color: Colors.black),
    ),
  )),
  Tab(
    child: Container(
      width: 85,
      margin: EdgeInsets.all(6),
      child: const Text(
        "Media Files",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    ),
  ),
];

class clubpagewidget extends StatefulWidget {
  final ALL_CLUBS club;
  Username app_user;
  clubpagewidget(this.club, this.app_user);
  //const clubpagewidget({super.key});

  @override
  State<clubpagewidget> createState() => _clubpagewidgetState();
}

class _clubpagewidgetState extends State<clubpagewidget> {
  @override
  Widget build(BuildContext context) {
    final double coverheight = 100;
    final double profileheight = 50;
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.blue, // <-- SEE HERE
            ),
            centerTitle: true,
            title: Text(
              widget.club.head!.username!,
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white70,
          ),
          body: Container(
            color: Colors.indigo,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
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
                              "images/Clubs.jpg",
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
                            backgroundImage: NetworkImage(widget.club.logo!
                                //"images/club-clun-profile.png"
                                ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.club.name!,
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
                  //  Tab Bar View  Tab contents

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
                        Text(
                          utf8convert(widget.club.description!),
                        ),
                      ],
                    ),
                  )),
                  SingleChildScrollView(
                      child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child:
                        club_members(widget.app_user, widget.club.teamMembers!),
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Scaffold(
                                        appBar: AppBar(
                                          centerTitle: true,
                                          iconTheme: const IconThemeData(
                                              color: Colors.white),
                                          title: Text(widget.club.name!,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor:
                                              Colors.indigoAccent[700],
                                        ),
                                        body: SingleChildScrollView(
                                          child: user_postswidget(
                                              '',
                                              widget.app_user,
                                              'club',
                                              widget.club.id!),
                                        ));
                                  }));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Posts (" +
                                            widget.club.post_count.toString() +
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
                                            contentPadding: EdgeInsets.all(15),
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
                                  var event_list = await user_profile_servers()
                                      .get_user_activity_list(
                                          '', 'club', widget.club.id!);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Scaffold(
                                        appBar: AppBar(
                                          centerTitle: true,
                                          iconTheme: const IconThemeData(
                                              color: Colors.white),
                                          title: Text(widget.club.name!,
                                              style: const TextStyle(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Activities (" +
                                            widget.club.activity_count
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
                                  String web_url = widget.club.websites!;

                                  final Uri url = Uri.parse(web_url);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.club.name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18)),
                                    const SizedBox(height: 12),
                                    Container(
                                      height: width / 3,
                                      width: width / 3,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.club.logo!),
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
                                            contentPadding: EdgeInsets.all(15),
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
                                  var thread_list = await user_profile_servers()
                                      .get_user_thread_list(
                                          '', 'club', widget.club.id!);
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return Scaffold(
                                        appBar: AppBar(
                                          centerTitle: true,
                                          iconTheme: const IconThemeData(
                                              color: Colors.white),
                                          title: Text(widget.club.name!,
                                              style: const TextStyle(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Threads (" +
                                            widget.club.thread_count
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
                ]
                        //  Tab Bar View  Tan contents

                        )),
              ],
            ),
          ),
        ));
  }
}

class club_members extends StatefulWidget {
  Username app_user;
  final String team_mem;
  club_members(this.app_user, this.team_mem);
  //const club_members({super.key});

  @override
  State<club_members> createState() => _club_membersState();
}

class _club_membersState extends State<club_members> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SmallUsername>>(
      future: all_clubs_servers().get_club_sprt_fest_membs(widget.team_mem),
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
            List<SmallUsername> club_mem_list = snapshot.data;
            if (club_mem_list.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Text("No club members",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 24)));
            } else {
              return club_members1(widget.app_user, club_mem_list);
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
    );
  }
}

class club_members1 extends StatefulWidget {
  Username app_user;
  List<SmallUsername> club_mem_list;
  club_members1(this.app_user, this.club_mem_list);

  @override
  State<club_members1> createState() => _club_members1State();
}

class _club_members1State extends State<club_members1> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.club_mem_list.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          SmallUsername club_mem = widget.club_mem_list[index];
          return _buildLoadingScreen(club_mem);
        });
  }

  Widget _buildLoadingScreen(SmallUsername club_mem) {
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
                  children: [UserProfileMark(widget.app_user, club_mem)],
                ),
                Icon(Icons.more_horiz)
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "contact no " + club_mem.phnNum!,
              //post.description,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ));
  }
}
