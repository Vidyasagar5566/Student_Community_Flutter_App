import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import '../First_page.dart';
import '/Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import 'dart:convert' show utf8;
import 'chatroom.dart';
import 'search_bar.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class messanger extends StatefulWidget {
  Username app_user;
  int bottom_navbar_index;
  messanger(this.app_user, this.bottom_navbar_index);

  @override
  State<messanger> createState() => _messangerState();
}

class _messangerState extends State<messanger> {
  List<String> uids = [];
  List<dynamic> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.app_user.username!,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          widget.bottom_navbar_index == 0
              ? Container(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  child: Stack(children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return search_bar(
                              widget.app_user,
                              domains[widget.app_user.domain]!,
                              '',
                              ChatRoomModel());
                        }));
                      },
                      icon: const Icon(Icons.person_search_outlined, size: 25),
                    ),
                  ]),
                )
              : Container(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  child: Stack(children: [
                    IconButton(
                      onPressed: () {
                        if (widget.app_user.email == "guest@nitc.ac.in") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(milliseconds: 400),
                                  content: Text(
                                      "guest cannot chat create groups..",
                                      style: TextStyle(color: Colors.white))));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return search_bar(
                                widget.app_user,
                                domains[widget.app_user.domain]!,
                                'create_group',
                                ChatRoomModel());
                          }));
                        }
                      },
                      icon: const Icon(Icons.group_add_outlined, size: 25),
                    ),
                  ]),
                )
        ],
        backgroundColor: Colors.white70,
      ),
      body: widget.bottom_navbar_index == 0
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("group", isEqualTo: false)
                  .where("participants.${app_user.userUuid}", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatroomsnapshot =
                        snapshot.data as QuerySnapshot;
                    uids = [];
                    messages = [];
                    for (int index = 0;
                        index < chatroomsnapshot.docs.length;
                        index = index + 1) {
                      ChatRoomModel chatroommodel = ChatRoomModel.FromMap(
                          chatroomsnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatroommodel.participants!;
                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(app_user.userUuid);

                      if (chatroommodel.lastmessage != "" ||
                          chatroommodel.lastmessagetype! > 0) {
                        uids.add(participantKeys[0]);
                        messages.add(chatroommodel);
                      }
                    }

                    return fireBaseUuids_to_backendUsers(widget.app_user,
                        messages, uids, widget.bottom_navbar_index);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Center(
                      child: Text("No Conversations Yet!"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("group", isEqualTo: true)
                  .where("participants.${app_user.userUuid}", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatroomsnapshot =
                        snapshot.data as QuerySnapshot;

                    List<ChatRoomModel> chatroom_groups = [];

                    for (int index = 0;
                        index < chatroomsnapshot.docs.length;
                        index = index + 1) {
                      ChatRoomModel chatroommodel = ChatRoomModel.FromMap(
                          chatroomsnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      chatroom_groups.add(chatroommodel);
                    }

                    return Groupmessanger1(widget.app_user, chatroom_groups);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Center(
                      child: Text("No communities formed Yet!"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        backgroundColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              label: "Persons",
              icon: Icon(
                Icons.person_2_outlined,
              )),

          BottomNavigationBarItem(
              label: "Communities",
              icon: Icon(
                Icons.group_add_outlined,
              )), // */
        ],
        currentIndex: widget.bottom_navbar_index,
        onTap: (int index) {
          setState(() {
            widget.bottom_navbar_index = index;
          });
        },
      ),
    );
  }
}

class fireBaseUuids_to_backendUsers extends StatefulWidget {
  Username app_user;
  List<dynamic> user_messages;
  List<String> user_uuids;
  int bottom_navbar_index;
  fireBaseUuids_to_backendUsers(this.app_user, this.user_messages,
      this.user_uuids, this.bottom_navbar_index);

  @override
  State<fireBaseUuids_to_backendUsers> createState() =>
      _fireBaseUuids_to_backendUsersState();
}

class _fireBaseUuids_to_backendUsersState
    extends State<fireBaseUuids_to_backendUsers> {
  List<SmallUsername> message_users = [];
  @override
  Widget build(BuildContext context) {
    return widget.bottom_navbar_index == 0
        ? FutureBuilder<List<SmallUsername>>(
            future: messanger_servers().get_fire_base_uuids_to_backend_users(
                widget.user_uuids.join('#')),
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
                  message_users = snapshot.data;
                  if (message_users.isEmpty) {
                    return Container(
                        margin: EdgeInsets.all(30),
                        padding: EdgeInsets.all(30),
                        child: const Text("No conversations started yet",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24)));
                  } else {
                    return Personmessanger1(
                        widget.app_user, widget.user_messages, message_users);
                  }
                }
              }
              if (message_users.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Personmessanger1(
                  widget.app_user, widget.user_messages, message_users);
            },
          )
        : Container();
  }
}

class Personmessanger1 extends StatefulWidget {
  Username app_user;
  List<dynamic> user_messages;
  List<SmallUsername> message_users;
  Personmessanger1(this.app_user, this.user_messages, this.message_users);

  @override
  State<Personmessanger1> createState() => _Personmessanger1State();
}

