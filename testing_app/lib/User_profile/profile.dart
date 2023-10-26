import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:testing_app/User_profile/Servers.dart';
import 'Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'Edit_profile.dart';
//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';
import 'User_posts_category.dart';
import 'package:testing_app/BuySell_LostFound/Lostfound_buysell.dart';
import 'package:testing_app/First_page.dart';
import 'package:testing_app/Threads/Threads.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class userProfilePage extends StatefulWidget {
  Username app_user;
  Username profile_user;
  userProfilePage(this.app_user, this.profile_user);

  @override
  State<userProfilePage> createState() => _userProfilePageState();
}

class _userProfilePageState extends State<userProfilePage> {
  List<bool> club_sport_fest_sac = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.indigoAccent),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.app_user.email != widget.profile_user.email
                    ? GestureDetector(
                        onTap: () {
                          if (widget.app_user.email !=
                              widget.profile_user.email) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(children: [
                          Icon(Icons.keyboard_arrow_left,
                              color: Colors.white, size: 40),
                          SizedBox(width: 10),
                          Text("Back",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 22)),
                        ]),
                      )
                    : Container(),
                widget.app_user.email == widget.profile_user.email
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  editprofile(widget.profile_user)));
                        },
                        child: const Row(
                          children: [
                            Text("Edit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5)
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
              height: 150,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                                content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Close'))
                                    ]),
                                const SizedBox(height: 20),
                                CircleAvatar(
                                    radius: 52,
                                    backgroundColor: Colors.white,
                                    child: widget.profile_user.fileType! == '1'
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                //post.profile_pic
                                                NetworkImage(widget
                                                    .profile_user.profilePic!))
                                        : const CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                //post.profile_pic
                                                AssetImage(
                                                    "images/profile.jpg"))),
                                const SizedBox(height: 10),
                                const Text('Bio',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Center(
                                  child: Text(
                                      utf8convert(widget.profile_user.bio!),
                                      style: const TextStyle(fontSize: 15)),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('email  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width / 2,
                                      ),
                                      child: Text(widget.profile_user.email!,
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('phone_num  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width / 2,
                                      ),
                                      child: Text(widget.profile_user.phnNum!,
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('course  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width / 2,
                                      ),
                                      child: Text(widget.profile_user.course!,
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('year  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width / 2,
                                      ),
                                      child: Text(
                                          widget.profile_user.year.toString(),
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('branch  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width / 2,
                                      ),
                                      child: Text(widget.profile_user.branch!,
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('section  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    const SizedBox(width: 10),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width / 2,
                                      ),
                                      child: Text(widget.profile_user.batch!,
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),
                              ],
                            ));
                          });
                    },
                    child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: widget.profile_user.fileType! == '1'
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    //post.profile_pic
                                    NetworkImage(
                                        widget.profile_user.profilePic!))
                            : const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    //post.profile_pic
                                    AssetImage("images/profile.jpg"))),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: (width - 36) / 2.4),
                                child: Text(
                                  widget.profile_user.username!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7)),
                                      color: Colors.white),
                                  child: userMarkNotation(
                                      widget.profile_user.starMark!))
                            ],
                          ),
                          Text(
                            domains[widget.profile_user.domain!]! +
                                " (" +
                                widget.profile_user.userMark! +
                                ")",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, top: 20, bottom: 8, right: 30),
              height: 120,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text("Clubs",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          for (int i = 1; i < 4; i++) {
                            setState(() {
                              club_sport_fest_sac[i] = false;
                            });
                          }
                          setState(() {
                            widget.app_user = widget.app_user;
                            club_sport_fest_sac[0] = !club_sport_fest_sac[0];
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              (widget.profile_user.clzClubs!['head'].length +
                                      widget.profile_user
                                          .clzClubs!['team_member'].length)
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            club_sport_fest_sac[0]
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Sports",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          for (int i = 0; i < 4; i++) {
                            setState(() {
                              if (i != 1) club_sport_fest_sac[i] = false;
                            });
                          }
                          setState(() {
                            widget.app_user = widget.app_user;
                            club_sport_fest_sac[1] = !club_sport_fest_sac[1];
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              (widget.profile_user.clzSports!['head'].length +
                                      widget.profile_user
                                          .clzSports!['team_member'].length)
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            club_sport_fest_sac[1]
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Fests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          for (int i = 0; i < 4; i++) {
                            setState(() {
                              if (i != 2) club_sport_fest_sac[i] = false;
                            });
                          }
                          setState(() {
                            widget.app_user = widget.app_user;
                            club_sport_fest_sac[2] = !club_sport_fest_sac[2];
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              (widget.profile_user.clzFests!['head'].length +
                                      widget.profile_user
                                          .clzFests!['team_member'].length)
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            club_sport_fest_sac[2]
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text("SAC",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          for (int i = 0; i < 4; i++) {
                            setState(() {
                              if (i != 3) club_sport_fest_sac[i] = false;
                            });
                          }
                          setState(() {
                            widget.app_user = widget.app_user;
                            club_sport_fest_sac[3] = !club_sport_fest_sac[3];
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              (widget.profile_user.clzSacs!['head'].length +
                                      widget.profile_user
                                          .clzSacs!['team_member'].length)
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            club_sport_fest_sac[3]
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            club_sport_fest_sac[0]
                ? clzCSFS(widget.app_user, widget.profile_user, 'club', [], [])
                : club_sport_fest_sac[1]
                    ? clzCSFS(
                        widget.app_user, widget.profile_user, 'sport', [], [])
                    : club_sport_fest_sac[2]
                        ? clzCSFS(widget.app_user, widget.profile_user, 'fest',
                            [], [])
                        : club_sport_fest_sac[3]
                            ? clzCSFS(widget.app_user, widget.profile_user,
                                'sac', [], [])
                            : Container(),
            SingleChildScrollView(
              child: Container(
                width: width,
                height: width * 1.25,
                padding: EdgeInsets.all(40),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
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
                                    iconTheme:
                                        IconThemeData(color: Colors.white),
                                    title: Text(widget.profile_user.username!,
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.indigoAccent[700],
                                  ),
                                  body: SingleChildScrollView(
                                    child: user_postswidget(
                                        widget.profile_user.email!,
                                        widget.app_user,
                                        'student',
                                        0),
                                  ));
                            }));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Posts (" +
                                      widget.profile_user.postCount.toString() +
                                      ')',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20)),
                              const SizedBox(height: 10),
                              Container(
                                height: width / 3,
                                width: width / 3,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                        image: AssetImage("images/posts.jpeg"),
                                        fit: BoxFit.cover)),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return all_lostwidget1(
                                  widget.app_user,
                                  "lost/found",
                                  lst_buy_list,
                                  'All',
                                  widget.profile_user.email!);
                            }));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "LostFound (" +
                                      widget.profile_user.lstCount.toString() +
                                      ')',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20)),
                              const SizedBox(height: 10),
                              Container(
                                height: width / 3,
                                width: width / 3,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "images/lost-and-found.gif"),
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
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return all_lostwidget1(
                                  widget.app_user,
                                  "buy/shell",
                                  lst_buy_list,
                                  'All',
                                  widget.profile_user.email!);
                            }));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "BuySell (" +
                                      widget.profile_user.buyCount.toString() +
                                      ')',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20)),
                              const SizedBox(height: 10),
                              Container(
                                height: width / 3,
                                width: width / 3,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "images/buy_sell_std.png"),
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
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Please wait a min....."),
                                              SizedBox(height: 10),
                                              CircularProgressIndicator()
                                            ]),
                                      ));
                                });
                            var thread_list = await user_profile_servers()
                                .get_user_thread_list(
                                    widget.profile_user.email!, 'student', 0);
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Scaffold(
                                  appBar: AppBar(
                                    centerTitle: true,
                                    iconTheme:
                                        IconThemeData(color: Colors.white),
                                    title: Text(widget.profile_user.username!,
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.indigoAccent[700],
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
                                      widget.profile_user.threadCount
                                          .toString() +
                                      ')',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20)),
                              const SizedBox(height: 10),
                              Container(
                                height: width / 3,
                                width: width / 3,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
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
          ],
        ),
      ),
    );
  }
}

