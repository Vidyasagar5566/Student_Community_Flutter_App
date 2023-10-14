import 'package:flutter/material.dart';
import '/servers/servers.dart';
import '/models/models.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import 'search_bar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
        body: FutureBuilder<List<List<Messanger>>>(
          future: servers().get_messages_list("load"),
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
                List<List<Messanger>> users_induvidual_messages_lists =
                    snapshot.data;
                if (users_induvidual_messages_lists.isEmpty) {
                  return Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(30),
                      child: const Text("No conversations started yet",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 24)));
                } else {
                  return messanger1(
                      widget.app_user, users_induvidual_messages_lists);
                }
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class messanger1 extends StatefulWidget {
  Username app_user;
  List<List<Messanger>> users_induvidual_messages_lists;
  messanger1(this.app_user, this.users_induvidual_messages_lists);

  @override
  State<messanger1> createState() => _messanger1State();
}

class _messanger1State extends State<messanger1> {
  bool periodic = false;
  void repeat() {
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      String lens = widget.users_induvidual_messages_lists[0].length.toString();
      for (int i = 1; i < widget.users_induvidual_messages_lists.length; i++) {
        lens = lens +
            ',' +
            widget.users_induvidual_messages_lists[i].length.toString();
      }
      List<List<Messanger>> a = await servers().get_messages_list(lens);
      if (a.length != 0) {
        setState(() {
          periodic = true;
          widget.users_induvidual_messages_lists = a;
        });
      }
    });
  }

  void initState() {
    super.initState();
    repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          color: Colors.white,
          //height: MediaQuery.of(context).size.height,
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
                  itemCount: widget.users_induvidual_messages_lists.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var message_user;
                    Messanger message =
                        widget.users_induvidual_messages_lists[index].last;
                    if (widget.app_user.email ==
                        message.messageReceiver!.email) {
                      message_user = message.messageSender!;
                    } else {
                      message_user = message.messageReceiver!;
                    }
                    return _buildLoadingScreen(message_user, message,
                        widget.users_induvidual_messages_lists[index], index);
                  }),
            ],
          )),
    );
  }

  Widget _buildLoadingScreen(SmallUsername message_user, Messanger message,
      List<Messanger> user_conversation, int index) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return messages_viewer(
              widget.app_user, message_user, user_conversation);
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
                              width: 65,
                              child: message_user.fileType! == '1'
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          //post.profile_pic
                                          NetworkImage(
                                              message_user.profilePic!))
                                  : const CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          //post.profile_pic
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
                                          message_user.username!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          //"Vidya Sagar",
                                          //lst_list[index].username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            //color: Colors.white
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      index % 9 == 0
                                          ? const Icon(
                                              Icons
                                                  .verified_rounded, //verified_rounded,verified_outlined
                                              color: Colors.green,
                                              size: 18,
                                            )
                                          : Container()
                                    ],
                                  ),
                                  Text(
                                    //"B190838EC",
                                    domains[message_user.domain!]! +
                                        " (" +
                                        message_user.userMark! +
                                        ")",
                                    overflow: TextOverflow.ellipsis,
                                    //lst_list.username.rollNum,
                                    //style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                  )
                                ]),
                          )
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  message.messageSeen!
                      ? Text(
                          "message : " + utf8convert(message.messageBody!),
                          softWrap: false, maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          //post.description,,
                        )
                      : Text(
                          "message : " + utf8convert(message.messageBody!),
                          softWrap: false, maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          //post.description,,
                        )
                ],
              )),
        ],
      ),
    );
  }
}

class messages_viewer extends StatefulWidget {
  Username app_user;
  SmallUsername message_user;
  List<Messanger> user_messages;
  messages_viewer(this.app_user, this.message_user, this.user_messages);

  @override
  State<messages_viewer> createState() => _messages_viewerState();
}

class _messages_viewerState extends State<messages_viewer> {
  var new_message;
  var image;
  var circular_ind;
  String message_file_type = "0";
  String image_vedio = "";
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

