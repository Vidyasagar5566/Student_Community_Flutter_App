import 'package:flutter/material.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import '/servers/servers.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import '/first_page.dart';
import 'package:testing_app/Year_Branch_Selection/Year_Branch_Selection.dart';

//import 'package:link_text/link_text.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class alertwidget extends StatefulWidget {
  Username app_user;
  String domain;
  alertwidget(this.app_user, this.domain);

  @override
  State<alertwidget> createState() => _alertwidgetState();
}

class _alertwidgetState extends State<alertwidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ALERT_LIST>>(
      future: threads_servers().get_alert_list(widget.domain, 0),
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
            List<ALERT_LIST> alert_list = snapshot.data;
            if (alert_list.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Center(
                    child: Text(
                      "No Data Was Found",
                    ),
                  ));
            } else {
              all_alerts = alert_list;
              return alertwidget1(alert_list, widget.app_user, widget.domain);
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

class alertwidget1 extends StatefulWidget {
  List<ALERT_LIST> alert_list;
  Username app_user;
  String domain;
  alertwidget1(this.alert_list, this.app_user, this.domain);

  @override
  State<alertwidget1> createState() => _alertwidget1State();
}

class _alertwidget1State extends State<alertwidget1> {
  bool total_loaded = true;
  void load_data_fun() async {
    List<ALERT_LIST> latest_alert_list = await threads_servers()
        .get_alert_list(widget.domain, all_alerts.length);
    if (latest_alert_list.length != 0) {
      all_alerts += latest_alert_list;
      setState(() {
        widget.alert_list = all_alerts;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              itemCount: widget.alert_list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              itemBuilder: (BuildContext context, int index) {
                ALERT_LIST alert = widget.alert_list[index];
                return _buildLoadingScreen(alert, widget.alert_list);
              }),
          total_loaded
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
                                  size: 40, color: Colors.blueGrey),
                              Text(
                                "Tap To Load more",
                                style: TextStyle(color: Colors.blueGrey),
                              )
                            ],
                          ))))
              : Container(
                  width: 100,
                  height: 100,
                  child: Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(ALERT_LIST alert, List<ALERT_LIST> alert_list) {
    SmallUsername user = alert.username!;
    var wid = MediaQuery.of(context).size.width;
    var _convertedTimestamp =
        DateTime.parse(alert.postedDate!); // Converting into [DateTime] object
    String alert_posted_date = GetTimeAgo.parse(_convertedTimestamp);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return alert_commentwidget(
              alert, widget.app_user); //event_photowidget
        }));
      },
      child: Container(
          margin: const EdgeInsets.only(top: 8, left: 10, right: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              /*       gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),  */
              borderRadius: BorderRadius.circular(19)),
          child: Row(
            children: [
              SizedBox(
                  width: 48, //post.profile_pic
                  child: user.fileType == '1'
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic!))
                      : const CircleAvatar(
                          backgroundImage: AssetImage("images/profile.jpg"))),
              const SizedBox(width: 10),
              Column(
                children: [
                  SizedBox(
                    width: wid - 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: (wid - 36) / 2.4),
                              child: Text(
                                user.username!,
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
                            9 % 9 == 0
                                ? const Icon(
                                    Icons
                                        .verified_rounded, //verified_rounded,verified_outlined
                                    color: Colors.green,
                                    size: 18,
                                  )
                                : Container()
                          ],
                        ),
                        Text(alert_posted_date.substring(0, 7),
                            style: const TextStyle(
                                //     color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13))
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: wid - 100,
                    child: Text(
                      alert.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        // color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: wid - 100,
                    child: Text(
                      alert.description!,
                      style: const TextStyle(
                        //    color: Colors.white,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}

List<ALERT_CMNT> alert_cmnt_list = [];

class alert_commentwidget extends StatefulWidget {
  ALERT_LIST alert;
  Username app_user;
  alert_commentwidget(this.alert, this.app_user);

  @override
  State<alert_commentwidget> createState() => _alert_commentwidgetState();
}

class _alert_commentwidgetState extends State<alert_commentwidget> {
  var comment;
  bool sending_msg = false;

  bool load_data = false;
  load_data_fun(int id) async {
    alert_cmnt_list = await threads_servers().get_alert_cmnt_list(id);
    setState(() {
      load_data = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun(widget.alert.id!);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          title: Text(
            "Opinions (" + alert_cmnt_list.length.toString() + ")",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            widget.app_user.email == widget.alert.username!.email!
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
                                          "Are you sure do you want to delete this thread?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.all(30),
                                    color: Colors.blue[900],
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          bool error = await threads_servers()
                                              .delete_alert(widget.alert.id!);
                                          if (!error) {
                                            Navigator.pop(context);
                                            Navigator.of(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Error occured plz try again",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white))));
                                          }
                                        },
                                        child: const Center(
                                            child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ))),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                : Container()
          ],
          backgroundColor: Colors.indigoAccent[700]),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.alert.title!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Row(children: [
                Container(
                  width: 48, //post.profile_pic
                  child: widget.alert.username!.fileType == '1'
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.alert.username!.profilePic!))
                      : const CircleAvatar(
                          backgroundImage: AssetImage("images/profile.jpg")),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: (width - 36) / 2.4),
                              child: Text(
                                widget.alert.username!.username!,
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
                            9 % 9 == 0
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
                          domains[widget.alert.username!.domain!]! +
                              " (" +
                              widget.alert.username!.userMark! +
                              ")",
                          overflow: TextOverflow.ellipsis,
                          //lst_list.username.rollNum,
                          //style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                        )
                      ]),
                )
              ]),
              const SizedBox(height: 20),
              Text(widget.alert.description!,
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 30),
              all_files_display(
                  widget.app_user, widget.alert.imgRatio!, widget.alert.img!),
              Divider(
                color: Colors.grey[350],
                height: 25,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
              load_data
                  ? alert_cmnt_list.length == 0
                      ? Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          child: Text("No Opinions yet"),
                        )
                      : lst_cmnt_page(widget.app_user, widget.alert)
                  : Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return upload_alert_cmntwidget(widget.app_user, widget.alert);
          })).then((value) async {
            setState(() {
              load_data = false;
            });
            await load_data_fun(widget.alert.id!);
            setState(() {
              load_data = true;
            });
          });
        },
        tooltip: 'wann share',
        child: Icon(
          Icons.add,
          color: Colors.blueAccent,
        ),
        elevation: 4.0,
      ),
    );
  }
}

