import 'package:flutter/material.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/servers.dart';
import '/Messanger/Servers.dart';
import '/First_page.dart';
import 'Servers.dart';
import 'User_Profile_Star_Mark.dart';

class editUserStarMark extends StatefulWidget {
  Username app_user;
  String domain;
  editUserStarMark(this.app_user, this.domain);

  @override
  State<editUserStarMark> createState() => _editUserStarMarkState();
}

class _editUserStarMarkState extends State<editUserStarMark> {
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
        backgroundColor: Colors.white70,
      ),
      body: FutureBuilder<List<SmallUsername>>(
        future: messanger_servers()
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

List<int> star_marks = [0, 1, 2, 3, 4];
List<bool> is_student_admins = [true, false];
List<bool> is_admins = [true, false];

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
        if (search_user.starMark! <= 4) {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
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
                          child: TextFormField(
                            initialValue: search_user.userMark,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'New_User_Mark',
                              hintText: 'ClubMember',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                search_user.userMark = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Select Star Mark"),
                              const SizedBox(width: 15),
                              DropdownButton<int>(
                                  value: search_user.starMark,
                                  underline: Container(),
                                  elevation: 0,
                                  items: star_marks
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      search_user.starMark = value!;
                                    });
                                  })
                            ]),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Is Admin"),
                              const SizedBox(width: 15),
                              DropdownButton<bool>(
                                  value: search_user.isAdmin,
                                  underline: Container(),
                                  elevation: 0,
                                  items: is_admins.map<DropdownMenuItem<bool>>(
                                      (bool value) {
                                    return DropdownMenuItem<bool>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      search_user.isAdmin = value!;
                                    });
                                  })
                            ]),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Is Student Admin"),
                              const SizedBox(width: 15),
                              DropdownButton<bool>(
                                  value: search_user.isStudentAdmin,
                                  underline: Container(),
                                  elevation: 0,
                                  items: is_student_admins
                                      .map<DropdownMenuItem<bool>>(
                                          (bool value) {
                                    return DropdownMenuItem<bool>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      search_user.isStudentAdmin = value!;
                                    });
                                  })
                            ]),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.all(30),
                          color: Colors.blue[900],
                          child: OutlinedButton(
                              onPressed: () async {
                                if (search_user.userMark == "" ||
                                    search_user.isAdmin! == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "user_mark/Admin cant be null",
                                              style: TextStyle(
                                                  color: Colors.white))));
                                } else {
                                  bool error = await user_star_mark_servers()
                                      .updating_user_star_mark(
                                          search_user.email!,
                                          search_user.userMark!,
                                          search_user.starMark!,
                                          search_user.isAdmin!,
                                          search_user.isStudentAdmin!);
                                  if (error) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Failed to Update the user, try again",
                                                style: TextStyle(
                                                    color: Colors.white))));
                                  } else {
                                    Navigator.pop(context);
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
                                "Update User",
                                style: TextStyle(color: Colors.white),
                              ))),
                        )
                      ],
                    ),
                  );
                });
              });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("You Cannot edit InstaBook Users",
                  style: TextStyle(color: Colors.white))));
        }
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
}
