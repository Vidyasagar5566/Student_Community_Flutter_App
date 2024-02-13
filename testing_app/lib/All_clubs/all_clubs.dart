import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Club_page.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import '/Reports/Uploads.dart';
import 'Uploads.dart';
import 'Search_bar.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Allclubpagewidget extends StatefulWidget {
  Username app_user;
  String domain;
  Allclubpagewidget(this.app_user, this.domain);

  @override
  State<Allclubpagewidget> createState() => _AllclubpagewidgetState();
}

class _AllclubpagewidgetState extends State<Allclubpagewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.blue, // <-- SEE HERE
        ),
        centerTitle: false,
        title: Text(
          "Clubs Page",
          style:
              GoogleFonts.alegreya(textStyle: TextStyle(color: Colors.black)),
        ),
        actions: [
          Container(
            height: 25,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueGrey, width: 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 5)
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DropdownButton<String>(
                  value: widget.domain,
                  underline: Container(),
                  elevation: 0,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  items: ['All', domains[widget.app_user.domain]!]
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
                  },
                  dropdownColor: Colors.grey),
            ),
          )
        ],
        backgroundColor: Colors.white70,
      ),
      body: FutureBuilder<List<ALL_CLUBS>>(
        future: all_clubs_servers().get_clubs_list(domains1[widget.domain]!),
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
              List<ALL_CLUBS> AllClubs = snapshot.data;
              if (AllClubs.isEmpty) {
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
                            "No Clubs were Joined",
                            //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            "Contact you club admins to join.",
                            //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                          ),
                        ),
                      ],
                    )));
              } else {
                return Allclubpagewidget1(AllClubs, widget.app_user);
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: widget.app_user.clzClubsHead!
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return club_search_bar(
                      widget.app_user, 0, widget.app_user.domain!, true, false);
                }));
              },
              tooltip: 'create club',
              elevation: 4.0,
              child: const Icon(
                Icons.add,
                color: Colors.blueAccent,
              ),
            )
          : Container(),
    );
  }
}

class Allclubpagewidget1 extends StatefulWidget {
  List<ALL_CLUBS> AllClubs;
  Username app_user;
  Allclubpagewidget1(this.AllClubs, this.app_user);

  @override
  State<Allclubpagewidget1> createState() => _Allclubpagewidget1State();
}

