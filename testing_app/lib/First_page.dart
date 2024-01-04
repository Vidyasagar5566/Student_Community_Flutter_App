import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testing_app/Login/latest_login.dart';
import '/Dating/dating.dart';
import '/Login/login.dart';
import '/Lost_&_Found/Lost_Found.dart';
import 'Lost_&_Found/Upload.dart';
import '/Activities/Uploads.dart';
import '/App_notifications/Uploads.dart';
import '/Calender/Calender_date_event.dart';
import '/Calender/Calender.dart';
import '/Calender/Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';
import '/Notes/QN_paper.dart';
import '/Placements/placements.dart';
import '/Register_Update/Register.dart';
import '/SAC/Sac.dart';
import '/Side_menu_bar/Servers.dart';
import '/Threads/Models.dart';
import '/Threads/Threads.dart';
import '/Threads/Uploads.dart';
import '/Timings/Timings.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import '/User_profile/Models.dart';
import '/calender/Uploads.dart';
import '/Activities/Models.dart';
import '/All_fests/All_fests.dart';
import '/Login/Servers.dart';
import '/Mess_menus/Mess_menu.dart';
import '/Posts/Models.dart';
import '/Posts/Post.dart';
import 'All_clubs/All_clubs.dart';
import 'User_profile/Profile.dart';
import 'All_sports/All_sports.dart';
import 'Activities/Activities.dart';
import 'BuySell/Uploads.dart';
import 'Posts/Uploads.dart';
import 'Side_menu_bar/Side_menu.dart';
import 'BuySell/buysell.dart';
import 'Circular_designs/Circular_Indicator.dart';
import 'App_notifications/Notifications.dart';
import 'Messanger/messanger.dart';
import 'dart:async';
import 'Calender/Servers.dart';

List<POST_LIST> all_posts = [];
List<POST_LIST> all_admin_posts = [];
List<ALERT_LIST> all_alerts = [];
List<EVENT_LIST> all_events = [];
List<POST_LIST> user_posts = [];
List<SmallUsername> all_search_users = [];
Username app_user = Username();

class get_ueser_widget extends StatefulWidget {
  int curr_index;
  get_ueser_widget(this.curr_index);

  @override
  State<get_ueser_widget> createState() => _get_ueser_widgetState();
}

class _get_ueser_widgetState extends State<get_ueser_widget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Username>(
      future: login_servers().get_user(''),
      builder: (ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return crclr_ind_error();
          } else if (snapshot.hasData) {
            app_user = snapshot.data;
            if (app_user.email == null) {
              return latest_loginpage(
                  "error occured please login again", 'Nit Calicut');
            }
            app_user = app_user;

            star_user_mark(app_user);

            if (!app_user.isDetails!) {
              return LoginRegister(app_user);
            }
            if (Platform.isAndroid) {
              if (app_user.updateMark != "instabook5") {
                return appUpdate();
              } else {
                return firstpage(widget.curr_index, app_user);
              }
            } else if (Platform.isIOS) {
              if (app_user.updateMark != "instabook5") {
                return appUpdate();
              } else {
                all_posts = [];
                all_admin_posts = [];
                all_alerts = [];
                all_dates = [];
                all_events = [];
                user_posts = [];
                all_search_users = [];
                return firstpage(widget.curr_index, app_user);
              }
            }
          }
        }
        return crclr_ind_appbar();
      },
    );
  }
}