  void repeat() {
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      int msgs_len = widget.user_messages.length;
      List<Messanger> a = await servers().user_user_messages(
          widget.message_user.email!,
          msgs_len.toString(),
          widget.user_messages[msgs_len - 1].messageSeen!);
      if (a.length != 0) {
        setState(() async {
          widget.user_messages = a;
        });
      }
    });
  }

  void initState() {
    super.initState();
    repeat();
  }

  bool sending_msg = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            widget.message_user.username!,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                        itemCount: widget.user_messages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          Messanger message = widget.user_messages[index];
                          return single_message(message, widget.app_user,
                              widget.message_user, sending_msg);
                        })),
              ),
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
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          minLines: 1, //Normal textInputField will be displayed
                          maxLines: 2,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'message',
                              hintText: 'typing.....',
                              prefixIcon:
                                  Icon(Icons.text_fields, color: Colors.white),
                              border: InputBorder.none),
                          onChanged: (String value) {
                            new_message = value;
                            setState(() {
                              new_message = value;
                              if (new_message == "") {
                                new_message = null;
                              }
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
                                                      image_vedio = "image";
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
                                                      image_vedio = "vedio";
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
                                                      image_vedio = "pdf";
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
                                                  child: image_vedio == "image"
                                                      ? Image.file(image)
                                                      : image_vedio == "vedio"
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
                                                          : image_vedio == "pdf"
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
                      (new_message != null || image != null)
                          ? Container(
                              child: IconButton(
                                onPressed: () async {
                                  SmallUsername app_user1 =
                                      user_min(widget.app_user);
                                  //message insertion
                                  Messanger add_message = Messanger();
                                  String curr_message = "";
                                  curr_message = new_message;
                                  if (new_message == null) {
                                    add_message.messageBody = " ";
                                  } else {
                                    add_message.messageBody = curr_message;
                                  }

                                  File curr_file = File('images/profile.jpg');
                                  if (image == null) {
                                    add_message.file = curr_file;
                                  } else {
                                    add_message.file = image;
                                    curr_file = image;
                                  }
                                  add_message.messagFileType =
                                      message_file_type;
                                  add_message.messageSender = app_user1;
                                  add_message.messageReceiver =
                                      widget.message_user;
                                  add_message.messageSent = false;
                                  add_message.messageSeen = false;
                                  add_message.insertMessage = true;
                                  widget.user_messages.add(add_message);
                                  setState(() {
                                    image = null;
                                    message_file_type = '0';
                                    sending_msg = true;
                                    new_message = null;
                                  });
                                  String message_replyto = "";
                                  List<dynamic> ans = await servers()
                                      .post_message(
                                          widget.message_user.email!,
                                          curr_message,
                                          curr_file,
                                          message_file_type,
                                          message_replyto);
                                  setState(() {
                                    if (ans[0] == false) {
                                      add_message.messageSent = true;
                                      add_message.id = ans[1];
                                      sending_msg = false;
                                    }
                                  });
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
        ));
  }
}

class single_message extends StatefulWidget {
  Username app_user;
  Messanger message;
  SmallUsername message_user;
  bool sending_msg;
  single_message(
      this.message, this.app_user, this.message_user, this.sending_msg);

  @override
  State<single_message> createState() => _single_messageState();
}

class _single_messageState extends State<single_message> {
  bool _showController = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Messanger message = widget.message;
    return widget.app_user.username == message.messageSender!.username
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 20,
              ),
              _buildScreen(message),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScreen(message),
              Container(
                width: 20,
              )
            ],
          );
  }

  _buildScreen(Messanger message) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return message.messagFileType == '0'
        ? widget.app_user.username == message.messageSender!.username
            ? Container(
                constraints: BoxConstraints(
                  maxWidth: width - 110,
                  //minWidth: 30
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      topLeft: Radius.circular(11)),
                  color: Colors.indigo[900],
                ),
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(9),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        message.insertMessage!
                            ? message.messageBody!
                            : utf8convert(message.messageBody!),
                        textAlign: TextAlign.right,
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic),
                      ),
                      (!widget.message.messageSent!)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                  Container(),
                                  const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                message.messageSeen == false
                                    ? const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.blueGrey,
                                        size: 14,
                                      )
                                    : const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 14,
                                      )
                              ],
                            )
                    ],
                  ),
                ))
            : Container(
                constraints: BoxConstraints(
                  maxWidth: width - 80,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      topRight: Radius.circular(11)),
                  color: Colors.grey[400],
                ),
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(9),
                child: Text(
                  utf8convert(message.messageBody!),
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                ))
        : GestureDetector(
            onTap: () {
              if (message.messagFileType == '2') {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return video_display4(message.insertMessage!, message.file!,
                      message.messageFile!);
                }));
              }
              if (message.messagFileType == '1') {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return image_display(message.insertMessage!, message.file!,
                      message.messageFile!);
                }));
              }
            },
            child: message.messagFileType == '1'
                ? Container(
                    width: 200,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.message.messageSender!.email ==
                                widget.app_user.email
                            ? Colors.indigo[900]
                            : Colors.grey[400]),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              padding: EdgeInsets.all(13),
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blue[50],
                                  image: message.insertMessage!
                                      ? DecorationImage(
                                          image: FileImage(message.file!),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: NetworkImage(
                                              message.messageFile!),
                                          fit: BoxFit.cover))),
                        ),
                        message.insertMessage!
                            ? Text(message.messageBody!,
                                style: TextStyle(
                                    color:
                                        widget.message.messageSender!.email ==
                                                widget.app_user.email
                                            ? Colors.white
                                            : Colors.black))
                            : Text(utf8convert(message.messageBody!),
                                style: TextStyle(
                                    color:
                                        widget.message.messageSender!.email ==
                                                widget.app_user.email
                                            ? Colors.white
                                            : Colors.black)),
                        widget.message.messageSender!.email ==
                                widget.app_user.email
                            ? Container(
                                child: (!widget.message.messageSent!)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                            Icon(
                                              Icons.more_horiz,
                                              color: Colors.white,
                                              size: 14,
                                            )
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          message.messageSeen == false
                                              ? const Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.blueGrey,
                                                  size: 14,
                                                )
                                              : const Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                          Container(width: 3)
                                        ],
                                      ))
                            : Container()
                      ],
                    ),
                  )
                : message.messagFileType == '2'
                    ? Container(
                        width: 200,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.message.messageSender!.email ==
                                    widget.app_user.email
                                ? Colors.indigo[900]
                                : Colors.grey[400]),
                        child: Column(
                          children: [
                            Container(
                              height: 300,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  ClosedCaption(text: null),
                                  _showController == true
                                      ? Center(
                                          child: InkWell(
                                          child: const Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.blue,
                                            size: 60,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return video_display4(
                                                  message.insertMessage!,
                                                  message.file!,
                                                  message.messageFile!);
                                            }));
                                          },
                                        ))
                                      : Container(),
                                  // Here you can also add Overlay capacities
                                ],
                              ),
                            ),
                            message.insertMessage!
                                ? Text(message.messageBody!,
                                    style: TextStyle(
                                        color: widget.message.messageSender!
                                                    .email ==
                                                widget.app_user.email
                                            ? Colors.white
                                            : Colors.black))
                                : Text(utf8convert(message.messageBody!),
                                    style: TextStyle(
                                        color: widget.message.messageSender!
                                                    .email ==
                                                widget.app_user.email
                                            ? Colors.white
                                            : Colors.black)),
                            widget.message.messageSender!.email ==
                                    widget.app_user.email
                                ? Container(
                                    child: (!widget.message.messageSent!)
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: const [
                                                Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                  size: 14,
                                                )
                                              ])
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              message.messageSeen == false
                                                  ? const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.blueGrey,
                                                      size: 14,
                                                    )
                                                  : const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                              Container(width: 3)
                                            ],
                                          ))
                                : Container()
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            if (!message.insertMessage!) {
                              return pdfviewer(message.file!);
                            } else {
                              return pdfviewer1(message.messageFile!, true);
                            }
                          }));
                        },
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.message.messageSender!.email ==
                                      widget.app_user.email
                                  ? Colors.indigo[900]
                                  : Colors.grey[400]),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                          image:
                                              AssetImage("images/Explorer.png"),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              message.insertMessage!
                                  ? Text(message.messageBody!,
                                      style: TextStyle(
                                          color: widget.message.messageSender!
                                                      .email ==
                                                  widget.app_user.email
                                              ? Colors.white
                                              : Colors.black))
                                  : Text(utf8convert(message.messageBody!),
                                      style: TextStyle(
                                          color: widget.message.messageSender!
                                                      .email ==
                                                  widget.app_user.email
                                              ? Colors.white
                                              : Colors.black)),
                              widget.message.messageSender!.email ==
                                      widget.app_user.email
                                  ? Container(
                                      child: (!widget.message.messageSent!)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                  Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.white,
                                                    size: 14,
                                                  )
                                                ])
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                message.messageSeen == false
                                                    ? const Icon(
                                                        Icons.remove_red_eye,
                                                        color: Colors.blueGrey,
                                                        size: 14,
                                                      )
                                                    : const Icon(
                                                        Icons.remove_red_eye,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                Container(width: 3)
                                              ],
                                            ))
                                  : Container()
                            ],
                          ),
                        )),
          );
  }
}








/*
child: widget.app_user.email == widget.message_user.email
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 80),
                      Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(message.messageBody!))
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(message.messageBody!)),
                      Container(width: 80)
                    ],
                  )
                  */