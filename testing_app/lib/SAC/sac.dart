import 'package:flutter/material.dart';
import '/SAC/Uploads.dart';
import '/Threads/Threads.dart';
import 'Servers.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/servers.dart';
import 'Models.dart';
import '/Reports/Uploads.dart';
import 'Search_bar.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import '/User_profile/Servers.dart';
import '/User_profile/User_posts_category.dart';
import '/Activities/Activities.dart';

class sacpagewidget extends StatefulWidget {
  Username app_user;
  String domain;
  sacpagewidget(this.app_user, this.domain);

  @override
  State<sacpagewidget> createState() => _sacpagewidgetState();
}

class _sacpagewidgetState extends State<sacpagewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.blue, // <-- SEE HERE
        ),
        centerTitle: false,
        title: const Text(
          "SAC PAGE",
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
      body: FutureBuilder<List<SAC_MEMS>>(
        future: sac_servers().get_sac_list(domains1[widget.domain]!),
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
              List<SAC_MEMS> sac_list = snapshot.data;
              return _buildListView(sac_list);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: widget.app_user.clzSacsHead!
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return sac_search_bar(
                      widget.app_user, 0, widget.app_user.domain!, true);
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

  Widget _buildListView(List<SAC_MEMS> sac_list) {
    return sac_list.isEmpty
        ? Container(
            child: const Center(
              child: Text("No Data Was Found"),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: ListView.builder(
                  itemCount: sac_list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 10),
                  itemBuilder: (BuildContext context, int index) {
                    SAC_MEMS sac_mem = sac_list[index];
                    return _buildLoadingScreen(sac_mem);
                  }),
            ));
  }

  Widget _buildLoadingScreen(SAC_MEMS sac_mem) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return sacProfilePage(widget.app_user, sac_mem, 0);
        }));
      },
      child: Container(
          margin: EdgeInsets.only(left: 6, right: 6, top: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Shadow color
              offset:
                  Offset(0, 1), // Offset of the shadow (horizontal, vertical)
              blurRadius: 4, // Spread of the shadow
              spreadRadius: 0, // Expansion of the shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                        child: sac_mem.imgRatio! == 1
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(sac_mem.logo!))
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage("images/profile.jpg")),
                      ),
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
                                      sac_mem.head!.username!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  userMarkNotation(sac_mem.starMark!)
                                ],
                              ),
                              Text(
                                domains[sac_mem.domain!]! +
                                    " (" +
                                    sac_mem.head!.userMark! +
                                    ")",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ]),
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        if (widget.app_user.username ==
                            sac_mem.head!.username) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return edit_sac_mem(
                                widget.app_user,
                                sac_mem.id!,
                                sac_mem.logo,
                                sac_mem.imgRatio,
                                sac_mem.name,
                                sac_mem.description,
                                sac_mem.phoneNum,
                                sac_mem.email);
                          }));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Only for club admin',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return report_upload(
                                              widget.app_user,
                                              'sac_mem' +
                                                  " :" +
                                                  sac_mem.head!.username!,
                                              sac_mem.head!.username!);
                                        }));
                                      },
                                      child: const Text(
                                        "Report",
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.more_horiz))
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_2_outlined,
                          size: 31,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 23,
                        ),
                        Center(
                          child: Text(
                            sac_mem.name!,
                            //'''Academic Affairs secretory(AAS)''',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.call_outlined,
                          size: 29,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Center(
                          child: Text(
                            sac_mem.phoneNum!,
                            //'+91 000 000 000',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Divider(
                      color: Colors.grey[300],
                      height: 15,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text(
                        sac_mem.description!,
                        //"The Academic Secretary is responsible for the administration of the University's academic business and for the oversight of University academic policy. University academic business and policy (academic affairs) is controlled by Academic Council. Academic Council is the primary internal body responsible for academic affairs and derives",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ])),
            ],
          )),
    );
  }
}

class sacProfilePage extends StatefulWidget {
  Username app_user;
  SAC_MEMS sac;
  int curr_index;
  sacProfilePage(this.app_user, this.sac, this.curr_index);

  @override
  State<sacProfilePage> createState() => _sacProfilePageState();
}

class _sacProfilePageState extends State<sacProfilePage> {
  bool loaded = false;
  var thread_list;
  var event_list;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.sac.name!, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigoAccent[700],
      ),
      body: Container(
          child: widget.curr_index == 0
              ? SingleChildScrollView(
                  child: user_postswidget(
                      '', widget.app_user, 'club', widget.sac.id!),
                )
              : widget.curr_index == 1
                  ? SingleChildScrollView(
                      child: loaded
                          ? activitieswidget1(event_list, widget.app_user,
                              widget.app_user.domain!, true)
                          : Container(
                              margin: EdgeInsets.only(top: height / 3),
                              child:
                                  Center(child: CircularProgressIndicator())))
                  : SingleChildScrollView(
                      child: loaded
                          ? alertwidget1(thread_list, widget.app_user,
                              widget.app_user.domain!, true)
                          : Container(
                              margin: EdgeInsets.only(top: height / 3),
                              child:
                                  Center(child: CircularProgressIndicator())),
                    )),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        backgroundColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              label: "Posts",
              icon: Icon(
                Icons.person,
              )),
          BottomNavigationBarItem(
              label: "Activities",
              icon: Icon(
                Icons.local_activity,
                size: 30,
              )),
          BottomNavigationBarItem(
              label: "Issues",
              icon: Icon(
                Icons.add_alert,
              )),
        ],
        currentIndex: widget.curr_index,
        onTap: (int index) async {
          setState(() {
            widget.curr_index = index;
            loaded = false;
          });
          if (index == 1) {
            event_list = await user_profile_servers()
                .get_user_activity_list('', 'sac', widget.sac.id!);
          } else if (index == 2) {
            thread_list = await user_profile_servers()
                .get_user_thread_list('', 'sac', widget.sac.id!);
          }
          setState(() {
            loaded = true;
          });
        },
      ),
    );
    ;
  }
}
