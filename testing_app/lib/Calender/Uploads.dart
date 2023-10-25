import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/first_page.dart';
import 'Servers.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import 'package:intl/intl.dart';
import 'package:testing_app/Year_Branch_Selection/Year_Branch_Selection.dart';

class upload_cal_event extends StatefulWidget {
  Username app_user;
  upload_cal_event(this.app_user);

  @override
  State<upload_cal_event> createState() => _upload_cal_eventState();
}

class _upload_cal_eventState extends State<upload_cal_event> {
  var title;
  var description;
  var image;
  String file_type = "0";
  String image_vedio = "";
  bool _showController = true;
  VideoPlayerController? _videoPlayerController;
  PDFViewController? pdfViewController;
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    String error = "";
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Cal-Events",
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
                    "Upload Your Post",
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
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'title',
                              hintText: 'lost my id card',
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
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'please enter email'
                                  : null;
                            },
                          ),
                        ),
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
                                        BorderRadius.all(Radius.circular(10)))),
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
                        select_branch_year(),
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
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                            const SizedBox(height: 10),
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
                                                    file_type = "1";
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
                                                    file_type = "2";
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
                                                  final result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: ['pdf'],
                                                  );

                                                  setState(() {
                                                    image = File(
                                                        result!.paths.first ??
                                                            '');
                                                    image_vedio = "pdf";
                                                    file_type = "3";
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
                        (title != null && description != null)
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
                                    if (widget.app_user.email ==
                                            "guest@nitc.ac.in" ||
                                        !widget.app_user.isAdmin! ||
                                        !widget.app_user.isStudentAdmin!) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "students/Guest cannot share any feedback/etc..",
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                    } else {
                                      if (image == null) {
                                        image = File("images/profile.jpg");
                                      }
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                content: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        Text(
                                                            "Please wait while uploading....."),
                                                        SizedBox(height: 10),
                                                        CircularProgressIndicator()
                                                      ]),
                                                ));
                                          });
                                      List<dynamic> error =
                                          await calendar_servers()
                                              .post_calender_event(
                                                  'all',
                                                  title,
                                                  description,
                                                  image,
                                                  file_type,
                                                  notif_branchs.join('@'),
                                                  notif_years.join(''),
                                                  formattedDate +
                                                      'T' +
                                                      formattedTime);
                                      Navigator.pop(context);
                                      if (!error[0]) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return firstpage(1, widget.app_user);
                                        }), (Route<dynamic> route) => false);
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
                                        : image_vedio == "pdf"
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return pdfviewer(image);
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