class firstpage extends StatefulWidget {
  int curr_index;
  Username app_user;
  firstpage(this.curr_index, this.app_user);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  String domain = 'All';
  bool drop_colors = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: RefreshIndicator(
        displacement: 150,
        //backgroundColor: Colors.yellow,
        color: Colors.blue,
        strokeWidth: 2,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 400));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      get_ueser_widget(widget.curr_index)),
              (Route<dynamic> route) => false);
        },

        child: Scaffold(
          appBar: widget.curr_index == 0
              ? AppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                  centerTitle: false,
                  title: ((widget.app_user.email == "shiva@gmail.com" ||
                          widget.app_user.email == "guest@gmail.com")
                      ? const Text(
                          "ESMUS",
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          domains[widget.app_user.domain!]!,
                          style: const TextStyle(color: Colors.black),
                        )),
                  actions: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.app_user.notifCount = 0;
                            });
                            menu_bar_servers().notif_seen();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return notifications(widget.app_user);
                            }));
                          },
                          child: Stack(children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.app_user.notifCount = 0;
                                });
                                menu_bar_servers().notif_seen();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return notifications(widget.app_user);
                                }));
                              },
                              icon: const Icon(
                                Icons.notifications_on_rounded,
                                size: 30,
                                color: Colors.indigo,
                              ),
                            ),
                            Positioned(
                              right: 7,
                              top: 7,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  widget.app_user.notifCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ]),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return messanger(widget.app_user, 0);
                              }));
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.facebookMessenger,
                              size: 26,
                              color: Colors.indigo,
                            ))
                      ],
                    )
                  ],
                  backgroundColor: Colors.white,
                )
              : widget.curr_index == 1
                  ? AppBar(
                      title: Text("Calendar"),
                      centerTitle: false,
                      actions: [
                        DropdownButton<String>(
                            value: domain,
                            underline: Container(),
                            elevation: 0,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            items: domains_list
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
                                domain = value!;
                              });
                            })
                      ],
                    )
                  : widget.curr_index == 2
                      ? AppBar(
                          title: Text("Events"),
                          centerTitle: false,
                          actions: [
                            DropdownButton<String>(
                                value: domain,
                                underline: Container(),
                                elevation: 0,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.black,
                                items: domains_list
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
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
                                    domain = value!;
                                  });
                                })
                          ],
                        )
                      : widget.curr_index == 3
                          ? AppBar(
                              title: Text("Threads"),
                              centerTitle: false,
                              actions: [
                                DropdownButton<String>(
                                    value: domain,
                                    underline: Container(),
                                    elevation: 0,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.black,
                                    items: domains_list
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                        domain = value!;
                                      });
                                    })
                              ],
                            )
                          : null,
          drawer: widget.curr_index == 0 ? NavDrawer(widget.app_user) : null,
          body: widget.curr_index == 0
              ? SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: MAINBUTTONSwidget1(widget.app_user),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(8),
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Posts",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ))),
                          // DropdownButton<String>(
                          //     value: domain,
                          //     underline: Container(),
                          //     elevation: 0,
                          //     items: domains_list.map<DropdownMenuItem<String>>(
                          //         (String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           style: TextStyle(fontSize: 10),
                          //         ),
                          //       );
                          //     }).toList(),
                          //     onChanged: (value) {
                          //       setState(() {
                          //         domain = value!;
                          //       });
                          //     })
                        ],
                      ),
                      Flexible(
                          child: all_posts.isEmpty
                              ? postwidget(widget.app_user, 'All')
                              : postwidget1(all_posts, app_user, domain, false))
                    ]),
                  ),
                )
              : widget.curr_index == 1
                  ? Container(
                      color: Colors.white,
                      child: all_dates.isEmpty
                          ? calender(widget.app_user, domain)
                          : calenderwidget1(app_user, domain))
                  : widget.curr_index == 2
                      ? Container(
                          color: Colors.white,
                          child: all_events.isEmpty
                              ? activitieswidget(widget.app_user, domain)
                              : activitieswidget1(
                                  all_events, app_user, domain, false))
                      : widget.curr_index == 3
                          ? Container(
                              color: Colors.white,
                              child: all_alerts.isEmpty
                                  ? alertwidget(widget.app_user, domain)
                                  : alertwidget1(
                                      all_alerts, app_user, domain, false))
                          : Container(
                              color: Colors.white,
                              child: userProfilePage(
                                  widget.app_user, widget.app_user)),
          floatingActionButton: widget.curr_index == 1
              ? ElevatedButton.icon(
                  onPressed: () async {
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
                                      Text("Please wait"),
                                      CircularProgressIndicator()
                                    ]),
                              ));
                        });
                    Map<List<CALENDER_EVENT>, List<EVENT_LIST>> total_data =
                        await calendar_servers().get_calender_event_list(
                            today.toString().split(" ")[0], domains1[domain]!);
                    Navigator.pop(context);
                    List<CALENDER_EVENT> cal_event_data =
                        total_data.keys.toList()[0];
                    List<EVENT_LIST> activity_data =
                        total_data.values.toList()[0];

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            calender_events_display(
                                widget.app_user,
                                cal_event_data,
                                activity_data,
                                today.toString().split(" ")[0])));
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text("Today Events",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                )
              : FloatingActionButton(
                  onPressed: () {
                    if (widget.curr_index == 3) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return threadCategory(widget.app_user);
                      }));
                    } else if (widget.curr_index == 2) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return eventCategory(widget.app_user);
                      }));
                    } else {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25))),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(20)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Center(
                                        child: Text("Add",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20))),
                                    const Divider(
                                      color: Colors.grey,
                                      height: 25,
                                      thickness: 2,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return lst_found_upload(
                                                widget.app_user,
                                                'lost',
                                                'belongings');
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(7),
                                            padding: EdgeInsets.all(2),
                                            child: const Row(children: [
                                              Icon(Icons.preview, size: 30),
                                              SizedBox(width: 50),
                                              Text("Lost or Found",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15))
                                            ]))),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return buy_sell_upload(
                                                widget.app_user,
                                                'buy',
                                                'belongings');
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(7),
                                            padding: EdgeInsets.all(2),
                                            child: const Row(children: [
                                              Icon(Icons.offline_share,
                                                  size: 30),
                                              SizedBox(width: 50),
                                              Text("Sharings (Buy/Sell)",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15))
                                            ]))),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return postCategory(
                                                widget.app_user);
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(7),
                                            padding: EdgeInsets.all(2),
                                            child: const Row(children: [
                                              Icon(Icons.post_add, size: 30),
                                              SizedBox(width: 50),
                                              Text("Add post",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15))
                                            ]))),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return upload_notification(
                                                widget.app_user);
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(7),
                                            padding: EdgeInsets.all(2),
                                            child: const Row(children: [
                                              Icon(Icons.announcement_outlined,
                                                  size: 30),
                                              SizedBox(width: 50),
                                              Text("Announcement ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15))
                                            ]))),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return upload_cal_event(
                                                widget.app_user);
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(7),
                                            padding: EdgeInsets.all(2),
                                            child: const Row(children: [
                                              Icon(Icons.event_available,
                                                  size: 30),
                                              SizedBox(width: 50),
                                              Text(" Calendar Events ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15))
                                            ])))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  },
                  tooltip: 'wann share',
                  child: Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  ),
                  elevation: 4.0,
                ),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.blue,
            backgroundColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(
                    Icons.home,
                  )),
              BottomNavigationBarItem(
                  label: "Calender",
                  icon: Icon(
                    Icons.calendar_month,
                  )),
              BottomNavigationBarItem(
                  label: "Activities",
                  icon: Icon(
                    Icons.local_activity,
                    size: 30,
                  )),
              BottomNavigationBarItem(
                  label: "Threads",
                  icon: FaIcon(
                    Icons.add_alert,
                  )),
              BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(
                    Icons.person,
                  )),
            ],
            currentIndex: widget.curr_index,
            onTap: (int index) {
              setState(() {
                domain = 'All';
                if (index == 1) {
                  today = DateTime.now();
                  domain = domains[widget.app_user.domain]!;
                }
                widget.curr_index = index;
                // }
              });
            },
          ),
        ),
      ),
    );
  }
}

