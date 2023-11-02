import 'package:flutter/material.dart';
import '/First_page.dart';
import 'Models.dart';
import '/User_profile/Models.dart';
import 'Servers.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '/User_Star_Mark/User_Profile_Star_Mark.dart';
import '/Fcm_Notif_Domains/servers.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class activitieswidget extends StatefulWidget {
  Username app_user;
  String domain;
  activitieswidget(this.app_user, this.domain, {super.key});

  @override
  State<activitieswidget> createState() => _activitieswidgetState();
}

class _activitieswidgetState extends State<activitieswidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EVENT_LIST>>(
      future: activity_servers().get_event_list(widget.domain, 0),
      builder: (ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            List<EVENT_LIST> eventList = snapshot.data;
            if (eventList.isEmpty) {
              return Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(30),
                  child: const Center(
                    child: Text(
                      "No Data Was Found",
                    ),
                  ));
            } else {
              all_events = eventList;
              return activitieswidget1(
                  eventList, widget.app_user, widget.domain, false);
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

// ignore: must_be_immutable
class activitieswidget1 extends StatefulWidget {
  List<EVENT_LIST> event_list;
  Username app_user;
  String domain;
  bool profile;
  activitieswidget1(this.event_list, this.app_user, this.domain, this.profile);

  @override
  State<activitieswidget1> createState() => _activitieswidget1State();
}

class _activitieswidget1State extends State<activitieswidget1> {
  bool total_loaded = true;
  void load_data_fun() async {
    List<EVENT_LIST> latestEventList = await activity_servers()
        .get_event_list(widget.domain, all_events.length);
    if (latestEventList.length != 0) {
      all_events += latestEventList;
      setState(() {
        widget.event_list = all_events;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 300),
          content: Text("all the feed was shown..",
              style: TextStyle(color: Colors.white))));
    }
    setState(() {
      total_loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return widget.event_list.isEmpty
        ? Container(
            margin: EdgeInsets.only(top: height / 3),
            child: const Center(
              child: Text(
                "No Activities Was Found",
              ),
            ))
        : SingleChildScrollView(
            child: Column(
              children: [
                NotificationListener<ScrollEndNotification>(
                    onNotification: (scrollEnd) {
                      final metrics = scrollEnd.metrics;
                      if (metrics.atEdge) {
                        bool isTop = metrics.pixels == 0;
                        if (!isTop) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(milliseconds: 400),
                                  backgroundColor: Colors.white,
                                  content: Text("loading....",
                                      style: TextStyle(color: Colors.black))));
                          load_data_fun();
                        }
                      }
                      return true;
                    },
                    child: ListView.builder(
                        itemCount: widget.event_list.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 10),
                        itemBuilder: (BuildContext context, int index) {
                          EVENT_LIST event = widget.event_list[index];
                          return single_event(event, widget.app_user);
                        })),
                total_loaded
                    ? widget.event_list.length > 10 && !widget.profile
                        ? Container(
                            width: width,
                            height: 100,
                            child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        total_loaded = false;
                                      });
                                      load_data_fun();
                                    },
                                    child: const Column(
                                      children: [
                                        Icon(Icons.add_circle_outline,
                                            size: 40, color: Colors.blue),
                                        Text(
                                          "Tap To Load more",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    ))))
                        : Container()
                    : Container(
                        width: 100,
                        height: 100,
                        child: Center(child: CircularProgressIndicator()))
              ],
            ),
          );
  }
}

// ignore: must_be_immutable
class single_event extends StatefulWidget {
  EVENT_LIST event;
  Username app_user;
  single_event(this.event, this.app_user);

  @override
  State<single_event> createState() => _single_eventState();
}

class _single_eventState extends State<single_event> {
  bool _showController = true;
  VideoPlayerController? _videoPlayerController;

