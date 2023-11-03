import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/Messanger/Servers.dart';
import 'package:testing_app/Messanger/Single_message.dart';
import 'package:testing_app/Messanger/messanger.dart';
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
    return StreamBuilder(
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
                if (all_messages[i].sender != widget.app_user.email &&
                    all_messages[i].seen == false) {
                  all_messages[i].seen = true;
                  FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoom.chatroomid)
                      .collection("messages")
                      .doc(all_messages[i].messageid)
                      .set(all_messages[i].toMap());
                }
              }

              // condition to make last message seen on the messanger page
              if (widget.chatRoom.lastmessagesender != widget.app_user.email) {
                widget.chatRoom.lastmessageseen = true;
                FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomid)
                    .set(widget.chatRoom.toMap());
              }

              return chatroom(
                targetuser: widget.targetuser,
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
        });
    ;
  }
}

class chatroom extends StatefulWidget {
  final SmallUsername targetuser;
  final ChatRoomModel chatRoom;
  final Username app_user;
  List<MessageModel> all_messages;

  chatroom(
      {Key? key,
      required this.targetuser,
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
      FirebaseFirestore.instance
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
    messanger_servers().user_messages_notif(widget.targetuser.email!, msg);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return messanger(app_user);
              }));
            },
          ),
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
          )),
      body: SafeArea(
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
                                return single_message(widget.app_user,
                                    widget.all_messages[index]);
                              },
                            ))),
              Container(
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: const EdgeInsets.only(right: 12),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.60,
                        margin: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: messagecontroller,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                          decoration: const InputDecoration(
                              hintText: 'Message.....',
                              border: InputBorder.none),
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
                                                      source:
                                                          ImageSource.gallery,
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
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      type: FileType.custom,
                                                      allowedExtensions: [
                                                        'pdf'
                                                      ],
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
                                                  child: const Text(
                                                      "Remove file")),
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
                                                              child:
                                                                  AspectRatio(
                                                                aspectRatio:
                                                                    _videoPlayerController!
                                                                        .value
                                                                        .aspectRatio,
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
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
                                                                              _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                                              color: Colors.white,
                                                                              size: 60,
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
                                                                            Colors.redAccent,
                                                                        playedColor:
                                                                            Colors.green,
                                                                        bufferedColor:
                                                                            Colors.purple,
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
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            image: const DecorationImage(image: AssetImage("images/Explorer.png"), fit: BoxFit.cover))),
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
                                            duration:
                                                Duration(milliseconds: 400),
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
      ),
    );
  }
}