class lst_cmnt_page extends StatefulWidget {
  Username app_user;
  ALERT_LIST alert;
  lst_cmnt_page(this.app_user, this.alert);

  @override
  State<lst_cmnt_page> createState() => _lst_cmnt_pageState();
}

class _lst_cmnt_pageState extends State<lst_cmnt_page> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          reverse: true,
          child: ListView.builder(
              itemCount: alert_cmnt_list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 10),
              itemBuilder: (BuildContext context, int index) {
                ALERT_CMNT alert_cmnt = alert_cmnt_list[index];
                return _buildLoadingScreen(alert_cmnt, alert_cmnt_list);
              }),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen(
      ALERT_CMNT alert_cmnt, List<ALERT_CMNT> alert_cmnt_list) {
    SmallUsername user = alert_cmnt.username!;
    Username app_user = widget.app_user;
    var width = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        padding: const EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 48, //post.profile_pic
                  child: alert_cmnt.username!.fileType == '1'
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(alert_cmnt.username!.profilePic!))
                      : const CircleAvatar(
                          backgroundImage: AssetImage("images/profile.jpg")),
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
                              constraints:
                                  BoxConstraints(maxWidth: (width - 36) / 2.4),
                              child: Text(
                                user.username!,
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
                            9 % 9 == 0
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
                          domains[user.domain!]! + " (" + user.userMark! + ")",
                          overflow: TextOverflow.ellipsis,
                          //lst_list.username.rollNum,
                          //style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                        )
                      ]),
                )
              ]),
              (user.email == app_user.email)
                  ? Center(
                      child: IconButton(
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
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      const SizedBox(height: 10),
                                      Container(
                                        margin: const EdgeInsets.all(30),
                                        color: Colors.blue[900],
                                        child: OutlinedButton(
                                            onPressed: () async {
                                              setState(() {
                                                alert_cmnt_list
                                                    .remove(alert_cmnt);
                                                Navigator.pop(context);
                                              });
                                              bool error =
                                                  await threads_servers()
                                                      .delete_alert_cmnt(
                                                          alert_cmnt.id!,
                                                          widget.alert.id!);
                                              if (error) {
                                                setState(() {
                                                  alert_cmnt_list
                                                      .add(alert_cmnt);
                                                });
                                              }
                                            },
                                            child: const Center(
                                                child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          const SizedBox(height: 20),
          Text(
              alert_cmnt.insertMessage!
                  ? alert_cmnt.comment!
                  : utf8convert(alert_cmnt.comment!),
              style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 30),
          all_files_display(
              widget.app_user, alert_cmnt.imgRatio!, alert_cmnt.img!),
          Divider(
            color: Colors.grey[200],
            height: 25,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ]));
  }
}

class upload_alert_cmntwidget extends StatefulWidget {
  Username app_user;
  ALERT_LIST alert;
  upload_alert_cmntwidget(this.app_user, this.alert);

  @override
  State<upload_alert_cmntwidget> createState() =>
      _upload_alert_cmntwidgetState();
}

class _upload_alert_cmntwidgetState extends State<upload_alert_cmntwidget> {
  var description;
  var file;
  var file_type;
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Alert Opinions",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Share Your Opinion",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines:
                                4, //Normal textInputField will be displayed
                            maxLines: 10,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'about the post.....',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                description = value;
                                if (description == "") {
                                  description = null;
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
                        const Text(
                          "Add an image (Optional)",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  if (Platform.isAndroid) {
                                                    final ImagePicker _picker =
                                                        ImagePicker();
                                                    final XFile? image1 =
                                                        await _picker.pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            imageQuality: 35);
                                                    setState(() {
                                                      file = File(image1!.path);

                                                      file_type = 1;
                                                    });
                                                  } else {
                                                    final ImagePicker _picker =
                                                        ImagePicker();
                                                    final XFile? image1 =
                                                        await _picker.pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            imageQuality: 5);
                                                    setState(() {
                                                      file = File(image1!.path);

                                                      file_type = 1;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons
                                                        .photo_library_outlined,
                                                    size: 20)),
                                            IconButton(
                                                onPressed: () async {
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final image1 =
                                                      await _picker.pickVideo(
                                                    source: ImageSource.gallery,
                                                  );

                                                  //final bytes = await File(image1!.path).readAsBytes();
                                                  setState(() {
                                                    file = File(image1!.path);

                                                    file_type = 2;
                                                    //final img.Image image = img.decodeImage(bytes)!;
                                                  });
                                                  loadVideoPlayer(file);
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .video_collection_outlined,
                                                  size: 20,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  final result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: ['pdf'],
                                                  );
                                                  setState(() {
                                                    file = File(
                                                        result!.paths.first ??
                                                            '');

                                                    file_type = 3;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.file_copy_sharp,
                                                    size: 20)),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        (description != null)
                            ? Container(
                                padding: EdgeInsets.only(left: 40, right: 40),
                                margin: EdgeInsets.only(top: 40),
                                width: 270,
                                height: 60,
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    Navigator.of(context);
                                    if (widget.app_user.email ==
                                        "guest@nitc.ac.in") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "guest cannot share opinions..",
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: const Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Please wait while uploading....."),
                                                        SizedBox(height: 10),
                                                        CircularProgressIndicator()
                                                      ]),
                                                ));
                                          });
                                      if (file_type == null) {
                                        file = File('images/club.jpg');
                                        file_type = 0;
                                      }
                                      List<dynamic> error =
                                          await threads_servers()
                                              .post_alert_cmnt(
                                                  description,
                                                  widget.alert.id!,
                                                  file,
                                                  file_type,
                                                  notif_years.join(''),
                                                  notif_branchs.join("@"));

                                      Navigator.pop(context);
                                      if (!error[0]) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Uploaded successfully",
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                        await Future.delayed(
                                            Duration(seconds: 2));

                                        /*              bool error = await threads_servers()
                                            .send_notifications(
                                                widget.app_user.email!,
                                                " shared a new opinion on " +
                                                    " : " +
                                                    widget.alert.title! +
                                                    ' :' +
                                                    description,
                                                4);
                                        if (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Failed to send notifications",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))));   
                                        } */
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text("Failed",
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      }
                                    }
                                  },
                                  color: Colors.indigo[200],
                                  textColor: Colors.black,
                                  child: const Text(
                                    "Upload",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))
                            : Container(
                                margin: EdgeInsets.only(top: 40),
                                padding: EdgeInsets.only(left: 40, right: 40),
                                width: 250,
                                height: 55,
                                child: MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  minWidth: double.infinity,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Fill all the details",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                  color: Colors.green[200],
                                  textColor: Colors.white,
                                  child: const Text("Upload",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                )),
                        const SizedBox(height: 10),
                        file != null
                            ? Container(
                                //height: width * 1.4, // image_ratio,
                                //width: width,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: file_type == 1
                                    ? Image.file(file)
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
                                                      .value.aspectRatio,
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                children: <Widget>[
                                                  VideoPlayer(
                                                      _videoPlayerController!),
                                                  ClosedCaption(text: null),
                                                  _showController == true
                                                      ? Center(
                                                          child: InkWell(
                                                          child: Icon(
                                                            _videoPlayerController!
                                                                    .value
                                                                    .isPlaying
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_arrow,
                                                            color: Colors.white,
                                                            size: 60,
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              _videoPlayerController!
                                                                      .value
                                                                      .isPlaying
                                                                  ? _videoPlayerController!
                                                                      .pause()
                                                                  : _videoPlayerController!
                                                                      .play();
                                                              _showController =
                                                                  !_showController;
                                                            });
                                                          },
                                                        ))
                                                      : Container(),
                                                  // Here you can also add Overlay capacities
                                                  VideoProgressIndicator(
                                                    _videoPlayerController!,
                                                    allowScrubbing: true,
                                                    padding: EdgeInsets.all(3),
                                                    colors:
                                                        const VideoProgressColors(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      playedColor: Colors.green,
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
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return pdfviewer(file);
                                                  }));
                                                },
                                                child: Center(
                                                  child: Container(
                                                      height: width * (0.7),
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          image: const DecorationImage(
                                                              image: AssetImage(
                                                                  "images/Explorer.png"),
                                                              fit: BoxFit
                                                                  .cover))),
                                                ))
                                            : Container())
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
  }
}