class _Personmessanger1State extends State<Personmessanger1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    margin: const EdgeInsets.all(8),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Messages",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ))),
              ]),
              const SizedBox(height: 10),
              ListView.builder(
                  itemCount: widget.message_users.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    SmallUsername message_user = widget.message_users[index];

                    return _buildLoadingScreen(
                        message_user, widget.user_messages[index], index);
                  }),
            ],
          )),
    );
  }

  Widget _buildLoadingScreen(
      SmallUsername message_user, ChatRoomModel user_message, int index) {
    var width = MediaQuery.of(context).size.width;
    var _convertedTimestamp = DateTime.parse(user_message.lastmessagetime
        .toString()); // Converting into [DateTime] object
    String message_posted_date = GetTimeAgo.parse(_convertedTimestamp);

    return GestureDetector(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return chatRoomStream(
              targetuser: message_user,
              chatRoom: user_message,
              app_user: widget.app_user);
        }));
        // }
      },
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(11),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48, //post.profile_pic
                            child: message_user.fileType == '1'
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(message_user.profilePic!))
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
                                          message_user.username!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      userMarkNotation(message_user.starMark!)
                                    ],
                                  ),
                                  Text(
                                    domains[message_user.domain!]! +
                                        " (" +
                                        message_user.userMark! +
                                        ")",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      Text(message_posted_date.substring(0, 6) + '..ago',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Message : "),
                      user_message.lastmessagesender == widget.app_user.email
                          ? user_message.lastmessageseen!
                              ? const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blue,
                                  size: 14,
                                )
                              : const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blueGrey,
                                  size: 14,
                                )
                          : Container(),
                      SizedBox(width: 3),
                      user_message.lastmessagetype == 0
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: width - 120,
                              ),
                              child: Text(
                                user_message.lastmessage!,
                                softWrap: false, maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: user_message.lastmessageseen!
                                    ? TextStyle()
                                    : TextStyle(fontWeight: FontWeight.bold),
                                //post.description,,
                              ),
                            )
                          : user_message.lastmessagetype == 1
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxWidth: width - 120,
                                  ),
                                  child: Text(
                                    user_message.lastmessage! + "(Photo)",
                                    softWrap: false, maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: user_message.lastmessageseen!
                                        ? TextStyle()
                                        : TextStyle(
                                            fontWeight: FontWeight.bold),
                                    //post.description,,
                                  ),
                                )
                              : user_message.lastmessagetype == 2
                                  ? Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width - 120,
                                      ),
                                      child: Text(
                                        user_message.lastmessage! + "(Video)",
                                        softWrap: false, maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: user_message.lastmessageseen!
                                            ? TextStyle()
                                            : TextStyle(
                                                fontWeight: FontWeight.bold),
                                        //post.description,,
                                      ),
                                    )
                                  : Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width - 120,
                                      ),
                                      child: Text(
                                        user_message.lastmessage! + "(PdfFile)",
                                        softWrap: false, maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: user_message.lastmessageseen!
                                            ? TextStyle()
                                            : TextStyle(
                                                fontWeight: FontWeight.bold),
                                        //post.description,,
                                      ),
                                    )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class Groupmessanger1 extends StatefulWidget {
  Username app_user;
  List<ChatRoomModel> groups_chat_rooms;
  Groupmessanger1(this.app_user, this.groups_chat_rooms);

  @override
  State<Groupmessanger1> createState() => _Groupmessanger1State();
}

class _Groupmessanger1State extends State<Groupmessanger1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.groups_chat_rooms.isEmpty
          ? Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(30),
              child: const Text("No conversations started yet",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)))
          : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(8),
                            child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Messages",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ))),
                      ]),
                  const SizedBox(height: 10),
                  ListView.builder(
                      itemCount: widget.groups_chat_rooms.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        ChatRoomModel group_chat_room =
                            widget.groups_chat_rooms[index];

                        return _buildLoadingScreen(group_chat_room, index);
                      }),
                ],
              )),
    );
  }

  Widget _buildLoadingScreen(ChatRoomModel group_chat_room, int index) {
    var width = MediaQuery.of(context).size.width;
    var _convertedTimestamp = DateTime.parse(group_chat_room.lastmessagetime
        .toString()); // Converting into [DateTime] object
    String message_posted_date = GetTimeAgo.parse(_convertedTimestamp);

    return GestureDetector(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GroupChatRoomStream(group_chat_room, widget.app_user);
        }));
      },
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(11),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 48, //post.profile_pic
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      group_chat_room.group_icon!))),
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
                                          group_chat_room.group_name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    domains[widget.app_user.domain!]!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      Text(message_posted_date.substring(0, 6) + '..ago',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Message : "),
                      SizedBox(width: 3),
                      group_chat_room.lastmessagetype == 0
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: width - 120,
                              ),
                              child: Text(
                                group_chat_room.lastmessage!,
                                softWrap: false, maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: group_chat_room.lastmessageseen!
                                    ? TextStyle()
                                    : TextStyle(fontWeight: FontWeight.bold),
                                //post.description,,
                              ),
                            )
                          : group_chat_room.lastmessagetype == 1
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxWidth: width - 120,
                                  ),
                                  child: Text(
                                    group_chat_room.lastmessage! + "(Photo)",
                                    softWrap: false, maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: group_chat_room.lastmessageseen!
                                        ? TextStyle()
                                        : TextStyle(
                                            fontWeight: FontWeight.bold),
                                    //post.description,,
                                  ),
                                )
                              : group_chat_room.lastmessagetype == 2
                                  ? Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width - 120,
                                      ),
                                      child: Text(
                                        group_chat_room.lastmessage! +
                                            "(Video)",
                                        softWrap: false, maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: group_chat_room.lastmessageseen!
                                            ? TextStyle()
                                            : TextStyle(
                                                fontWeight: FontWeight.bold),
                                        //post.description,,
                                      ),
                                    )
                                  : Container(
                                      constraints: BoxConstraints(
                                        maxWidth: width - 120,
                                      ),
                                      child: Text(
                                        group_chat_room.lastmessage! +
                                            "(PdfFile)",
                                        softWrap: false, maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: group_chat_room.lastmessageseen!
                                            ? TextStyle()
                                            : TextStyle(
                                                fontWeight: FontWeight.bold),
                                        //post.description,,
                                      ),
                                    )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
