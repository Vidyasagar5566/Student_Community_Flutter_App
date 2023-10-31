import 'package:flutter/material.dart';
import '/All_clubs/Servers.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/Servers.dart';
import '/First_page.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import 'Club_page.dart';

class club_search_bar extends StatefulWidget {
  Username app_user;
  int club_id;
  String domain;
  bool club_create;
  bool team_selection;
  club_search_bar(this.app_user, this.club_id, this.domain, this.club_create,
      this.team_selection);

  @override
  State<club_search_bar> createState() => _club_search_barState();
}

class _club_search_barState extends State<club_search_bar> {
  String username_match = "";
  var new_club_name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: TextField(
          //controller: ,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
              hintText: 'Search and Select New Club Head',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none),
          onChanged: (value) {
            setState(() {
              username_match = value;
            });
          },
        ),
        backgroundColor: Colors.white70,
      ),
      body: FutureBuilder<List<SmallUsername>>(
        future: all_clubs_servers()
            .get_searched_user_list(username_match, widget.domain, 0),
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
              List<SmallUsername> users_list = snapshot.data;
              if (users_list.isEmpty) {
                return Container(
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    child: const Text("No Users starting with this Name/Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24)));
              } else {
                all_search_users = users_list;
                return user_list_display(
                    users_list,
                    widget.app_user,
                    username_match,
                    widget.domain,
                    widget.club_id,
                    widget.club_create,
                    widget.team_selection);
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class user_list_display extends StatefulWidget {
  List<SmallUsername> all_search_users;
  Username app_user;
  String username_match;
  String domain;
  int club_id;
  bool club_create;
  bool team_selection;
  user_list_display(this.all_search_users, this.app_user, this.username_match,
      this.domain, this.club_id, this.club_create, this.team_selection);

  @override
  State<user_list_display> createState() => _user_list_displayState();
}

class _user_list_displayState extends State<user_list_display> {
  bool _circularind = false;
  bool total_loaded = true;
  void load_data_fun() async {
    List<SmallUsername> latest_search_users = await all_clubs_servers()
        .get_searched_user_list(
            widget.username_match, widget.domain, all_search_users.length);
    if (latest_search_users.length != 0) {
      all_search_users += latest_search_users;
      setState(() {
        widget.all_search_users = all_search_users;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text("all the feed was shown..",
              style: TextStyle(color: Colors.white))));
    }
    setState(() {
      total_loaded = true;
    });
  }

  var new_club_name;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: _circularind == true
          ? Center(
              child: Container(
                  height: 40, width: 40, child: CircularProgressIndicator()))
          : Column(
              children: [
                ListView.builder(
                    itemCount: widget.all_search_users.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      SmallUsername search_user =
                          widget.all_search_users[index];

                      if (widget.club_create) {
                        return _buildLoadingScreen_create_club(
                            search_user, index);
                      } else if (widget.team_selection) {
                        if (team_mems.containsKey(search_user.email)) {
                          search_user.isTeamMem = true;
                        }
                        return _buildLoadingScreen_club_team_mems(
                            search_user, index);
                      } else {
                        return _buildLoadingScreen_head_transfer(
                            search_user, index);
                      }
                    }),
                const SizedBox(height: 10),
                total_loaded
                    ? Container(
                        width: width,
                        height: 100,
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    total_loaded = false;
                                  });
                                  load_data_fun();
                                },
                                child: const Column(
                                  children: [
                                    Icon(Icons.add_circle_outline,
                                        size: 40, color: Colors.blue),
                                    Text(
                                      "Tap To Load more",
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                ))))
                    : Container(
                        width: 100,
                        height: 100,
                        child: const Center(
                            child:
                                CircularProgressIndicator(color: Colors.blue)))
              ],
            ),
    );
  }

  Widget _buildLoadingScreen_head_transfer(
      SmallUsername search_user, int index) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(15),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Center(
                        child: Text(
                            "Are you sure? All the club access will transfer to this user.",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(30),
                      color: Colors.blue[900],
                      child: OutlinedButton(
                          onPressed: () async {
                            bool error = await all_clubs_servers()
                                .change_club_head(
                                    widget.club_id, search_user.email!);
                            if (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration:  Duration(milliseconds: 500),
                                      content: Text(
                                          "Failed to transfer the head, try again",
                                          style:
                                              TextStyle(color: Colors.white))));
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return firstpage(0, widget.app_user);
                              }), (Route<dynamic> route) => false);
                            }
                          },
                          child: const Center(
                              child: Text(
                            "Transfer",
                            style: TextStyle(color: Colors.white),
                          ))),
                    )
                  ],
                ),
              );
            });
      },
      child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                          child: search_user.fileType! == '1'
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(search_user.profilePic!))
                              : const CircleAvatar(
                                  backgroundImage:
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
                                      search_user.username!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  userMarkNotation(search_user.starMark!)
                                ],
                              ),
                              Text(
                                domains[search_user.domain!]! +
                                    " (" +
                                    search_user.userMark! +
                                    ")",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ]),
                      )
                    ],
                  ),
                  Icon(Icons.more_horiz)
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Contact no " + search_user.phnNum!,
                //post.description,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 5),
              Text(
                " Email : " + search_user.email!,
                //post.description,
                style: TextStyle(fontSize: 15),
              ),
            ],
          )),
    );
  }

  Widget _buildLoadingScreen_create_club(SmallUsername search_user, int index) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(15),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'new_club_name',
                          hintText: 'dnd club/AI club',
                          prefixIcon: Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            new_club_name = value;
                          });
                          if (value == "") {
                            new_club_name = null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(30),
                      color: Colors.blue[900],
                      child: OutlinedButton(
                          onPressed: () async {
                            if (new_club_name == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    
                                    duration:  Duration(milliseconds: 500),
                                      content: Text("Club name cant be null",
                                          style:
                                              TextStyle(color: Colors.white))));
                            } else {
                              bool error = await all_clubs_servers()
                                  .create_club(
                                      search_user.email!, new_club_name);
                              if (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      
                                        duration: Duration(milliseconds: 500),
                                        content: Text(
                                            "Failed to transfer the head, try again",
                                            style: TextStyle(
                                                color: Colors.white))));
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return firstpage(0, widget.app_user);
                                }), (Route<dynamic> route) => false);
                              }
                            }
                          },
                          child: const Center(
                              child: Text(
                            "Create Club",
                            style: TextStyle(color: Colors.white),
                          ))),
                    )
                  ],
                ),
              );
            });
      },
      child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                          child: search_user.fileType! == '1'
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(search_user.profilePic!))
                              : const CircleAvatar(
                                  backgroundImage:
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
                                      search_user.username!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  userMarkNotation(search_user.starMark!)
                                ],
                              ),
                              Text(
                                domains[search_user.domain!]! +
                                    " (" +
                                    search_user.userMark! +
                                    ")",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ]),
                      )
                    ],
                  ),
                  Icon(Icons.more_horiz)
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Contact no " + search_user.phnNum!,
                //post.description,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 5),
              Text(
                " Email : " + search_user.email!,
                //post.description,
                style: TextStyle(fontSize: 15),
              ),
            ],
          )),
    );
  }

  Widget _buildLoadingScreen_club_team_mems(
      SmallUsername search_user, int index) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {},
      child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                          child: search_user.fileType! == '1'
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(search_user.profilePic!))
                              : const CircleAvatar(
                                  backgroundImage:
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
                                      search_user.username!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  userMarkNotation(search_user.starMark!)
                                ],
                              ),
                              Text(
                                domains[search_user.domain!]! +
                                    " (" +
                                    search_user.userMark! +
                                    ")",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ]),
                      )
                    ],
                  ),
                  Checkbox(
                    value: search_user.isTeamMem,
                    onChanged: (bool? value) {
                      if (value == true) {
                        setState(() {
                          team_mems[search_user.email!] = "";
                        });
                      } else {
                        setState(() {
                          team_mems.remove(search_user.email);
                        });
                      }
                      setState(() {
                        search_user.isTeamMem = value!;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Contact no " + search_user.phnNum!,
                //post.description,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 5),
              Text(
                " Email : " + search_user.email!,
                //post.description,
                style: TextStyle(fontSize: 15),
              ),
            ],
          )),
    );
  }
}
