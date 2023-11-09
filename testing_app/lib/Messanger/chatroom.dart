import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/Login/Servers.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';
import 'package:testing_app/User_profile/profile.dart';
import '/Fcm_Notif_Domains/Servers.dart';
import '/Messanger/Servers.dart';
import 'package:testing_app/Messanger/Single_message.dart';
import 'package:testing_app/Messanger/search_bar.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:testing_app/First_page.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:video_player/video_player.dart';
import 'Models.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class chatRoomStream extends StatefulWidget {
  final SmallUsername targetuser;
  final ChatRoomModel chatRoom;
  final Username app_user;

  const chatRoomStream(
      {Key? key,
      required this.targetuser,
      required this.chatRoom,
      required this.app_user})
      : super(key: key);

  @override
  State<chatRoomStream> createState() => _chatRoomStreamState();
}

class _chatRoomStreamState extends State<chatRoomStream> {
  List<MessageModel> all_messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              widget.targetuser.fileType == '1'
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.targetuser.profilePic!))
                  : const CircleAvatar(
                      backgroundImage: AssetImage("images/profile.jpg")),
              const SizedBox(
                width: 20,
              ),
              Text(widget.targetuser.username.toString())
            ],
          ),
          actions: [
            TextButton(
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
                                      "Are you sure do you want to delete this?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.all(30),
                                child: OutlinedButton(
                                    onPressed: () async {
                                      setState(() {
                                        widget.chatRoom.participants![
                                                widget.app_user.userUuid!] =
                                            !widget.chatRoom.participants![
                                                widget.app_user.userUuid!];
                                      });
                                      await FirebaseFirestore.instance
                                          .collection("chatrooms")
                                          .doc(widget.chatRoom.chatroomid)
                                          .set(widget.chatRoom.toMap());
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: widget.chatRoom.participants![
                                                widget.app_user.userUuid!] ==
                                            false
                                        ? const Text(
                                            "Un Block",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )
                                        : const Text(
                                            "Block",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                              )
                            ],
                          ),
                        );
                      });
                },
                child:
                    widget.chatRoom.participants![widget.app_user.userUuid!] ==
                            false
                        ? const Text("Un Block")
                        : const Text("Block"))
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(widget.chatRoom.chatroomid)
                .collection("messages")
                .orderBy("createdon", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                  all_messages = [];

                  /// loop to get all chat room messages
                  for (int i = 0; i < datasnapshot.docs.length; i++) {
                    MessageModel currentmessage = MessageModel.FromMap(
                        datasnapshot.docs[i].data() as Map<String, dynamic>);
                    all_messages.add(currentmessage);
                  }

                  //loop to make messages seen when chat room was opened
                  for (int i = 0; i < all_messages.length; i++) {
                    if (all_messages[i].sender != widget.app_user.email) {
                      if (all_messages[i].seen == false) {
                        all_messages[i].seen = true;
                        FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(widget.chatRoom.chatroomid)
                            .collection("messages")
                            .doc(all_messages[i].messageid)
                            .set(all_messages[i].toMap());
                      } else {
                        break;
                      }
                    }
                  }

                  // condition to make last message seen on the messanger page
                  if (widget.chatRoom.lastmessagesender !=
                      widget.app_user.email) {
                    widget.chatRoom.lastmessageseen = true;
                    FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatRoom.chatroomid)
                        .set(widget.chatRoom.toMap());
                  }

                  return chatroom(
                    targetuser_uuids: [widget.targetuser.userUuid!],
                    chatRoom: widget.chatRoom,
                    app_user: widget.app_user,
                    all_messages: widget
                            .chatRoom.participants![widget.app_user.userUuid!]!
                        ? all_messages
                        : [],
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                      "An error occured please check your internet connection");
                } else {
                  return const Text("Send a Hi to your beloved friend");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class GroupChatRoomStream extends StatefulWidget {
  ChatRoomModel chatRoom;
  Username app_user;
  GroupChatRoomStream(this.chatRoom, this.app_user);

  @override
  State<GroupChatRoomStream> createState() => _GroupChatRoomStreamState();
}

class _GroupChatRoomStreamState extends State<GroupChatRoomStream> {
  List<MessageModel> all_messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return groupUsersDisplay(widget.chatRoom, widget.app_user);
              }));
            },
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(widget.chatRoom.group_icon!)),
                const SizedBox(
                  width: 20,
                ),
                Text(widget.chatRoom.group_name.toString())
              ],
            ),
          ),
          actions: [
            widget.chatRoom.group_creator == widget.app_user.email
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return search_bar(
                            widget.app_user,
                            domains[widget.app_user.domain]!,
                            'edit_group',
                            widget.chatRoom);
                      }));
                    },
                    child: Text("Edit Group"))
                : TextButton(
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
                                          "Are you sure do you want to Exit group?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          setState(() {
                                            widget.chatRoom.participants!
                                                .remove(
                                                    widget.app_user.userUuid);
                                          });
                                          await FirebaseFirestore.instance
                                              .collection("chatrooms")
                                              .doc(widget.chatRoom.chatroomid)
                                              .set(widget.chatRoom.toMap());
                                          Navigator.of(context);
                                          Navigator.of(context);
                                        },
                                        child: const Center(
                                            child: Text(
                                          "Exit",
                                          style: TextStyle(color: Colors.blue),
                                        ))),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Text("Exit Group"))
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(widget.chatRoom.chatroomid)
                .collection("messages")
                .orderBy("createdon", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                  all_messages = [];

                  /// loop to get all chat room messages
                  for (int i = 0; i < datasnapshot.docs.length; i++) {
                    MessageModel currentmessage = MessageModel.FromMap(
                        datasnapshot.docs[i].data() as Map<String, dynamic>);
                    all_messages.add(currentmessage);
                  }

                  return chatroom(
                    targetuser_uuids:
                        widget.chatRoom.participants!.keys.toList(),
                    chatRoom: widget.chatRoom,
                    app_user: widget.app_user,
                    all_messages: all_messages,
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                      "An error occured please check your internet connection");
                } else {
                  return const Text("Send a Hi to your beloved friend");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class chatroom extends StatefulWidget {
  final List<String> targetuser_uuids;
  final ChatRoomModel chatRoom;
  final Username app_user;
  List<MessageModel> all_messages;
  chatroom(
      {Key? key,
      required this.targetuser_uuids,
      required this.chatRoom,
      required this.app_user,
      required this.all_messages})
      : super(key: key);

  @override
  _chatroomState createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  TextEditingController messagecontroller = TextEditingController();
  bool _showController = true;
  VideoPlayerController? _videoPlayerController;

  loadVideoPlayer(File file) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.file(file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  File? imagefile;
  int file_type = 0;

  void sendMessage() async {
    if (!widget.chatRoom.participants!.values.elementAt(0) ||
        !widget.chatRoom.participants!.values.elementAt(1)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 400),
          content: Text("You cannot send message to this user..",
              style: TextStyle(color: Colors.white))));
    } else {
      String msg = messagecontroller.text.trim();
      messagecontroller.clear();
      int type = file_type;
      setState(() {
        file_type = 0;
      });
      if (imagefile != null) {
        File temp_img_file = imagefile!;
        setState(() {
          imagefile = null;
        });
        MessageModel newmessage = MessageModel(
            messageid: uuid.v1(),
            seen: false,
            createdon: DateTime.now(),
            sender: app_user.email,
            text: msg,
            photo: '',
            type: type,
            sent: false,
            offline_file: temp_img_file,
            insert: true);
        setState(() {
          widget.all_messages.insert(0, newmessage);
        });
        String uid = uuid.v1();
        UploadTask uploadtask = FirebaseStorage.instance
            .ref("photo_messages")
            .child(uid.toString())
            .putFile(temp_img_file);
        TaskSnapshot snapshot = await uploadtask;
        String imageurl = await snapshot.ref.getDownloadURL();
        setState(() {
          newmessage.photo = imageurl;
        });
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoom.chatroomid)
            .collection("messages")
            .doc(newmessage.messageid)
            .set(newmessage.toMap());
        widget.chatRoom.lastmessage = msg;
        widget.chatRoom.lastmessagetype = type;
        widget.chatRoom.lastmessageseen = false;
        widget.chatRoom.lastmessagetime = DateTime.now();
        widget.chatRoom.lastmessagesender = app_user.email;
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());
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
          widget.chatRoom.lastmessagetype = type;
          widget.chatRoom.lastmessageseen = false;
          widget.chatRoom.lastmessagetime = DateTime.now();
          widget.chatRoom.lastmessagesender = app_user.email;
          FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(widget.chatRoom.chatroomid)
              .set(widget.chatRoom.toMap());
        }
      }

      if (widget.targetuser_uuids.length == 1) {
        messanger_servers()
            .user_messages_notif(widget.targetuser_uuids.join("#"), msg);
      } else {
        messanger_servers().user_messages_notif(
            widget.targetuser_uuids.join("#"),
            msg + " : From " + widget.chatRoom.group_name!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: widget.all_messages.isEmpty
                        ? Container(
                            child: const Center(
                                child: Text("No conversation started yet.")),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: widget.all_messages.length,
                            itemBuilder: (context, index) {
                              bool groupChatroom =
                                  widget.targetuser_uuids.length == 1
                                      ? false
                                      : true;
                              return single_message(widget.app_user,
                                  widget.all_messages[index], groupChatroom);
                            },
                          ))),
            Container(
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                padding: const EdgeInsets.only(right: 12),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      width: width * 0.55,
                      margin: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: messagecontroller,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            hintText: 'Message.....', border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'please enter email' : null;
                        },
                      ),
                    ),
                    const SizedBox(width: 1),
                    IconButton(
                      onPressed: () async {
                        if (imagefile == null) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.all(15),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 20),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final XFile? image1 =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 35);
                                                  //final bytes = await File(image1!.path).readAsBytes();
                                                  setState(() {
                                                    imagefile =
                                                        File(image1!.path);
                                                    file_type = 1;
                                                    //final img.Image image = img.decodeImage(bytes)!;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons
                                                        .photo_library_outlined,
                                                    size: 20)),
                                            IconButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final image1 =
                                                      await _picker.pickVideo(
                                                    source: ImageSource.gallery,
                                                  );
                                                  //final bytes = await File(image1!.path).readAsBytes();
                                                  setState(() {
                                                    imagefile =
                                                        File(image1!.path);
                                                    file_type = 2;
                                                    //final img.Image image = img.decodeImage(bytes)!;
                                                  });
                                                  loadVideoPlayer(imagefile!);
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .video_collection_outlined,
                                                  size: 20,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: ['pdf'],
                                                  );

                                                  setState(() {
                                                    imagefile = File(
                                                        result!.paths.first ??
                                                            '');
                                                    file_type = 3;
                                                    //final img.Image image = img.decodeImage(bytes)!;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.file_copy_sharp,
                                                    size: 20)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        if (imagefile != null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    imagefile = null;
                                                  });
                                                },
                                                child:
                                                    const Text("Remove file")),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                    Icons.close_outlined))
                                          ],
                                        ),
                                        imagefile != null
                                            ? Container(
                                                //height: width * 1.4, // image_ratio,
                                                //width: width,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: file_type == 1
                                                    ? Image.file(imagefile!)
                                                    : file_type == 2
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _showController =
                                                                    !_showController;
                                                              });
                                                            },
                                                            child: AspectRatio(
                                                              aspectRatio:
                                                                  _videoPlayerController!
                                                                      .value
                                                                      .aspectRatio,
                                                              child: Stack(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                children: <Widget>[
                                                                  VideoPlayer(
                                                                      _videoPlayerController!),
                                                                  const ClosedCaption(
                                                                      text:
                                                                          null),
                                                                  _showController ==
                                                                          true
                                                                      ? Center(
                                                                          child:
                                                                              InkWell(
                                                                          child:
                                                                              Icon(
                                                                            _videoPlayerController!.value.isPlaying
                                                                                ? Icons.pause
                                                                                : Icons.play_arrow,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                60,
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              _videoPlayerController!.value.isPlaying ? _videoPlayerController!.pause() : _videoPlayerController!.play();
                                                                              _showController = !_showController;
                                                                            });
                                                                          },
                                                                        ))
                                                                      : Container(),
                                                                  // Here you can also add Overlay capacities
                                                                  VideoProgressIndicator(
                                                                    _videoPlayerController!,
                                                                    allowScrubbing:
                                                                        true,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                    colors:
                                                                        const VideoProgressColors(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .redAccent,
                                                                      playedColor:
                                                                          Colors
                                                                              .green,
                                                                      bufferedColor:
                                                                          Colors
                                                                              .purple,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : file_type == 3
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                    return pdfviewer(
                                                                        imagefile!);
                                                                  }));
                                                                },
                                                                child: Center(
                                                                  child: Container(
                                                                      height: width *
                                                                          (0.7),
                                                                      width:
                                                                          width,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              8),
                                                                          image: const DecorationImage(
                                                                              image: AssetImage("images/Explorer.png"),
                                                                              fit: BoxFit.cover))),
                                                                ))
                                                            : Container())
                                            : Container(),
                                        const SizedBox(height: 30)
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      icon: imagefile == null
                          ? const Icon(
                              Icons.camera_alt_outlined,
                              size: 30,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                              size: 30,
                            ),
                    ),
                    const SizedBox(width: 1),
                    (messagecontroller.text.trim() != "" || imagefile != null)
                        ? Container(
                            child: IconButton(
                              onPressed: () async {
                                if (widget.app_user.email ==
                                    "guest@nitc.ac.in") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(milliseconds: 400),
                                          content: Text(
                                              "guest cannot chat with others..",
                                              style: TextStyle(
                                                  color: Colors.white))));
                                } else {
                                  sendMessage();
                                }
                              },
                              icon: const Icon(Icons.double_arrow,
                                  size: 40, color: Colors.blue),
                            ),
                          )
                        : Container(
                            child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.keyboard_double_arrow_right,
                              size: 35,
                              color: Colors.white,
                            ),
                          ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class groupUsersDisplay extends StatefulWidget {
  ChatRoomModel group_chat_room;
  Username app_user;
  groupUsersDisplay(this.group_chat_room, this.app_user);

  @override
  State<groupUsersDisplay> createState() => _groupUsersDisplayState();
}