class clzCSFS extends StatefulWidget {
  Username app_user;
  Username profile_user;
  String category;
  List<dynamic> heads_list;
  List<dynamic> memss_list;
  clzCSFS(this.app_user, this.profile_user, this.category, this.heads_list,
      this.memss_list);

  @override
  State<clzCSFS> createState() => _clzCSFSState();
}

class _clzCSFSState extends State<clzCSFS> {
  bool total_loaded = false;
  void load_data_fun(String head_ids, String member_ids) async {
    if (widget.heads_list.isEmpty && widget.memss_list.isEmpty) {
      Map<List<dynamic>, List<dynamic>> category_list =
          await user_profile_servers().get_all_type_category_data(
              widget.category, head_ids, member_ids);
      setState(() {
        total_loaded = true;
        widget.heads_list = category_list.keys.elementAt(0);
        widget.memss_list = category_list.values.elementAt(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category == 'club') {
      List<String> head_ids = [];
      Map head = widget.profile_user.clzClubs!['head'];
      head.forEach((key, value) {
        head_ids.add(key.toString());
      });
      List<String> team_ids = [];
      Map team = widget.profile_user.clzClubs!['team_member'];
      team.forEach((key, value) {
        team_ids.add(key.toString());
      });
      load_data_fun(head_ids.join('#'), team_ids.join('#'));
    } else if (widget.category == 'sport') {
      List<String> head_ids = [];
      Map head = widget.profile_user.clzSports!['head'];
      head.forEach((key, value) {
        head_ids.add(key.toString());
      });
      List<String> team_ids = [];
      Map team = widget.profile_user.clzSports!['team_member'];
      team.forEach((key, value) {
        team_ids.add(key.toString());
      });
      load_data_fun(head_ids.join('#'), team_ids.join('#'));
    } else if (widget.category == 'fest') {
      List<String> head_ids = [];
      Map head = widget.profile_user.clzFests!['head'];
      head.forEach((key, value) {
        head_ids.add(key.toString());
      });
      List<String> team_ids = [];
      Map team = widget.profile_user.clzFests!['team_member'];
      team.forEach((key, value) {
        team_ids.add(key.toString());
      });
      load_data_fun(head_ids.join('#'), team_ids.join('#'));
    } else if (widget.category == 'sac') {
      List<String> head_ids = [];
      Map head = widget.profile_user.clzSacs!['head'];
      head.forEach((key, value) {
        head_ids.add(key.toString());
      });
      List<String> team_ids = [];
      Map team = widget.profile_user.clzSacs!['team_member'];
      team.forEach((key, value) {
        team_ids.add(key.toString());
      });
      load_data_fun(head_ids.join('#'), team_ids.join('#'));
    }
    return !total_loaded
        ? Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Center(child: CircularProgressIndicator()))
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const Text("Head : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black)),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: ListView.builder(
                        itemCount: widget.heads_list.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 10),
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: UserMarkAdmin(widget.heads_list[index],
                                widget.category, widget.app_user),
                          );
                        })),
                const SizedBox(height: 10),
                const Text("Team Member : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black)),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: ListView.builder(
                        itemCount: widget.memss_list.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 10),
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: UserMarkAdmin(widget.memss_list[index],
                                widget.category, widget.app_user),
                          );
                        }))
              ],
            ),
          );
  }
}
