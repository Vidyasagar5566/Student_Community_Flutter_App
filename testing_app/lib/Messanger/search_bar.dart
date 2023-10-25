import 'package:flutter/material.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import 'messanger.dart';
import 'package:testing_app/first_page.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';
import 'package:testing_app/Login/Servers.dart';
import 'package:testing_app/User_profile/profile.dart';

class search_bar extends StatefulWidget {
  Username app_user;
  String domain;
  search_bar(this.app_user, this.domain);

  @override
  State<search_bar> createState() => _search_barState();
}

class _search_barState extends State<search_bar> {
  String username_match = "";
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
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none),
          onChanged: (value) {
            setState(() {
              username_match = value;
            });
          },
        ),
        actions: [
          DropdownButton<String>(
              value: widget.domain,
              underline: Container(),
              iconEnabledColor: Colors.white,
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
      body: FutureBuilder<List<SmallUsername>>(
        future: messanger_servers().get_searched_user_list(
            username_match, domains1[widget.domain]!, 0),
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
                    users_list, widget.app_user, username_match, widget.domain);
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
  user_list_display(
      this.all_search_users, this.app_user, this.username_match, this.domain);

  @override
  State<user_list_display> createState() => _user_list_displayState();
}

class _user_list_displayState extends State<user_list_display> {
  bool _circularind = false;
  bool total_loaded = true;
  void load_data_fun() async {
    List<SmallUsername> latest_search_users = await messanger_servers()
        .get_searched_user_list(widget.username_match, domains1[widget.domain]!,
            all_search_users.length);
    if (latest_search_users.length != 0) {
      all_search_users += latest_search_users;
      setState(() {
        widget.all_search_users = all_search_users;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 400),
          content: Text("all the feed was shown..",
              style: TextStyle(color: Colors.white))));
    }
    setState(() {
      total_loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: _circularind == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                const Center(child: CircularProgressIndicator()),
                Container()
              ],
            )
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
                      return _buildLoadingScreen(search_user, index);
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
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.blue))
              ],
            ),
    );
  }

  Widget _buildLoadingScreen(SmallUsername search_user, int index) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return messages_viewer(widget.app_user, search_user, []);
        }));
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
                  GestureDetector(
                    onTap: () async {
                      if (widget.app_user.email != search_user.email) {
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
                                          Text(
                                              "Please wait while loading....."),
                                          SizedBox(height: 10),
                                          CircularProgressIndicator()
                                        ]),
                                  ));
                            });
                        Username all_profile_user =
                            await login_servers().get_user(search_user.email!);
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Scaffold(
                              body: userProfilePage(
                                  widget.app_user, all_profile_user));
                        }));
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 48, //post.profile_pic
                          child: search_user.fileType == '1'
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(search_user.profilePic!))
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
                                ),
                              ]),
                        ),
                      ],
                    ),
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
}
