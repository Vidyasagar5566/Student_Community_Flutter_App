import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/Messanger/messanger.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/servers.dart';
import 'chatroom.dart';
import '/First_page.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import '/Login/Servers.dart';
import '/User_profile/profile.dart';

Map<String, bool> group_mems = {};

class search_bar extends StatefulWidget {
  Username app_user;
  String domain;
  String group_create_edit;
  ChatRoomModel chatroomedit;
  search_bar(
      this.app_user, this.domain, this.group_create_edit, this.chatroomedit);

  @override
  State<search_bar> createState() => _search_barState();
}

class _search_barState extends State<search_bar> {
  String username_match = "";

  @override
  Widget build(BuildContext context) {
    if (widget.chatroomedit.participants != null) {
      List<String> uuids = widget.chatroomedit.participants!.keys.toList();
      for (int i = 0; i < widget.chatroomedit.participants!.length; i++) {
        group_mems[uuids[i]] = true;
      }
    }

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
        // actions: [
        //   widget.group_create_edit == ""
        //       ? DropdownButton<String>(
        //           value: widget.domain,
        //           underline: Container(),
        //           iconEnabledColor: Colors.white,
        //           elevation: 0,
        //           items: domains_list
        //               .map<DropdownMenuItem<String>>((String value) {
        //             return DropdownMenuItem<String>(
        //               value: value,
        //               child: Text(
        //                 value,
        //                 style: TextStyle(fontSize: 10),
        //               ),
        //             );
        //           }).toList(),
        //           onChanged: (value) {
        //             setState(() {
        //               widget.domain = value!;
        //             });
        //           })
        //       : Container()
        // ],
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
                if (widget.chatroomedit.participants != null) {
                  for (int i = 0; i < users_list.length; i++) {
                    if (widget.chatroomedit.participants!.keys
                        .contains(users_list[i].userUuid)) {
                      users_list[i].isTeamMem = true;
                    }
                  }
                }
                return user_list_display(
                    users_list,
                    widget.app_user,
                    username_match,
                    widget.domain,
                    widget.group_create_edit,
                    widget.chatroomedit);
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: widget.group_create_edit != ""
          ? ElevatedButton.icon(
              onPressed: () async {
                if (widget.group_create_edit == "create_group") {
                  if (group_mems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(milliseconds: 400),
                        content: Text("Select atleast one person..",
                            style: TextStyle(color: Colors.white))));
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return creatingNewGroup(widget.app_user);
                    }));
                  }
                } else {
                  if (group_mems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(milliseconds: 400),
                        content: Text("Select atleast one person..",
                            style: TextStyle(color: Colors.white))));
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return editGroupChat(
                          widget.app_user, widget.chatroomedit);
                    }));
                  }
                }
              },
              label: widget.group_create_edit == "create_group"
                  ? const Text("Create new group",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                  : const Text("Edit group",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.edit, color: Colors.white),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
            )
          : Container(),
    );
  }
}

class user_list_display extends StatefulWidget {
  List<SmallUsername> all_search_users;
  Username app_user;
  String username_match;
  String domain;
  String group_create_edit;
  ChatRoomModel chatRoom;
  user_list_display(this.all_search_users, this.app_user, this.username_match,
      this.domain, this.group_create_edit, this.chatRoom);

  @override
  State<user_list_display> createState() => _user_list_displayState();
}

