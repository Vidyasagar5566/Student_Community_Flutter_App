import 'package:flutter/material.dart';
import 'Club_page.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'package:testing_app/Reports/Uploads.dart';
import 'Uploads.dart';
import 'Search_bar.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';

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
        title: const Text(
          "CLUBS PAGE",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          DropdownButton<String>(
              value: widget.domain,
              underline: Container(),
              elevation: 0,
              items: domains_list.map<DropdownMenuItem<String>>((String value) {
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
              })
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
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    child: Container(
                      margin: EdgeInsets.all(100),
                      child: Center(child: Text("No Clubs Was Joined")),
                    ));
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
        decoration: const BoxDecoration(
            image: DecorationImage(
                //image: post.post_pic,
                image: AssetImage("images/event background.jpg"),
                fit: BoxFit.cover)),
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
              if (widget.app_user.email == "guest@nitc.ac.in") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
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
                                  child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(club.logo!)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: (width - 36) / 1.8,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: (width - 36) / 2.4),
                                              child: Text(
                                                club.name!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
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
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  List<String> team =
                                      club.teamMembers!.split('#');
                                  for (int i = 0; i < team.length; i++) {
                                    team_mems[team[i]] = true;
                                  }

                                  if (widget.app_user.username ==
                                      club.head!.username) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Only for club admin',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
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
                                                      color: Colors.red),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.more_horiz))
                          ]),
                      const SizedBox(height: 6),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              child: Text(utf8convert(club.description!),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4),
                            ),
                            const SizedBox(height: 7),
                            const Text("Club Head : ",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            smallUserProfileMark(widget.app_user, club.head!),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (widget.app_user.email ==
                                          "guest@nitc.ac.in") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "guests are not allowed to like..",
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      } else {
                                        setState(() {
                                          club.isLike = !club.isLike!;
                                        });
                                        if (club.isLike!) {
                                          setState(() {
                                            club.likeCount =
                                                club.likeCount! + 1;
                                          });
                                          bool error = await all_clubs_servers()
                                              .post_club_like(club.id!);
                                          if (error) {
                                            setState(() {
                                              club.likeCount =
                                                  club.likeCount! - 1;
                                              club.isLike = !club.isLike!;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            club.likeCount =
                                                club.likeCount! - 1;
                                          });
                                          bool error = await all_clubs_servers()
                                              .delete_club_like(club.id!);
                                          if (error) {
                                            setState(() {
                                              club.likeCount =
                                                  club.likeCount! + 1;
                                              club.isLike = !club.isLike!;
                                            });
                                          }
                                        }
                                        SystemSound.play(SystemSoundType.click);
                                      }
                                    },
                                    icon: club.isLike!
                                        ? const Icon(
                                            Icons.favorite,
                                            size: 28,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border_outlined,
                                            size: 28,
                                            color: Colors.red,
                                          ),
                                  ),
                                  // Text(post.likes.toString() + "likes")
                                  Text(
                                    club.likeCount.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      const SizedBox(height: 5)
                    ]))));
  }
}
