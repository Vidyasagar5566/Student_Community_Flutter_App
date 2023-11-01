import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/First_page.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:video_player/video_player.dart';
import 'Models.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class chatroom extends StatefulWidget {
  final SmallUsername targetuser;
  final ChatRoomModel chatRoom;
  final Username app_user;

  const chatroom(
      {Key? key,
      required this.targetuser,
      required this.chatRoom,
      required this.app_user})
      : super(key: key);

  @override
  _chatroomState createState() => _chatroomState();
}

class _chatroomState extends State<chatroom> {
  TextEditingController messagecontroller = TextEditingController();
  var image;
  String message_file_type = '0';
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

  void sendMessage() async {
    String msg = messagecontroller.text.trim();
    int type = 0;
    if (imagefile != null) {
      type = 1;
    }
    messagecontroller.clear();
    if (imagefile != null) {
      String uid = uuid.v1();
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
    var width = MediaQuery.of(context).size.width;
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
                                        child: Stack(children: [
                                          Image.network(
                                            currentmessage.photo.toString(),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            fit: BoxFit.fitHeight,
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.3,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.7,
                                          )
                                        ]))
                                  ]);
                            }
                          },
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
                  },
                ),
              )),
              Container(
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  padding: const EdgeInsets.only(right: 12),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.60,
                        child: TextFormField(
                          controller: messagecontroller,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'message',
                              hintText: 'typing.....',
                              prefixIcon:
                                  Icon(Icons.text_fields, color: Colors.white),
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              value = messagecontroller.text.trim();
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'please enter email' : null;
                          },
                        ),
                      ),
                      const SizedBox(width: 1),
                      IconButton(
                        onPressed: () async {
                          if (image == null) {
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
                                                      image =
                                                          File(image1!.path);
                                                      message_file_type = "1";
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
                                                      image =
                                                          File(image1!.path);
                                                      message_file_type = "2";
                                                      //final img.Image image = img.decodeImage(bytes)!;
                                                    });
                                                    loadVideoPlayer(image);
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
                                                      image = File(
                                                          result!.paths.first ??
                                                              '');
                                                      message_file_type = "3";
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
                          if (image != null) {
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
                                                      image = null;
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
                                          image != null
                                              ? Container(
                                                  //height: width * 1.4, // image_ratio,
                                                  //width: width,
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: message_file_type ==
                                                          "1"
                                                      ? Image.file(image)
                                                      : message_file_type == "2"
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
                                                          : message_file_type ==
                                                                  "3"
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(builder:
                                                                            (BuildContext
                                                                                context) {
                                                                      return pdfviewer(
                                                                          image);
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
                        icon: image == null
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
                      (messagecontroller.text.trim() != "" || image != null)
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
