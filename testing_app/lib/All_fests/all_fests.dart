import 'package:flutter/material.dart';
import 'fest_page.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'Uploads.dart';
import '/Reports/Uploads.dart';
import 'Search_bar.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Allfestspagewidget extends StatefulWidget {
  Username app_user;
  String domain;
  Allfestspagewidget(this.app_user, this.domain);

  @override
  State<Allfestspagewidget> createState() => _AllfestspagewidgetState();
}

class _AllfestspagewidgetState extends State<Allfestspagewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.blue, // <-- SEE HERE
        ),
        centerTitle: false,
        title: const Text(
          "FESTS PAGE",
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
      body: FutureBuilder<List<ALL_FESTS>>(
        future: all_fests_servers().get_fests_list(domains1[widget.domain]!),
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
              List<ALL_FESTS> Allfests = snapshot.data;
              if (Allfests.isEmpty) {
                return Container(
                  child: Center(child: Text("No Fests Was Joined")),
                );
              } else {
                return Allfestspagewidget1(Allfests, widget.app_user);
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: widget.app_user.clzFestsHead!
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return fest_search_bar(
                      widget.app_user, 0, widget.app_user.domain!, true, false);
                }));
              },
              tooltip: 'create fest',
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

class Allfestspagewidget1 extends StatefulWidget {
  List<ALL_FESTS> Allfests;
  Username app_user;
  Allfestspagewidget1(this.Allfests, this.app_user);

  @override
  State<Allfestspagewidget1> createState() => _Allfestspagewidget1State();
}

class _Allfestspagewidget1State extends State<Allfestspagewidget1> {
  @override
  Widget build(BuildContext context) {
    List<ALL_FESTS> Allfests = widget.Allfests;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: ListView.builder(
              itemCount: Allfests.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                ALL_FESTS fest = Allfests[index];
                return _buildLoadingScreen(fest);
              }),
        ));
  }

  Widget _buildLoadingScreen(ALL_FESTS fest) {
    var width = MediaQuery.of(context).size.width;
    SmallUsername head = fest.head!;
    return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return festpagewidget(fest, widget.app_user);
              }));
            },
            onDoubleTap: () async {
              if (widget.app_user.email == "guest@nitc.ac.in") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 400),
                    content: Text("guests are not allowed to like..",
                        style: TextStyle(color: Colors.white))));
              } else {
                setState(() {
                  fest.isLike = !fest.isLike!;
                });
                if (fest.isLike!) {
                  setState(() {
                    fest.likeCount = fest.likeCount! + 1;
                  });
                  bool error =
                      await all_fests_servers().post_fest_like(fest.id!);
                  if (error) {
                    setState(() {
                      fest.likeCount = fest.likeCount! - 1;
                      fest.isLike = !fest.isLike!;
                    });
                  }
                } else {
                  setState(() {
                    fest.likeCount = fest.likeCount! - 1;
                  });
                  bool error =
                      await all_fests_servers().delete_fest_like(fest.id!);
                  if (error) {
                    setState(() {
                      fest.likeCount = fest.likeCount! + 1;
                      fest.isLike = !fest.isLike!;
                    });
                  }
                }
              }
              SystemSound.play(SystemSoundType.click);
            },
            child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Shadow color
                    offset: Offset(
                        0, 1), // Offset of the shadow (horizontal, vertical)
                    blurRadius: 4, // Spread of the shadow
                    spreadRadius: 0, // Expansion of the shadow
                  ),
                ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
                                      backgroundImage: NetworkImage(fest.logo!
                                          //'images/DND-clun-profile.png'
                                          )),
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
                                                fest.name!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            userMarkNotation(fest.starMark!)
                                          ],
                                        ),
                                        Text(
                                          domains[fest.domain!]! +
                                              " (" +
                                              fest.title! +
                                              ") ",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      ]),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  List<String> team =
                                      fest.teamMembers!.split('#');
                                  for (int i = 0; i < team.length; i++) {
                                    team_mems[team[i]] = true;
                                  }
                                  if (widget.app_user.username ==
                                      fest.head!.username) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return edit_fest(
                                          widget.app_user,
                                          fest.id!,
                                          fest.title,
                                          fest.description,
                                          fest.logo,
                                          fest.name,
                                          fest.websites);
                                    })).then((value) {
                                      setState(() {
                                        team_mems.clear();
                                      });
                                    });
                                    ;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 400),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Only for fest admin',
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
                                                        'fest' +
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
                              child: Text(utf8convert(fest.description!),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4),
                            ),
                            const SizedBox(height: 7),
                            const Text("fest Head : ",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            smallUserProfileMark(widget.app_user, fest.head!),
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
                                                duration:
                                                    Duration(milliseconds: 400),
                                                content: Text(
                                                    "guests are not allowed to like..",
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      } else {
                                        setState(() {
                                          fest.isLike = !fest.isLike!;
                                        });
                                        if (fest.isLike!) {
                                          setState(() {
                                            fest.likeCount =
                                                fest.likeCount! + 1;
                                          });
                                          bool error = await all_fests_servers()
                                              .post_fest_like(fest.id!);
                                          if (error) {
                                            setState(() {
                                              fest.likeCount =
                                                  fest.likeCount! - 1;
                                              fest.isLike = !fest.isLike!;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            fest.likeCount =
                                                fest.likeCount! - 1;
                                          });
                                          bool error = await all_fests_servers()
                                              .delete_fest_like(fest.id!);
                                          if (error) {
                                            setState(() {
                                              fest.likeCount =
                                                  fest.likeCount! + 1;
                                              fest.isLike = !fest.isLike!;
                                            });
                                          }
                                        }
                                        SystemSound.play(SystemSoundType.click);
                                      }
                                    },
                                    icon: fest.isLike!
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
                                    fest.likeCount.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ]))));
  }
}