class _groupUsersDisplayState extends State<groupUsersDisplay> {
  List<SmallUsername> group_users = [];

  @override
  Widget build(BuildContext context) {
    List<String> user_uuids =
        widget.group_chat_room.participants!.keys.toList();
    return Scaffold(
      appBar: AppBar(title: Text("Group_Users")),
      body: FutureBuilder<List<SmallUsername>>(
        future: messanger_servers()
            .get_fire_base_uuids_to_backend_users(user_uuids.join('#')),
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
              group_users = snapshot.data;
              if (group_users.isEmpty) {
                return Container(
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    child: const Text("No conversations started yet",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24)));
              } else {
                return ListView.builder(
                    itemCount: group_users.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      SmallUsername group_user = group_users[index];
                      return _buildLoadingScreen(group_user, index);
                    });
              }
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLoadingScreen(SmallUsername search_user, int index) {
    var width = MediaQuery.of(context).size.width;
    return Container(
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
                                        Text("Please wait while loading....."),
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
                        width: (width - 36) / 1.4,
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
                                  userMarkNotation(search_user.starMark!),
                                  const SizedBox(width: 6),
                                  widget.group_chat_room.group_creator ==
                                          search_user.email
                                      ? const Text(
                                          "(GroupAdmin)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        )
                                      : Container()
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
        ));
  }
}
