import 'package:flutter/material.dart';
import '/Fcm_Notif_Domains/Servers.dart';
import 'Servers.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import 'Search_bar.dart';
import 'Single_message.dart';
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
        body: fireBaseUuids_to_backendUsers(widget.app_user, [], []));
  }
}

class fireBaseUuids_to_backendUsers extends StatefulWidget {
  Username app_user;
  List<String> user_messages;
  List<String> user_uuids;
  fireBaseUuids_to_backendUsers(
      this.app_user, this.user_messages, this.user_uuids);

  @override
  State<fireBaseUuids_to_backendUsers> createState() =>
      _fireBaseUuids_to_backendUsersState();
}

class _fireBaseUuids_to_backendUsersState
    extends State<fireBaseUuids_to_backendUsers> {
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
            List<SmallUsername> message_users = snapshot.data;
            if (message_users.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Text("No conversations started yet",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 24)));
            } else {
              return messanger1(
                  widget.app_user, widget.user_messages, message_users);
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class messanger1 extends StatefulWidget {
  Username app_user;
  List<String> user_messages;
  List<SmallUsername> message_users;
  messanger1(this.app_user, this.user_messages, this.message_users);

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
                        message_user, widget.user_messages[index], index);
                  }),
            ],
          )),
    );
  }

  Widget _buildLoadingScreen(
      SmallUsername message_user, String user_message, int index) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return messages_viewer(widget.app_user, message_user, []);
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
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "message : " + utf8convert(user_message),
                    softWrap: false, maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
  List<Messager> user_conversation;
  messages_viewer(this.app_user, this.message_user, this.user_conversation);

  @override
  State<messages_viewer> createState() => _messages_viewerState();
}

class _messages_viewerState extends State<messages_viewer> {
  var new_message;
  var image;
  var circular_ind;
  String message_file_type = "0";
  bool _showController = true;
  TextEditingController _controller1 = TextEditingController();
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

  bool total_loaded = false;
  void load_data_fun(String intial) async {
    List<Messager> latest_user_conversation = await messanger_servers()
        .user_user_messages(
            widget.message_user.email!, widget.user_conversation.length);
    if (latest_user_conversation.length != 0) {
      setState(() {
        widget.user_conversation =
            latest_user_conversation + widget.user_conversation;
      });
    } else {
      if (intial != 'intial') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 400),
            content: Text("all the feed was shown..",
                style: TextStyle(color: Colors.white))));
      }
    }
    setState(() {
      total_loaded = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun('intial');
  }

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
                    child: Column(
                      children: [
                        total_loaded
                            ? widget.user_conversation.length > 5
                                ? Container(
                                    width: width,
                                    height: 100,
                                    child: Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                total_loaded = false;
                                              });
                                              load_data_fun('');
                                            },
                                            child: const Column(
                                              children: [
                                                Icon(Icons.add_circle_outline,
                                                    size: 40,
                                                    color: Colors.blue),
                                                Text(
                                                  "Tap To Load more",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )
                                              ],
                                            ))))
                                : Container()
                            : Container(
                                width: 100,
                                height: 100,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.blue))),
                        const SizedBox(height: 10),
                        widget.user_conversation.isEmpty && total_loaded
                            ? const Center(
                                child: Text("No Conversation Started Yet."),
                              )
                            : ListView.builder(
                                itemCount: widget.user_conversation.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  Messager message =
                                      widget.user_conversation[index];
                                  return single_message(message,
                                      widget.app_user, widget.message_user);
                                }),
                        const SizedBox(height: 10),
                      ],
                    )),
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
                          controller: _controller1,
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
                      (new_message != null || image != null)
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
                                    SmallUsername app_user1 =
                                        user_min(widget.app_user);
                                    //message insertion
                                    Messager add_message = Messager();
                                    String curr_message = "";
                                    curr_message = new_message ?? "";

                                    add_message.messageBody = curr_message;

                                    File curr_file =
                                        image ?? File('images/profile.jpg');

                                    add_message.file = curr_file;

                                    add_message.messagFileType =
                                        message_file_type;
                                    add_message.messageFile = "";
                                    add_message.messageSender = app_user1.email;
                                    add_message.messageReceiver =
                                        widget.message_user.email;
                                    add_message.messageSent = false;
                                    add_message.messageSeen = false;
                                    add_message.insertMessage = true;
                                    widget.user_conversation.add(add_message);
                                    setState(() {
                                      image = null;
                                      message_file_type = '0';
                                      new_message = null;
                                      _controller1.clear();
                                    });
                                    List<dynamic> ans =
                                        await messanger_servers().post_message(
                                            widget.message_user.email!,
                                            curr_message,
                                            curr_file,
                                            add_message.messagFileType!,
                                            "");
                                    setState(() {
                                      if (ans[0] == false) {
                                        add_message.messageSent = true;
                                        add_message.id = ans[1];
                                      }
                                    });
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
        ));
  }
}
