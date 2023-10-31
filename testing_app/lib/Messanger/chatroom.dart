import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/First_page.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'Models.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class chatroom extends StatefulWidget {
  final SmallUsername targetuser;
  final ChatRoomModel chatRoom;

  const chatroom({
    Key? key,
    required this.targetuser,
    required this.chatRoom,
  }) : super(key: key);

  @override
  _chatroomState createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  TextEditingController messagecontroller = TextEditingController();

  void sendMessage() async {
    String msg = messagecontroller.text.trim();
    messagecontroller.clear();
    if (msg != "") {
      MessageModel newmessage = MessageModel(
          messageid: uuid.v1(),
          seen: false,
          createdon: DateTime.now(),
          sender: app_user.email,
          text: msg);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .collection("messages")
          .doc(newmessage.messageid)
          .set(newmessage.toMap());
      widget.chatRoom.lastmessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage(widget.targetuser.profilePic.toString()),
          ),
          SizedBox(
            width: 20,
          ),
          Text(widget.targetuser.username.toString())
        ],
      )),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoom.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot datasnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: datasnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentmessage = MessageModel.FromMap(
                                datasnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                                mainAxisAlignment:
                                    (currentmessage.sender == app_user.email)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: (currentmessage.sender ==
                                                  app_user.email)
                                              ? Colors.blue
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        currentmessage.text.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ]);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            "An error occured please check your internet connection");
                      } else {
                        return Text("Send a Hi to your beloved friend");
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                color: Colors.grey.shade200,
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      maxLines: null,
                      controller: messagecontroller,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter Message"),
                    )),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(Icons.send))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