  void initState() {
    super.initState();
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.network(
        widget.event.eventImg!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _videoPlayerController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    EVENT_LIST event = widget.event;
    var width = MediaQuery.of(context).size.width;
    SmallUsername user = widget.event.username!;
    List<String> eventUpdates;
    eventUpdates = event.eventUpdate.toString().split('`');
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return event_photowidget(event, widget.app_user, eventUpdates,
              _videoPlayerController!); //event_photowidget
        }));
      },
      onDoubleTap: () async {
        if (widget.app_user.email == "guest@nitc.ac.in") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 400),
              content: Text(
                "Guests are not allowed",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          setState(() {
            event.isLike = !event.isLike!;
          });
          if (event.isLike!) {
            setState(() {
              event.likeCount = event.likeCount! + 1;
            });
            bool error = await activity_servers().post_event_like(event.id!);
            if (error) {
              setState(() {
                event.likeCount = event.likeCount! - 1;
                event.isLike = !event.isLike!;
              });
            }
          } else {
            setState(() {
              event.likeCount = event.likeCount! - 1;
            });
            bool error = await activity_servers().delete_event_like(event.id!);
            if (error) {
              setState(() {
                event.likeCount = event.likeCount! + 1;
                event.isLike = !event.isLike!;
              });
            }
            SystemSound.play(SystemSoundType.click);
          }
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Shadow color
              offset:
                  Offset(0, 1), // Offset of the shadow (horizontal, vertical)
              blurRadius: 2, // Spread of the shadow
              spreadRadius: 0, // Expansion of the shadow
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            event.imgRatio == 1
                ? Container(
                    decoration: event.imgRatio == 1
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                                scale: 10,
                                image: AssetImage('images/loading.png')))
                        : BoxDecoration(),
                    child: Center(
                        child: Container(
                      height: width,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: DecorationImage(
                              image: NetworkImage(event.eventImg!),
                              fit: BoxFit.cover)),
                      /*child: CircularProgressIndicator(
                            color: Colors.grey[400],
                            strokeWidth: 2,
                          )*/
                    )),
                  )
                : AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(_videoPlayerController!),
                        ClosedCaption(text: null),
                        _showController == true
                            ? Center(
                                child: InkWell(
                                child: Icon(
                                  _videoPlayerController!.value.isPlaying
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                  color: Colors.blue,
                                  size: 60,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return event_photowidget(
                                        event,
                                        widget.app_user,
                                        eventUpdates,
                                        _videoPlayerController!); //event_photowidget
                                  }));
                                },
                              ))
                            : Container(),
                        // Here you can also add Overlay capacities
                        VideoProgressIndicator(
                          _videoPlayerController!,
                          allowScrubbing: true,
                          padding: EdgeInsets.all(3),
                          colors: const VideoProgressColors(
                            backgroundColor: Colors.black,
                            playedColor: Colors.white,
                            bufferedColor: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              smallUserProfileMark(widget.app_user, user),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (widget.app_user.email == "guest@nitc.ac.in") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 400),
                              content: Text(
                                "Guests are not allowed",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            event.isLike = !event.isLike!;
                          });
                          if (event.isLike!) {
                            setState(() {
                              event.likeCount = event.likeCount! + 1;
                            });
                            bool error = await activity_servers()
                                .post_event_like(event.id!);
                            if (error) {
                              setState(() {
                                event.likeCount = event.likeCount! - 1;
                                event.isLike = !event.isLike!;
                              });
                            }
                          } else {
                            setState(() {
                              event.likeCount = event.likeCount! - 1;
                            });
                            bool error = await activity_servers()
                                .delete_event_like(event.id!);
                            if (error) {
                              setState(() {
                                event.likeCount = event.likeCount! + 1;
                                event.isLike = !event.isLike!;
                              });
                            }
                            SystemSound.play(SystemSoundType.click);
                          }
                        }
                      },
                      icon: event.isLike!
                          ? const Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                    ),
                    // Text(post.likes.toString() + "likes")
                    Text(
                      event.likeCount.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class event_photowidget extends StatefulWidget {
  EVENT_LIST event;
  Username app_user;
  List<String> event_updates;
  VideoPlayerController _videoPlayerController;
  event_photowidget(this.event, this.app_user, this.event_updates,
      this._videoPlayerController);

  @override
  State<event_photowidget> createState() => _event_photowidgetState();
}

class _event_photowidgetState extends State<event_photowidget> {
  var update_text;
  bool _showController = true;
  TextEditingController _controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    EVENT_LIST event = widget.event;
    String deleteError = "";
    final Username appUser = widget.app_user;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "NIT CALICUT",
            //"Event name",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: Container(
          color: Colors.indigo,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      utf8convert(widget.event.title!),
                      //"Description",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: //Link
                      Text(
                    utf8convert(widget.event.description!),
                    //"Description",
                    //style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      children: [
                        const Text("image/video",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black)),
                        const SizedBox(height: 10),
                        event.imgRatio == 2
                            ? GestureDetector(
                                onTap: () {
                                  widget._videoPlayerController.play();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return video_display(
                                        event, widget._videoPlayerController);
                                  }));
                                },
                                child: AspectRatio(
                                  aspectRatio: widget
                                      ._videoPlayerController.value.aspectRatio,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      VideoPlayer(
                                          widget._videoPlayerController),
                                      ClosedCaption(text: null),
                                      _showController == true
                                          ? Center(
                                              child: InkWell(
                                              child: Icon(
                                                widget._videoPlayerController
                                                        .value.isPlaying
                                                    ? Icons.pause_circle_outline
                                                    : Icons.play_circle_outline,
                                                color: Colors.blue,
                                                size: 60,
                                              ),
                                              onTap: () {
                                                widget._videoPlayerController
                                                    .play();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return video_display(
                                                      event,
                                                      widget
                                                          ._videoPlayerController);
                                                }));
                                              },
                                            ))
                                          : Container(),
                                      // Here you can also add Overlay capacities
                                      VideoProgressIndicator(
                                        widget._videoPlayerController,
                                        allowScrubbing: true,
                                        padding: EdgeInsets.all(3),
                                        colors: const VideoProgressColors(
                                          backgroundColor: Colors.black,
                                          playedColor: Colors.white,
                                          bufferedColor: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  height: width,
                                  width: width,
                                  child: Image.network(event.eventImg!),
                                ),
                              ),
                        const SizedBox(height: 10),
                        (appUser.isSuperuser! ||
                                widget.app_user.email ==
                                    widget.event.username!.email)
                            ? Center(
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(),
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                                Icons.close))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20),
                                                    const Center(
                                                        child: Text(
                                                            "Are you sure do you want to delete this?",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              30),
                                                      color: Colors.blue[900],
                                                      child: OutlinedButton(
                                                          onPressed: () async {
                                                            bool error =
                                                                await activity_servers()
                                                                    .delete_event(
                                                                        widget
                                                                            .event
                                                                            .id!);
                                                            if (!error) {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.of(context).pushAndRemoveUntil(
                                                                  MaterialPageRoute(builder:
                                                                      (BuildContext
                                                                          context) {
                                                                return firstpage(
                                                                    2,
                                                                    widget
                                                                        .app_user);
                                                              }),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                            } else {
                                                              setState(() {
                                                                deleteError =
                                                                    "check your connection";
                                                              });
                                                            }
                                                          },
                                                          child: const Center(
                                                              child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    deleteError != ""
                                                        ? Center(
                                                            child: Text(
                                                                deleteError,
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            138,
                                                                            79,
                                                                            79))),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 31,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    (widget.app_user.username ==
                                                widget
                                                    .event.username!.username ||
                                            widget.app_user.isSuperuser!)
                                        ? Column(
                                            children: [
                                              const Text(
                                                "Delete the event?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 40, right: 40),
                                                child: TextFormField(
                                                  controller: _controller1,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  minLines:
                                                      4, //Normal textInputField will be displayed
                                                  maxLines: 10,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Description',
                                                    hintText: 'everyone .....',
                                                    prefixIcon:
                                                        Icon(Icons.text_fields),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                  ),
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      update_text = value;
                                                      if (update_text == "") {
                                                        update_text = null;
                                                      }
                                                    });
                                                  },
                                                  validator: (value) {
                                                    return value!.isEmpty
                                                        ? 'please enter password'
                                                        : null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              update_text != null
                                                  ? TextButton(
                                                      onPressed: () async {
                                                        String temp =
                                                            update_text;
                                                        update_text = null;
                                                        setState(() {
                                                          _controller1.clear();
                                                          widget.event_updates
                                                              .insert(0,
                                                                  '&&&' + temp);
                                                        });
                                                        bool error =
                                                            await activity_servers()
                                                                .update_event(
                                                                    widget.event
                                                                        .id!,
                                                                    temp);
                                                        if (!error) {
                                                          bool error1 = await servers()
                                                              .send_notifications(
                                                                  "Event :  update",
                                                                  update_text,
                                                                  4);
                                                        }
                                                      },
                                                      child: const Text(
                                                        "Update",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.blue),
                                                      ))
                                                  : Container()
                                            ],
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    )),
                const SizedBox(height: 10),
                const Center(
                    child: Text("Updates",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18))),
                Container(
                  child: ListView.builder(
                      itemCount: widget.event_updates.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 10),
                      itemBuilder: (BuildContext context, int index) {
                        String update = widget.event_updates[index];
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: update.substring(0, 3) == '&&&'
                                ? //Link
                                Text(update.substring(3, update.length))
                                : //Link
                                Text(
                                    utf8convert(update),
                                  ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class video_display extends StatefulWidget {
  EVENT_LIST event;
  VideoPlayerController _videoPlayerController;
  video_display(this.event, this._videoPlayerController);

  @override
  State<video_display> createState() => _video_displayState();
}

class _video_displayState extends State<video_display> {
  bool _showController = true;
  bool isLoading = false;
  var platform;
  var _localPath;
  String ret = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/"; //NITC InstaBook/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + "/"; //+ Platform.pathSeparator + 'Download/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          actions: [
            (ret == "" || ret == "failed")
                ? IconButton(
                    onPressed: () async {
                      setState(() {
                        ret = "start";
                      });
                      bool _permissionReady = await _checkPermission();
                      if (_permissionReady) {
                        await _prepareSaveDir();
                        print("Downloading");
                        try {
                          List<String> urls = widget.event.eventImg!.split('?');
                          List<String> subUrls = urls[0].split("/");
                          await Dio().download(widget.event.eventImg!,
                              _localPath + subUrls[subUrls.length - 1]);
                          setState(() {
                            ret = "sucess";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(milliseconds: 400),
                              content: Platform.isAndroid
                                  ? const Text(
                                      'success, check your download folder',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const Text(
                                      'success, check your InstaBook folder in your "on my iphone"',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        } catch (e) {
                          print(e.toString());
                          setState(() {
                            ret = "failed";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 400),
                              content: Text(
                                'failed',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon:
                        const Icon(Icons.download_rounded, color: Colors.white),
                  )
                : const CircularProgressIndicator(color: Colors.white)
          ],
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showController = !_showController;
                });
              },
              child: AspectRatio(
                aspectRatio: widget._videoPlayerController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(widget._videoPlayerController),
                    ClosedCaption(text: null),
                    _showController == true
                        ? Center(
                            child: InkWell(
                            child: Icon(
                              widget._videoPlayerController.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.blue,
                              size: 60,
                            ),
                            onTap: () {
                              setState(() {
                                widget._videoPlayerController.value.isPlaying
                                    ? widget._videoPlayerController.pause()
                                    : widget._videoPlayerController.play();
                                _showController = !_showController;
                              });
                            },
                          ))
                        : Container(),
                    // Here you can also add Overlay capacities
                    VideoProgressIndicator(
                      widget._videoPlayerController,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: const VideoProgressColors(
                        backgroundColor: Colors.black,
                        playedColor: Colors.white,
                        bufferedColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      widget._videoPlayerController.pause();
      _showController = !_showController;
    });
  }
}