class _user_list_displayState extends State<user_list_display> {
  bool _circularind = false;
  bool total_loaded = true;
  void load_data_fun() async {
    List<SmallUsername> latest_search_users = await messanger_servers()
        .get_searched_user_list(widget.username_match, domains1[widget.domain]!,
            widget.all_search_users.length);
    if (latest_search_users.length != 0) {
      if (select_all == true) {
        for (int i = 0; i < latest_search_users.length; i++) {
          latest_search_users[i].isTeamMem = true;
        }
      }
      setState(() {
        widget.all_search_users += latest_search_users;
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

  bool select_all = false;
  select_all_users_fun(bool? value) {
    if (value == true) {
      for (int i = 0; i < widget.all_search_users.length; i++) {
        setState(() {
          widget.all_search_users[i].isTeamMem = true;
          group_mems[widget.all_search_users[i].userUuid!] = true;
        });
      }
    } else {
      for (int i = 0; i < widget.all_search_users.length; i++) {
        if (widget.group_create_edit == "edit_group") {
          if (widget.chatRoom.participants!
                  .containsKey(widget.all_search_users[i].userUuid) ==
              false) {
            setState(() {
              widget.all_search_users[i].isTeamMem = false;
            });
            try {
              setState(() {
                group_mems.remove(widget.all_search_users[i].userUuid!);
              });
            } catch (e) {}
          }
        } else {
          setState(() {
            widget.all_search_users[i].isTeamMem = false;
          });
          try {
            setState(() {
              group_mems.remove(widget.all_search_users[i].userUuid!);
            });
          } catch (e) {}
        }
      }
    }
    setState(() {
      select_all = value!;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 10, right: 20),
                    child: Text("First " +
                        widget.all_search_users.length.toString() +
                        " Users")),
                (widget.group_create_edit != "") &&
                        (widget.app_user.isAdmin! ||
                            widget.app_user.isStudentAdmin!)
                    ? Container(
                        margin: EdgeInsets.only(left: 40, right: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Select all"),
                              Checkbox(
                                value: select_all,
                                onChanged: (bool? value) {
                                  select_all_users_fun(value);
                                },
                              )
                            ]),
                      )
                    : Container(),
                const SizedBox(height: 10),
                ListView.builder(
                    itemCount: widget.all_search_users.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      SmallUsername search_user =
                          widget.all_search_users[index];
                      if (widget.group_create_edit == "create_group") {
                        return _buildLoadingScreen_create_group(
                            search_user, index);
                      } else if (widget.group_create_edit == "edit_group") {
                        return _buildLoadingScreen_edit_group(
                            search_user, index);
                      } else {
                        return _buildLoadingScreen(search_user, index);
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
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.blue))
              ],
            ),
    );
  }

