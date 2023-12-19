import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/First_page.dart';
import '/User_profile/Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';
import 'Servers.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import '../Circular_designs/Cure_clip.dart';

class upload_eventwidget extends StatefulWidget {
  Username app_user;
  String event_category;
  String id;
  upload_eventwidget(this.app_user, this.event_category, this.id);

  @override
  State<upload_eventwidget> createState() => _upload_eventwidgetState();
}

class _upload_eventwidgetState extends State<upload_eventwidget> {
  var title;
  var description;
  var image;
  String image_ratio = "";
  String image_vedio = "";
  bool _showController = true;
  VideoPlayerController? _videoPlayerController;
  String formattedTime = "12:00";
  String formattedDate = "2023-05-29";
  TextEditingController timeinput = TextEditingController();
  TextEditingController dateinput = TextEditingController();

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

  String all_university = 'All';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Events",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            DropdownButton<String>(
                value: all_university,
                underline: Container(),
                elevation: 0,
                items: ['All', domains[widget.app_user.domain]!]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    all_university = value!;
                  });
                })
          ],
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
                    "Upload Your Event",
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'title',
                              hintText: 'event name',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                title = value;
                                if (title == "") {
                                  title = null;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines:
                                4, //Normal textInputField will be displayed
                            maxLines: 10,
                            decoration: const InputDecoration(
                                labelText: 'Description',
                                hintText: 'about the event and timings.....',
                                prefixIcon: Icon(Icons.text_fields),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            onChanged: (String value) {
                              setState(() {
                                description = value;
                                if (description == "") {
                                  description = null;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                              //initialValue: "00-00-00",
                              controller: dateinput,
                              decoration: const InputDecoration(
                                  labelText: "Enter Date",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));
                                formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(pickedDate!);

                                setState(() {
                                  dateinput.text =
                                      formattedDate; //set foratted date to TextField value.
                                });
                              }),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              //initialValue: "12:00:00",
                              controller:
                                  timeinput, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  labelText: "Enter Time",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              10))) //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                formattedTime = pickedTime!.hour.toString() +
                                    ":" +
                                    pickedTime.minute.toString() +
                                    ':00';
                                setState(() {
                                  timeinput.text = formattedTime;
                                });
                              },
                            )),
                        const SizedBox(height: 10),
                        const Text(
                          "Add an image",
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
                                    contentPadding: EdgeInsets.all(25),
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
                                                  final ImagePicker _picker =
                                                      ImagePicker();
                                                  final XFile? image1 =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 35);
                                                  //final bytes = await File(image1!.path).readAsBytes();
                                                  setState(() {
                                                    image = File(image1!.path);
                                                    image_vedio = "image";
                                                    image_ratio = "1";
                                                    //final img.Image image = img.decodeImage(bytes)!;
                                                  });
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
                                                    image = File(image1!.path);
                                                    image_vedio = "vedio";
                                                    image_ratio = "2";
                                                    //final img.Image image = img.decodeImage(bytes)!;
                                                  });
                                                  loadVideoPlayer(image);
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .video_collection_outlined,
                                                  size: 20,
                                                )),
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
                        (title != null && description != null && image != null)
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
                                    if (widget.app_user.email!.split('@')[0] ==
                                            "guest" ||
                                        !widget.app_user.isAdmin!) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "only admins can upload events..",
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
                                      bool error = await activity_servers()
                                          .post_event(
                                              title,
                                              description,
                                              image,
                                              image_ratio,
                                              formattedDate +
                                                  'T' +
                                                  formattedTime +
                                                  'Z',
                                              all_university,
                                              widget.event_category,
                                              widget.id);
                                      Navigator.pop(context);
                                      if (!error) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return firstpage(2, widget.app_user);
                                        }), (Route<dynamic> route) => false);

                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        bool error = await servers()
                                            .send_notifications(
                                                "Event :  $title",
                                                description,
                                                4);
                                        if (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  content: Text(
                                                      "Failed to send notifications",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration:
                                                Duration(milliseconds: 400),
                                            content: Text(
                                              "Failed",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
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
                                        duration: Duration(milliseconds: 400),
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
                        image != null
                            ? Container(
                                //height: width * 1.4, // image_ratio,
                                //width: width,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
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
                                        : Container())
                            : Container(),
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

class eventCategory extends StatefulWidget {
  Username app_user;
  eventCategory(this.app_user);

  @override
  State<eventCategory> createState() => _eventCategoryState();
}

class _eventCategoryState extends State<eventCategory> {
  List<bool> _bool_list = [false, false, false, false];
  var clubs = {};
  var sports = {};
  var fests = {};
  var sacs = {};
  @override
  Widget build(BuildContext context) {
    clubs = widget.app_user.clzClubs!['head'];
    sports = widget.app_user.clzSports!['head'];
    fests = widget.app_user.clzFests!['head'];
    sacs = widget.app_user.clzSacs!['head'];

    if (clubs.isEmpty && sports.isEmpty && fests.isEmpty && sacs.isEmpty) {
      return upload_eventwidget(widget.app_user, 'student', '0');
    }

    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                //color: Colors.pink[100],
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.cover),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipPath(
                            clipper: profile_Clipper(),
                            child: Container(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purple.shade300
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )))),
                        Positioned(
                            left: 25,
                            top: 75,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: wid / 0.5,
                                  child: const Text(
                                    'Post Category',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return upload_eventwidget(
                              widget.app_user, 'student', '0');
                        }));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple,
                                Colors.purple.shade300
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          padding: const EdgeInsets.only(
                              top: 7, left: 20, bottom: 7),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      constraints:
                                          BoxConstraints(maxWidth: wid / 2),
                                      child: const Text(
                                        'Student Post',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ])
                            ],
                          )),
                    ),
                    const SizedBox(height: 30),
                    ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return build_screen(index);
                        })
                  ],
                )))));
  }

  Widget build_screen(int index) {
    var wid = MediaQuery.of(context).size.width;
    List<Map> _category_list = [clubs, sports, fests, sacs];
    List<String> _category_list_names = ['club', 'sport', 'fest', 'sac'];

    if (_category_list[index].isEmpty) {
      return Container();
    }
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 7, left: 20, bottom: 7),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                constraints: BoxConstraints(maxWidth: wid / 2),
                child: Text(
                  _category_list_names[index],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _bool_list[index] = !_bool_list[index];
                  });
                },
                icon: _bool_list[index]
                    ? const Icon(
                        Icons.keyboard_arrow_up_outlined,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.white,
                      ),
              )
            ]),
            const SizedBox(height: 4),
            _bool_list[index]
                ? ListView.builder(
                    itemCount: _category_list[index].length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 10),
                    itemBuilder: (BuildContext context, int index1) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return upload_eventwidget(
                                widget.app_user,
                                _category_list_names[index],
                                _category_list[index].keys.elementAt(index1));
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 15, bottom: 15),
                          child: Text(
                            _category_list[index].values.elementAt(index1),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    })
                : Container()
          ],
        ));
  }
}