class MAINBUTTONSwidget1 extends StatefulWidget {
  Username app_user;
  MAINBUTTONSwidget1(this.app_user);

  @override
  State<MAINBUTTONSwidget1> createState() => _MAINBUTTONSwidget1State();
}

class _MAINBUTTONSwidget1State extends State<MAINBUTTONSwidget1> {
  bool extand = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    double div = width / 4.2;
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return placements(widget.app_user, [],
                          domains[widget.app_user.domain]!);
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        // child: const CircleAvatar(
                        //   radius: 27,
                        //   backgroundColor: Colors.orangeAccent,
                        child: const CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                AssetImage("images/placement.jpeg")),
                        // )
                      ),
                      const SizedBox(height: 3),
                      const Center(
                        child: Text("Placements",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ]),
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return all_buySellwidget1(widget.app_user, "All", "All",
                          [], domains[widget.app_user.domain]!, '');
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        // child: const CircleAvatar(
                        //   radius: 23,
                        //   backgroundColor: Colors.orangeAccent,
                        child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage("images/buysell.png")),
                        // ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Sharings",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 12))
                    ],
                  ),
                ),
              ]),
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return all_lostwidget1(widget.app_user, "All", "All", [],
                          domains[widget.app_user.domain]!, '');
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        // child: const CircleAvatar(
                        //   radius: 23,
                        //   backgroundColor: Colors.orangeAccent,
                        child: const CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage("images/lostfound.jpeg")),
                        // ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text("lost&found",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ]),
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return datingUser(
                          domain: 'All', app_user: widget.app_user);
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        // child: const CircleAvatar(
                        //   radius: 24,
                        //   backgroundColor: Colors.orangeAccent,
                        child: const CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage("images/dating.jpg")),
                        // ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Connect",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 12))
                    ],
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Allclubpagewidget(widget.app_user,
                          'All'); //domains[widget.app_user.domain]!);
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        child: const CircleAvatar(
                            backgroundImage: AssetImage("images/club.jpg")),
                      ),
                      const SizedBox(height: 10),
                      const Text("Clubs",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 12))
                    ],
                  ),
                ),
              ]),
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Allsportpagewidget(widget.app_user,
                          'All'); //domains[widget.app_user.domain]!);
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        child: const CircleAvatar(
                            backgroundImage:
                                AssetImage("images/sport.jpg")), //sport.jpg
                      ),
                      const SizedBox(height: 10),
                      const Text("Sports",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 12))
                    ],
                  ),
                ),
              ]),
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Allfestspagewidget(widget.app_user,
                          'All'); //domains[widget.app_user.domain]!);
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: div, //post.profile_pic
                        child: CircleAvatar(
                            backgroundImage: AssetImage("images/fest.png")),
                      ),
                      SizedBox(height: 10),
                      Text("Fests",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 12))
                    ],
                  ),
                ),
              ]),
              extand
                  ? Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return sacpagewidget(widget.app_user,
                                'All'); // domains[widget.app_user.domain]!);
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: div,
                              //post.profile_pic
                              child: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                      AssetImage("images/sac.png")),
                            ),
                            const SizedBox(height: 10),
                            const Text("SC",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12))
                          ],
                        ),
                      ),
                    ])
                  : Column(children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            extand = true;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: div, //post.profile_pic
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 38,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("More",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12))
                          ],
                        ),
                      ),
                    ]),
            ],
          ),
          extand
              ? const SizedBox(
                  height: 50,
                )
              : Container(),
          extand
              ? Row(
                  children: [
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return all_admin_posts.isEmpty
                                ? PostWithappBar(widget.app_user,
                                    domains[widget.app_user.domain]!)
                                : Scaffold(
                                    appBar: AppBar(
                                        centerTitle: true,
                                        title: Text(
                                            domains[widget.app_user.domain]!,
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor:
                                            Colors.white //indigoAccent[700],
                                        ),
                                    body: postwidget1(all_admin_posts, app_user,
                                        domains[widget.app_user.domain]!, true),
                                  );
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: div, //post.profile_pic
                              child: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/student.png")),
                            ),
                            const SizedBox(height: 10),
                            const Text("Campus",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12))
                          ],
                        ),
                      ),
                    ]),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return branchAndSems(widget.app_user,
                                domains[widget.app_user.domain]!, 'B.Tech');
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: div, //post.profile_pic
                              child: const CircleAvatar(
                                  radius: 21,
                                  backgroundImage:
                                      AssetImage("images/book.jpeg")),
                            ),
                            const SizedBox(height: 8),
                            const Text("Notes",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12))
                          ],
                        ),
                      ),
                    ]),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AcademicTimings(
                                domains[widget.app_user.domain]!,
                                widget.app_user);
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: div, //post.profile_pic
                              child: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/timings.jpeg")),
                            ),
                            const SizedBox(height: 10),
                            const Text("Timings",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12))
                          ],
                        ),
                      ),
                    ]),
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            extand = false;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: div, //post.profile_pic
                              child:
                                  const Icon(Icons.keyboard_arrow_up, size: 38),
                            ),
                            const SizedBox(height: 10),
                            const Text("Less",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 12))
                          ],
                        ),
                      ),
                    ]),
                  ],
                )
              : Container()
        ]));
  }
}




          // Column(children: [
          //             GestureDetector(
          //               onTap: () {
          //                 Navigator.of(context).push(MaterialPageRoute(
          //                     builder: (BuildContext context) {
          //                   return messMenu(domains[widget.app_user.domain]!);
          //                 }));
          //               },
          //               child: Column(
          //                 children: [
          //                   Container(
          //                     width: div, //post.profile_pic
          //                     child: const CircleAvatar(
          //                       backgroundImage: AssetImage("images/menu.jpg"),
          //                     ),
          //                   ),
          //                   const SizedBox(height: 10),
          //                   const Text("Menu",
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w900, fontSize: 12))
          //                 ],
          //               ),
          //             ),
          //           ]),