  Future<ChatRoomModel?> getChatRoomModel(SmallUsername targetuser) async {
    ChatRoomModel? chatroom1;
    List<List<bool>> all_poss = [
      [true, false],
      [false, true],
      [false, false]
    ];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("group", isEqualTo: false)
        .where("participants.${widget.app_user.userUuid}", isEqualTo: true)
        .where("participants.${targetuser.userUuid}", isEqualTo: true)
        .get();
    ;
    for (int i = 0; i < 3; i++) {
      if (snapshot.docs.length > 0) {
        break;
      }
      snapshot = await FirebaseFirestore.instance
          .collection("chatrooms")
          .where("group", isEqualTo: false)
          .where("participants.${widget.app_user.userUuid}",
              isEqualTo: all_poss[i][0])
          .where("participants.${targetuser.userUuid}",
              isEqualTo: all_poss[i][1])
          .get();
    }

    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingchatroom =
          ChatRoomModel.FromMap(docData as Map<String, dynamic>);
      chatroom1 = existingchatroom;
    } else {
      ChatRoomModel newchatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastmessage: "",
        lastmessagetype: 0,
        lastmessageseen: false,
        lastmessagetime: DateTime.now(),
        lastmessagesender: widget.app_user.email,
        participants: {
          widget.app_user.userUuid.toString(): true,
          targetuser.userUuid.toString(): true
        },
        group: false,
      );
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newchatroom.chatroomid)
          .set(newchatroom.toMap());
      chatroom1 = newchatroom;
    }
    return chatroom1;
  }

  UsetToUserProfile(SmallUsername search_user) async {
    if (widget.app_user.email != search_user.email) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
                contentPadding: EdgeInsets.all(15),
                content: Container(
                  margin: EdgeInsets.all(10),
                  child:
                      const Column(mainAxisSize: MainAxisSize.min, children: [
                    Text("Please wait while loading....."),
                    SizedBox(height: 10),
                    CircularProgressIndicator()
                  ]),
                ));
          });
      Username all_profile_user =
          await login_servers().get_user(search_user.email!);
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
            body: userProfilePage(widget.app_user, all_profile_user));
      }));
    }
  }

  Widget _buildLoadingScreen(SmallUsername search_user, int index) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        if (widget.app_user.email == "guest@nitc.ac.in") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(milliseconds: 400),
              content: Text("guest cannot chat with others..",
                  style: TextStyle(color: Colors.white))));
        } else {
          ChatRoomModel? chatroomModel = await getChatRoomModel(search_user);
          if (chatroomModel != null) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return chatRoomStream(
                  targetuser: search_user,
                  chatRoom: chatroomModel,
                  app_user: widget.app_user);
            }));
          }
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
                  GestureDetector(
                    onTap: () async {
                      await UsetToUserProfile(search_user);
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

  Widget _buildLoadingScreen_create_group(
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
                  GestureDetector(
                    onTap: () async {
                      await UsetToUserProfile(search_user);
                    },
                    child: Row(
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
                  ),
                  Checkbox(
                    value: search_user.isTeamMem,
                    onChanged: (bool? value) {
                      if (value == true) {
                        setState(() {
                          group_mems[search_user.userUuid!] = true;
                        });
                      } else {
                        setState(() {
                          group_mems.remove(search_user.userUuid);
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

  Widget _buildLoadingScreen_edit_group(SmallUsername search_user, int index) {
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
                  GestureDetector(
                    onTap: () async {
                      await UsetToUserProfile(search_user);
                    },
                    child: Row(
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
                  ),
                  Checkbox(
                    value: search_user.isTeamMem,
                    onChanged: (bool? value) {
                      setState(() {
                        search_user.isTeamMem = value!;
                      });
                      if (value == true) {
                        setState(() {
                          group_mems[search_user.userUuid!] = true;
                        });
                      } else {
                        setState(() {
                          group_mems.remove(search_user.userUuid);
                        });
                      }
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

class creatingNewGroup extends StatefulWidget {
  Username app_user;
  creatingNewGroup(this.app_user);

  @override
  State<creatingNewGroup> createState() => _creatingNewGroupState();
}

class _creatingNewGroupState extends State<creatingNewGroup> {
  @override
  var group_icon;
  var group_name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Community",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Add Community Details",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Community name',
                              hintText: 'ECE Community',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                group_name = value;
                              });
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'please enter email'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Add Group Icon",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image1 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 35);
                              setState(() {
                                group_icon = File(image1!.path);
                              });
                            } else {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image1 = await _picker.pickImage(
                                  source: ImageSource.gallery, imageQuality: 5);
                              setState(() {
                                group_icon = File(image1!.path);
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        (group_icon != null && group_name != null)
                            ? Container(
                                padding: EdgeInsets.only(left: 40, right: 40),
                                margin: EdgeInsets.only(top: 40),
                                width: 270,
                                height: 60,
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    if (widget.app_user.email ==
                                        "guest@nitc.ac.in") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "guest are not allowed to share lost/found..",
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: const Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Please wait while creating....."),
                                                        SizedBox(height: 10),
                                                        CircularProgressIndicator()
                                                      ]),
                                                ));
                                          });
                                      setState(() {
                                        group_mems[widget.app_user.userUuid!] =
                                            true;
                                      });

                                      String uid = uuid.v1();
                                      UploadTask uploadtask = FirebaseStorage
                                          .instance
                                          .ref("photo_messages")
                                          .child(uid.toString())
                                          .putFile(group_icon);
                                      TaskSnapshot snapshot = await uploadtask;
                                      String imageurl =
                                          await snapshot.ref.getDownloadURL();
                                      ChatRoomModel newchatroom = ChatRoomModel(
                                          chatroomid: uuid.v1(),
                                          lastmessage: "",
                                          lastmessagetype: 0,
                                          lastmessageseen: false,
                                          lastmessagetime: DateTime.now(),
                                          lastmessagesender:
                                              widget.app_user.email,
                                          participants: group_mems,
                                          group: true,
                                          group_creator: widget.app_user.email,
                                          group_name: group_name,
                                          group_icon: imageurl,
                                          participants_seen: {});
                                      await FirebaseFirestore.instance
                                          .collection("chatrooms")
                                          .doc(newchatroom.chatroomid)
                                          .set(newchatroom.toMap());
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return messanger(widget.app_user, 1);
                                      }));
                                    }
                                  },
                                  color: Colors.indigo[200],
                                  textColor: Colors.black,
                                  child: const Text(
                                    "Create",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))
                            : Container(
                                margin: EdgeInsets.only(top: 40),
                                padding: EdgeInsets.only(left: 40, right: 40),
                                width: 250,
                                height: 55,
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 400),
                                        content: Text(
                                          "Fill all the details",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                  color: Colors.green[200],
                                  textColor: Colors.white,
                                  child: const Text("Create",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                )),
                        const SizedBox(height: 10),
                        group_icon != null
                            ? Container(
                                // image_ratio,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(group_icon))
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class editGroupChat extends StatefulWidget {
  Username app_user;
  ChatRoomModel editchatroom;
  editGroupChat(
    this.app_user,
    this.editchatroom,
  );

  @override
  State<editGroupChat> createState() => _editGroupChatState();
}

class _editGroupChatState extends State<editGroupChat> {
  var new_group_icon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Community",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Add Community Details",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            initialValue: widget.editchatroom.group_name,
                            decoration: const InputDecoration(
                              labelText: 'Community name',
                              hintText: 'ECE Community',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.editchatroom.group_name = value;
                              });
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'please enter email'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Add Group Icon",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image1 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 35);
                              setState(() {
                                new_group_icon = File(image1!.path);
                              });
                            } else {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image1 = await _picker.pickImage(
                                  source: ImageSource.gallery, imageQuality: 5);
                              setState(() {
                                new_group_icon = File(image1!.path);
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        (widget.editchatroom.group_icon != null &&
                                widget.editchatroom.group_name != "")
                            ? Container(
                                padding: EdgeInsets.only(left: 40, right: 40),
                                margin: EdgeInsets.only(top: 40),
                                width: 270,
                                height: 60,
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    if (widget.app_user.email ==
                                        "guest@nitc.ac.in") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "guest are not allowed to share lost/found..",
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: const Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Please wait while creating....."),
                                                        SizedBox(height: 10),
                                                        CircularProgressIndicator()
                                                      ]),
                                                ));
                                          });
                                      setState(() {
                                        group_mems[widget.app_user.userUuid!] =
                                            true;
                                      });

                                      String imageurl =
                                          widget.editchatroom.group_icon!;
                                      if (new_group_icon != null) {
                                        String uid = uuid.v1();
                                        UploadTask uploadtask = FirebaseStorage
                                            .instance
                                            .ref("photo_messages")
                                            .child(uid.toString())
                                            .putFile(new_group_icon);
                                        TaskSnapshot snapshot =
                                            await uploadtask;
                                        imageurl =
                                            await snapshot.ref.getDownloadURL();
                                      }

                                      widget.editchatroom.participants =
                                          group_mems;
                                      widget.editchatroom.group_icon = imageurl;

                                      await FirebaseFirestore.instance
                                          .collection("chatrooms")
                                          .doc(widget.editchatroom.chatroomid)
                                          .set(widget.editchatroom.toMap());
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return messanger(widget.app_user, 1);
                                      }));
                                    }
                                  },
                                  color: Colors.indigo[200],
                                  textColor: Colors.black,
                                  child: const Text(
                                    "Create",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))
                            : Container(
                                margin: EdgeInsets.only(top: 40),
                                padding: EdgeInsets.only(left: 40, right: 40),
                                width: 250,
                                height: 55,
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 400),
                                        content: Text(
                                          "Fill all the details",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                  color: Colors.green[200],
                                  textColor: Colors.white,
                                  child: const Text("Edit",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                )),
                        const SizedBox(height: 10),
                        new_group_icon != null
                            ? Container(
                                // image_ratio,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(new_group_icon))
                            : Container(
                                // image_ratio,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.network(
                                    widget.editchatroom.group_icon!)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