class _Allclubpagewidget1State extends State<Allclubpagewidget1> {
  @override
  Widget build(BuildContext context) {
    List<ALL_CLUBS> AllClubs = widget.AllClubs;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: ListView.builder(
              itemCount: AllClubs.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                ALL_CLUBS club = AllClubs[index];
                return _buildLoadingScreen(club);
              }),
        ));
  }

  Widget _buildLoadingScreen(ALL_CLUBS club) {
    var width = MediaQuery.of(context).size.width;
    SmallUsername head = club.head!;
    return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return clubpagewidget(club, widget.app_user);
              }));
            },
            onDoubleTap: () async {
              if (widget.app_user.email!.split('@')[0] == "guest") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 400),
                    content: Text("guests are not allowed to like..",
                        style: TextStyle(color: Colors.white))));
              } else {
                setState(() {
                  club.isLike = !club.isLike!;
                });
                if (club.isLike!) {
                  setState(() {
                    club.likeCount = club.likeCount! + 1;
                  });
                  bool error =
                      await all_clubs_servers().post_club_like(club.id!);
                  if (error) {
                    setState(() {
                      club.likeCount = club.likeCount! - 1;
                      club.isLike = !club.isLike!;
                    });
                  }
                } else {
                  setState(() {
                    club.likeCount = club.likeCount! - 1;
                  });
                  bool error =
                      await all_clubs_servers().delete_club_like(club.id!);
                  if (error) {
                    setState(() {
                      club.likeCount = club.likeCount! + 1;
                      club.isLike = !club.isLike!;
                    });
                  }
                }
              }
              SystemSound.play(SystemSoundType.click);
            },
            child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey, // Shadow color
                        offset: Offset(0,
                            1), // Offset of the shadow (horizontal, vertical)
                        blurRadius: 4, // Spread of the shadow
                        spreadRadius: 0, // Expansion of the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: NetworkImage(club.logo!),
                                      fit: BoxFit.cover)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      width: (width - 36) / 1.8,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          (width - 36) / 2.4),
                                                  child: Text(
                                                    club.name!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.alegreya(
                                                        textStyle:
                                                            const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    )),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                userMarkNotation(club.starMark!)
                                              ],
                                            ),
                                            Text(
                                              domains[club.domain!]! +
                                                  " (" +
                                                  club.title! +
                                                  ") ",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ]),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          List<String> team =
                                              club.teamMembers!.split('#');
                                          for (int i = 0;
                                              i < team.length;
                                              i++) {
                                            team_mems[team[i]] = true;
                                          }

                                          if (widget.app_user.username ==
                                              club.head!.username) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return edit_club(
                                                  widget.app_user,
                                                  club.id!,
                                                  club.title,
                                                  club.description,
                                                  club.logo,
                                                  club.name,
                                                  club.websites);
                                            })).then((value) {
                                              setState(() {
                                                team_mems.clear();
                                              });
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Only for club admin',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                            return report_upload(
                                                                widget.app_user,
                                                                'club' +
                                                                    " :" +
                                                                    head.username!,
                                                                head.username!);
                                                          }));
                                                        },
                                                        child: const Text(
                                                          "Report",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.more_horiz))
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: width - 180,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                            utf8convert(club.description!),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            smallUserProfileMark(widget.app_user, club.head!),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  club.isLike!
                                      ? Container(
                                          margin: EdgeInsets.only(left: 4),
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: OutlinedButton(
                                              onPressed: () async {
                                                if (widget.app_user.email!
                                                        .split('@')[0] ==
                                                    "guest") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      content: Text(
                                                        "Guests are not allowed",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  setState(() {
                                                    club.isLike = !club.isLike!;
                                                  });
                                                  if (club.isLike!) {
                                                    setState(() {
                                                      club.likeCount =
                                                          club.likeCount! + 1;
                                                    });
                                                    bool error =
                                                        await all_clubs_servers()
                                                            .post_club_like(
                                                                club.id!);
                                                    if (error) {
                                                      setState(() {
                                                        club.likeCount =
                                                            club.likeCount! - 1;
                                                        club.isLike =
                                                            !club.isLike!;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      club.likeCount =
                                                          club.likeCount! - 1;
                                                    });
                                                    bool error =
                                                        await all_clubs_servers()
                                                            .delete_club_like(
                                                                club.id!);
                                                    if (error) {
                                                      setState(() {
                                                        club.likeCount =
                                                            club.likeCount! + 1;
                                                        club.isLike =
                                                            !club.isLike!;
                                                      });
                                                    }
                                                    SystemSound.play(
                                                        SystemSoundType.click);
                                                  }
                                                }
                                              },
                                              child: const Center(
                                                  child: Text(
                                                "Fallowing",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(left: 4),
                                          height: 30,
                                          child: OutlinedButton(
                                              onPressed: () async {
                                                if (widget.app_user.email!
                                                        .split('@')[0] ==
                                                    "guest") {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      content: Text(
                                                        "Guests are not allowed",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  setState(() {
                                                    club.isLike = !club.isLike!;
                                                  });
                                                  if (club.isLike!) {
                                                    setState(() {
                                                      club.likeCount =
                                                          club.likeCount! + 1;
                                                    });
                                                    bool error =
                                                        await all_clubs_servers()
                                                            .post_club_like(
                                                                club.id!);
                                                    if (error) {
                                                      setState(() {
                                                        club.likeCount =
                                                            club.likeCount! - 1;
                                                        club.isLike =
                                                            !club.isLike!;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      club.likeCount =
                                                          club.likeCount! - 1;
                                                    });
                                                    bool error =
                                                        await all_clubs_servers()
                                                            .delete_club_like(
                                                                club.id!);
                                                    if (error) {
                                                      setState(() {
                                                        club.likeCount =
                                                            club.likeCount! + 1;
                                                        club.isLike =
                                                            !club.isLike!;
                                                      });
                                                    }
                                                    SystemSound.play(
                                                        SystemSoundType.click);
                                                  }
                                                }
                                              },
                                              child: const Center(
                                                  child: Text(
                                                "Fallow",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ))),
                                        ),
                                  const SizedBox(height: 4),
                                  Text(
                                    club.likeCount.toString() + " Fallowers",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      const SizedBox(height: 5)
                    ]))));
  }
}
