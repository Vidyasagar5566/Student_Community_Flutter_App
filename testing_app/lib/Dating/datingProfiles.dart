import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_time_ago/get_time_ago.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import '/First_page.dart';
import '/Dating/dummyChat.dart';
import '/Dating/models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';
import '/Dating/servers.dart';
import '/Messanger/Models.dart';

import '/User_profile/Models.dart';
import 'package:flutter/material.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class datingProfiles extends StatefulWidget {
  Username app_user;
  datingProfiles(this.app_user);

  @override
  State<datingProfiles> createState() => _datingProfilesState();
}

class _datingProfilesState extends State<datingProfiles> {
  List<String> uids = [];
  List<ChatRoomModel> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(
          widget.app_user.username!,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          widget.app_user.dating_profile!
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(15),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        "Do you want to Delete this Profile?",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(height: 10),
                                const Center(
                                    child: Text(
                                        "This will erase all tracking's till now including chattings and reactions and you can start with new profile,",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))),
                                Container(
                                  margin: const EdgeInsets.all(30),
                                  child: OutlinedButton(
                                      onPressed: () async {
                                        dating_servers().delete_dating_user();
                                        delete_firebase_chatrooms();
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return get_ueser_widget(0);
                                        }), (Route<dynamic> route) => false);
                                      },
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.auto_delete_outlined,
                    color: Colors.blue,
                  ))
              : Container()
        ],
        backgroundColor: Colors.white70,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("dummyChatrooms")
              // .orderBy("lastmessagetime", descending: true)
              .where("group", isEqualTo: false)
              .where("participants.${widget.app_user.userUuid}",
                  isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatroomsnapshot = snapshot.data as QuerySnapshot;

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
                  participantKeys.remove(widget.app_user.userUuid);

                  if (chatroommodel.lastmessage != "" ||
                      chatroommodel.lastmessagetype! > 0) {
                    uids.add(participantKeys[0]);
                    messages.add(chatroommodel);
                  }
                }

                return fireBaseUuids_to_backendDatingUsers(
                    widget.app_user, messages, uids);
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
          }),
    );
  }

  Future delete_firebase_chatrooms() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("dummyChatrooms")
        .where("group", isEqualTo: false)
        .where("participants.${widget.app_user.userUuid}", isEqualTo: true)
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      var docData = snapshot.docs[i].data();
      ChatRoomModel existingchatroom =
          ChatRoomModel.FromMap(docData as Map<String, dynamic>);
      await FirebaseFirestore.instance
          .collection("dummyChatrooms")
          .doc(existingchatroom.chatroomid)
          .delete();
    }
  }
}

class fireBaseUuids_to_backendDatingUsers extends StatefulWidget {
  Username app_user;
  List<ChatRoomModel> user_messages;
  List<String> user_uuids;
  fireBaseUuids_to_backendDatingUsers(
      this.app_user, this.user_messages, this.user_uuids);

  @override
  State<fireBaseUuids_to_backendDatingUsers> createState() =>
      _fireBaseUuids_to_backendDatingUsersState();
}

class _fireBaseUuids_to_backendDatingUsersState
    extends State<fireBaseUuids_to_backendDatingUsers> {
  List<DatingUser> dating_users = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DatingUser>>(
      future: dating_servers()
          .get_uuids_to_dating_user_profiles(widget.user_uuids.join('#')),
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
            dating_users = snapshot.data;
            if (dating_users.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Text("No conversations started yet",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 24)));
            } else {
              return Personmessanger1(
                  widget.app_user, widget.user_messages, dating_users);
            }
          }
        }
        if (dating_users.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Personmessanger1(
            widget.app_user, widget.user_messages, dating_users);
      },
    );
  }
}

class Personmessanger1 extends StatefulWidget {
  Username app_user;
  List<ChatRoomModel> user_messages;
  List<DatingUser> dating_users;
  Personmessanger1(this.app_user, this.user_messages, this.dating_users);

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
                          "Messages(may not to be true identities)",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ))),
              ]),
              const SizedBox(height: 10),
              ListView.builder(
                  itemCount: widget.dating_users.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    DatingUser dating_user = widget.dating_users[index];

                    return _buildLoadingScreen(
                        dating_user, widget.user_messages[index], index);
                  }),
            ],
          )),
    );
  }

  Widget _buildLoadingScreen(
      DatingUser dating_user, ChatRoomModel user_message, int index) {
    var width = MediaQuery.of(context).size.width;
    var _convertedTimestamp = DateTime.parse(user_message.lastmessagetime
        .toString()); // Converting into [DateTime] object
    String message_posted_date = GetTimeAgo.parse(_convertedTimestamp);

    return GestureDetector(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DummychatRoomStream(
              dating_user: dating_user,
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
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return image_display(
                                        false,
                                        File('images/icon.png'),
                                        dating_user.dummyProfile!);
                                  }));
                                },
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        dating_user.dummyProfile!)),
                              )),
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
                                          dating_user.dummyName!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                  Text(
                                    domains[dating_user.dummyDomain!]!,
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
                  Text(utf8convert(dating_user.dummyBio!)),
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
