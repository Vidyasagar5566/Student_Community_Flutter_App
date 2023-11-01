import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  File? imagefile;

  void sendMessage() async {
    String msg = messagecontroller.text.trim();
    int type = 0;
    if (imagefile != null) {
      type = 1;
    }
    messagecontroller.clear();
    if (imagefile != null) {
      String uid=uuid.v1();
      UploadTask uploadtask = FirebaseStorage.instance
          .ref("photo_messages")
          .child(uid.toString())
          .putFile(imagefile!);
      TaskSnapshot snapshot = await uploadtask;
      String imageurl = await snapshot.ref.getDownloadURL();
      MessageModel newmessage = MessageModel(
          messageid: uuid.v1(),
          seen: false,
          createdon: DateTime.now(),
          sender: app_user.email,
          text: msg,
          photo: imageurl,
          type: 1);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .collection("messages")
          .doc(newmessage.messageid)
          .set(newmessage.toMap());
    } else {
      if (msg != "") {
        MessageModel newmessage = MessageModel(
            messageid: uuid.v1(),
            seen: false,
            createdon: DateTime.now(),
            sender: app_user.email,
            text: msg,
            photo: "",
            type: 0);
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
  }

  void ShowPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Pic"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    SelectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    SelectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                ),
              ],
            ),
          );
        });
  }

  void SelectImage(ImageSource source) async {
    XFile? pickedfile = await ImagePicker().pickImage(source: source);
    if (pickedfile != null) {
      CropImage(pickedfile);
    }
  }

  void CropImage(XFile file) async {
    CroppedFile? croppedimage = await ImageCropper()
        .cropImage(sourcePath: file.path, compressQuality: 20);

    if (croppedimage != null) {
      File? newfile = File(croppedimage.path);
      setState(() {
        imagefile = newfile;
      });
    }
    sendImage();
  }

  void sendImage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
            children: [
              Expanded(child: Image.file(File(imagefile!.path))),
              CupertinoButton(
                  child: Text("send"),
                  onPressed: () {
                    sendMessage();
                    Navigator.pop(context);
                  })
            ],
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          widget.targetuser.fileType == '1'
              ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.targetuser.profilePic!))
              : const CircleAvatar(
                  backgroundImage: AssetImage("images/profile.jpg")),
          const SizedBox(
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
                            if (currentmessage.type == 0) {
                              return Row(
                                  mainAxisAlignment:
                                      (currentmessage.sender == app_user.email)
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
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
                            } else if (currentmessage.type == 1) {
                              return Row(
                                  mainAxisAlignment:
                                      (currentmessage.sender == app_user.email)
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: (currentmessage.sender ==
                                                    app_user.email)
                                                ? Colors.blue
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child:  Stack(children:[
                                        Image.network(
                                          currentmessage.photo.toString(),
                                          loadingBuilder: (context,child,loadingProgress){
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                          fit: BoxFit.fitHeight,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *0.3,
                                          width: MediaQuery.sizeOf(context)
                                                  .width *0.7,
                                        )]))
                                  ]);
                            }
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
                          border: InputBorder.none, hintText: "Message"),
                    )),
                    IconButton(
                        onPressed: () {
                          ShowPhotoOptions();
                          if (imagefile != null) {
                            Column(
                              children: [
                                Expanded(
                                    child: Image.file(File(imagefile!.path))),
                                CupertinoButton(
                                    child: Text("send"),
                                    onPressed: () {
                                      sendMessage();
                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          }
                        },
                        icon: Icon(Icons.camera_alt)),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(Icons.send)),
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
