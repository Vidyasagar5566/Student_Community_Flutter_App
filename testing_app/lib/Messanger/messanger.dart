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
  messanger(this.app_user);

  @override
  State<messanger> createState() => _messangerState();
}

class _messangerState extends State<messanger> {
  List<String> uids = [];
  List<List<dynamic>> messages = [];
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
            Container(
              padding: const EdgeInsets.only(top: 8, right: 8),
              margin: const EdgeInsets.only(top: 8, right: 8),
              child: Stack(children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return search_bar(
                          widget.app_user, domains[widget.app_user.domain]!);
                    }));
                  },
                  icon: const Icon(Icons.person_search_outlined, size: 25),
                ),
              ]),
            )
          ],
          backgroundColor: Colors.white70,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
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
                      messages.add([
                        chatroommodel.lastmessage!,
                        chatroommodel.lastmessagetype!,
                        chatroommodel.lastmessageseen!,
                        chatroommodel.lastmessagetime!,
                        chatroommodel.lastmessagesender!
                      ]);
                    }
                  }
                  return messageIdsToMessages(
                      widget.app_user, messages, uids, chatroomids);
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
            }));
  }
}

class messageIdsToMessages extends StatefulWidget {
  Username app_user;
  List<String> messages;
  List<String> uids;
  List<String> chatroomids;
  messageIdsToMessages(
      this.app_user, this.messages, this.uids, this.chatroomids);

  @override
  State<messageIdsToMessages> createState() => _messageIdsToMessagesState();
}

class _messageIdsToMessagesState extends State<messageIdsToMessages> {
  bool loaded_messages = false;
  List<MessageModel> last_user_messages = [];
  Future fetchmodelbyid() async {
    for (int i = 0; i < widget.messages.length; i++) {
      String? chatroomid = widget.chatroomids[i];
      String? lastmessageid = widget.messages[i];
      CollectionReference messagecollection = await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomid)
          .collection('messages');
      QuerySnapshot messagessnapshot = await messagecollection
          .where("messageid", isEqualTo: lastmessageid)
          .get();
      Map<String, dynamic> usermap =
          messagessnapshot.docs[0].data() as Map<String, dynamic>;
      MessageModel lastmessagemodel = MessageModel.FromMap(usermap);
      last_user_messages.add(lastmessagemodel);
    }
    setState(() {
      loaded_messages = true;
    });
  }

  void initState() {
    super.initState();
    fetchmodelbyid();
  }

  @override
  Widget build(BuildContext context) {
    return loaded_messages
        ? fireBaseUuids_to_backendUsers(
            widget.app_user, last_user_messages, widget.uids)
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class fireBaseUuids_to_backendUsers extends StatefulWidget {
  Username app_user;
  List<List<dynamic>> user_messages;
  List<String> user_uuids;

  fireBaseUuids_to_backendUsers(
      this.app_user, this.last_user_messages, this.user_uuids);

  @override
  State<fireBaseUuids_to_backendUsers> createState() =>
      _fireBaseUuids_to_backendUsersState();
}

class _fireBaseUuids_to_backendUsersState
    extends State<fireBaseUuids_to_backendUsers> {
  List<SmallUsername> message_users = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SmallUsername>>(
      future: messanger_servers()
          .get_fire_base_uuids_to_backend_users(widget.user_uuids.join('#')),
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
              return messanger1(
                  widget.app_user, widget.last_user_messages, message_users);
            }
          }
        }
        if (message_users.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return messanger1(widget.app_user, widget.user_messages, message_users);
      },
    );
  }
}

class messanger1 extends StatefulWidget {
  Username app_user;
  List<List<dynamic>> user_messages;
  List<SmallUsername> message_users;

  messanger1(this.app_user, this.last_user_message, this.message_users);

  @override
  State<messanger1> createState() => _messanger1State();
}

class _messanger1State extends State<messanger1> {
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
                        message_user, widget.last_user_message[index], index);
                  }),
            ],
          )),
    );
  }

  Future<ChatRoomModel?> getChatRoomModel(SmallUsername targetuser) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.app_user.userUuid}", isEqualTo: true)
        .where("participants.${targetuser.userUuid}", isEqualTo: true)
        .get();
    var docData = snapshot.docs[0].data();
    ChatRoomModel? existingchatroom =
        ChatRoomModel.FromMap(docData as Map<String, dynamic>);

    return existingchatroom;
  }

  Widget _buildLoadingScreen(
      SmallUsername message_user, List<dynamic> user_message, int index) {
    var width = MediaQuery.of(context).size.width;
    var _convertedTimestamp = DateTime.parse(
        user_message[3].toString()); // Converting into [DateTime] object
    String message_posted_date = GetTimeAgo.parse(_convertedTimestamp);

    return GestureDetector(
      onTap: () async {
        ChatRoomModel? chatroomModel = await getChatRoomModel(message_user);
        if (chatroomModel != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return chatRoomStream(
                targetuser: message_user,
                chatRoom: chatroomModel,
                app_user: widget.app_user);
          }));
        }
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
                      user_message[4] == widget.app_user.email
                          ? user_message[2]
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
                      user_message[1] == 0
                          ? Text(
                              user_message[0],
                              softWrap: false, maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: user_message[2]
                                  ? TextStyle()
                                  : TextStyle(fontWeight: FontWeight.bold),
                              //post.description,,
                            )
                          : user_message[1] == 1
                              ? Text(
                                  user_message[0] + "(Photo)",
                                  softWrap: false, maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: user_message[2]
                                      ? TextStyle()
                                      : TextStyle(fontWeight: FontWeight.bold),
                                  //post.description,,
                                )
                              : user_message[1] == 2
                                  ? Text(
                                      user_message[0] + "(Video)",
                                      softWrap: false, maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: user_message[2]
                                          ? TextStyle()
                                          : TextStyle(
                                              fontWeight: FontWeight.bold),
                                      //post.description,,
                                    )
                                  : Text(
                                      user_message[0] + "(PdfFile)",
                                      softWrap: false, maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: user_message[2]
                                          ? TextStyle()
                                          : TextStyle(
                                              fontWeight: FontWeight.bold),
                                      //post.description,,
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
