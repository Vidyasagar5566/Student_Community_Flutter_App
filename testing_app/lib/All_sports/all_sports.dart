import 'package:flutter/material.dart';
import 'sport_page.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
//import 'package:link_text/link_text.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'Uploads.dart';
import 'package:testing_app/Reports/Uploads.dart';
import 'Search_bar.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Allsportpagewidget extends StatefulWidget {
  Username app_user;
  String domain;
  Allsportpagewidget(this.app_user, this.domain);

  @override
  State<Allsportpagewidget> createState() => _AllsportpagewidgetState();
}

class _AllsportpagewidgetState extends State<Allsportpagewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.blue, // <-- SEE HERE
        ),
        centerTitle: false,
        title: const Text(
          "SPORTS PAGE",
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
      body: FutureBuilder<List<ALL_SPORTS>>(
        future: all_sports_servers().get_sport_list(domains1[widget.domain]!),
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
              List<ALL_SPORTS> sport_list = snapshot.data;
              if (sport_list.length == 0) {
                return Container(
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    child: Container(
                      margin: EdgeInsets.all(100),
                      child: Center(child: Text("No Sports Was Joined")),
                    ));
              } else {
                return Allsportpagewidget1(sport_list, widget.app_user);
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: widget.app_user.clzSportsHead!
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return sport_search_bar(
                      widget.app_user, 0, widget.app_user.domain!, true);
                }));
              },
              tooltip: 'create sport',
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

class Allsportpagewidget1 extends StatefulWidget {
  List<ALL_SPORTS> sport_list;
  Username app_user;
  Allsportpagewidget1(this.sport_list, this.app_user);

  @override
  State<Allsportpagewidget1> createState() => _Allsportpagewidget1State();
}

class _Allsportpagewidget1State extends State<Allsportpagewidget1> {
  @override
  Widget build(BuildContext context) {
    List<ALL_SPORTS> sport_list = widget.sport_list;
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
              itemCount: sport_list.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                ALL_SPORTS sport = sport_list[index];
                return _buildLoadingScreen(sport);
              }),
        ));
  }

  Widget _buildLoadingScreen(ALL_SPORTS sport) {
    var width = MediaQuery.of(context).size.width;
    SmallUsername head = sport.head!;
    return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return sportpagewidget(sport, widget.app_user);
              }));
            },
            onDoubleTap: () async {
              if (widget.app_user.email == "guest@nitc.ac.in") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("guests are not allowed to like..",
                        style: TextStyle(color: Colors.white))));
              } else {
                setState(() {
                  sport.isLike = !sport.isLike!;
                });
                if (sport.isLike!) {
                  setState(() {
                    sport.likeCount = sport.likeCount! + 1;
                  });
                  bool error =
                      await all_sports_servers().post_sport_like(sport.id!);
                  if (error) {
                    setState(() {
                      sport.likeCount = sport.likeCount! - 1;
                      sport.isLike = !sport.isLike!;
                    });
                  }
                } else {
                  setState(() {
                    sport.likeCount = sport.likeCount! - 1;
                  });
                  bool error =
                      await all_sports_servers().delete_sport_like(sport.id!);
                  if (error) {
                    setState(() {
                      sport.likeCount = sport.likeCount! + 1;
                      sport.isLike = !sport.isLike!;
                    });
                  }
                }
                SystemSound.play(SystemSoundType.click);
              }
            },
            child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
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
                                          NetworkImage(sport.logo!)),
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
                                                sport.name!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            userMarkNotation(sport.starMark!)
                                          ],
                                        ),
                                        Text(
                                          domains[sport.domain!]! +
                                              " (" +
                                              sport.title! +
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
                                  if (widget.app_user.username ==
                                      sport.head!.username) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return edit_sport(
                                          widget.app_user,
                                          sport.id!,
                                          sport.title,
                                          sport.description,
                                          sport.logo,
                                          sport.name,
                                          sport.teamMembers,
                                          sport.websites,
                                          sport.sportGroundImg,
                                          sport.sportGround);
                                    }));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Only for sport admin',
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
                                                        'sport' +
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
                              child: Text(utf8convert(sport.description!),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4),
                            ),
                            const SizedBox(height: 7),
                            const Text("sport Head : ",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            smallUserProfileMark(sport.head!),
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
                                          sport.isLike = !sport.isLike!;
                                        });
                                        if (sport.isLike!) {
                                          setState(() {
                                            sport.likeCount =
                                                sport.likeCount! + 1;
                                          });
                                          bool error =
                                              await all_sports_servers()
                                                  .post_sport_like(sport.id!);
                                          if (error) {
                                            setState(() {
                                              sport.likeCount =
                                                  sport.likeCount! - 1;
                                              sport.isLike = !sport.isLike!;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            sport.likeCount =
                                                sport.likeCount! - 1;
                                          });
                                          bool error =
                                              await all_sports_servers()
                                                  .delete_sport_like(sport.id!);
                                          if (error) {
                                            setState(() {
                                              sport.likeCount =
                                                  sport.likeCount! + 1;
                                              sport.isLike = !sport.isLike!;
                                            });
                                          }
                                        }
                                        SystemSound.play(SystemSoundType.click);
                                      }
                                    },
                                    icon: sport.isLike!
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
                                    sport.likeCount.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ]))));
  }
}
