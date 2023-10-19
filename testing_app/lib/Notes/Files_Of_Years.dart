import 'package:flutter/material.dart';
import 'dart:io';
import '../circular_designs/cure_clip.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class CalSubFiles extends StatefulWidget {
  Username app_user;
  List<CAL_SUB_FILES> cal_sub_files;
  CAL_SUB_YEARS sub_year;
  String sub_id;
  CalSubFiles(
    this.app_user,
    this.cal_sub_files,
    this.sub_year,
    this.sub_id,
  );

  @override
  State<CalSubFiles> createState() => _CalSubFilesState();
}

class _CalSubFilesState extends State<CalSubFiles> {
  var file_name;
  var file;
  String file_type = "";
  var loaded_data = false;
  List<CAL_SUB_FILES> sub_files = [];

  void load_data_fun() async {
    List<CAL_SUB_FILES> sub_files1 =
        await notes_servers().get_sub_files_list(widget.sub_year.id.toString());
    setState(() {
      sub_files = sub_files1;
      sub_files.sort((a, b) => a.fileName!.compareTo(b.fileName!));
      loaded_data = true;
    });
  }

  void initState() {
    super.initState();
    load_data_fun();
  }

  void uploading() async {
    var new_file = CAL_SUB_FILES();
    new_file.fileName = file.path.split("/").last;
    new_file.uploaded = false;
    new_file.insert = true;
    new_file.file = file;
    new_file.fileType = file_type;
    new_file.qnAnsFile = "";
    new_file.username = user_min(widget.app_user);
    setState(() {
      widget.cal_sub_files.add(new_file);
    });
    List<dynamic> error = await notes_servers()
        .post_cal_sub_files(file, widget.sub_year.id.toString(), file_type);
    if (!error[0]) {
      setState(() {
        new_file.id = error[1];
        new_file.uploaded = true;
      });
    } else {
      setState(() {
        widget.cal_sub_files.remove(new_file);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "error occured please try again",
          style: TextStyle(color: Colors.white),
        )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    widget.cal_sub_files = sub_files;
    widget.cal_sub_files.sort((a, b) => a.fileName!.compareTo(b.fileName!));
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              //color: Colors.pink[100],
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.cover)),
              child: SingleChildScrollView(
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
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
                              )),
                            )),
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
                                    width: wid / 2,
                                    child: Text(
                                      widget.sub_year.yearName!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ))
                      ],
                    ),
                    !loaded_data
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                    child: ListView.builder(
                                        itemCount: widget.cal_sub_files.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (widget.app_user.email ==
                                              widget.sub_year.username!.email) {
                                            return build_screen(index);
                                          } else if (widget.sub_year.private!) {
                                            if (widget.cal_sub_files[index]
                                                        .username!.email ==
                                                    widget.app_user.email ||
                                                widget.cal_sub_files[index]
                                                        .username!.email ==
                                                    widget.sub_year.username!
                                                        .email) {
                                              return build_screen(index);
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return build_screen(index);
                                          }
                                          //return Container();
                                        }))
                              ],
                            ),
                          )
                  ])))),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          if (widget.app_user.email == "guest@nitc.ac.in") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Guests are not allowed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            ),
                            const SizedBox(height: 10),
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? image1 = await _picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 35);
                                  //final bytes = await File(image1!.path).readAsBytes();
                                  setState(() {
                                    file = File(image1!.path);
                                    file_type = "1";
                                    //final img.Image image = img.decodeImage(bytes)!;
                                  });
                                  Navigator.pop(context);
                                  uploading();
                                },
                                icon: const Icon(Icons.photo_library_outlined,
                                    size: 20)),
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final image1 = await _picker.pickVideo(
                                    source: ImageSource.gallery,
                                  );

                                  //final bytes = await File(image1!.path).readAsBytes();
                                  setState(() {
                                    file = File(image1!.path);
                                    file_type = "2";
                                    //final img.Image image = img.decodeImage(bytes)!;
                                  });
                                  Navigator.pop(context);
                                  uploading();
                                },
                                icon: const Icon(
                                  Icons.video_collection_outlined,
                                  size: 20,
                                )),
                            IconButton(
                                onPressed: () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );

                                  setState(() {
                                    file = File(result!.paths.first ?? '');
                                    file_type = "3";
                                    //final img.Image image = img.decodeImage(bytes)!;
                                  });
                                  Navigator.pop(context);
                                  uploading();
                                },
                                icon: const Icon(Icons.file_copy_sharp,
                                    size: 20)),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }
        },
        label: widget.sub_year == "Placements"
            ? const Text("Add new review",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            : const Text("Add new file",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.edit, color: Colors.white),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
      ),
    );
  }

  build_screen(int index) {
    var wid = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (widget.app_user.email == "guest@nitc.ac.in") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Guests are not allowed open files",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          if (widget.cal_sub_files[index].fileType == "1") {
            print(widget.cal_sub_files[index].qnAnsFile);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => image_display(
                    widget.cal_sub_files[index].insert,
                    widget.cal_sub_files[index].file!,
                    widget.cal_sub_files[index].qnAnsFile!)));
          } else if (widget.cal_sub_files[index].fileType == "2") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => video_display4(
                    widget.cal_sub_files[index].insert,
                    widget.cal_sub_files[index].file!,
                    widget.cal_sub_files[index].qnAnsFile!)));
          } else {
            if (widget.cal_sub_files[index].insert) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      pdfviewer(widget.cal_sub_files[index].file!)));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => pdfviewer1(
                      widget.cal_sub_files[index].qnAnsFile!, false)));
            }
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          //                                          color: Colors.white70,
        ),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 7, left: 20, bottom: 7),
        child: Column(
          children: [
            Container(
              child: Text(widget.cal_sub_files[index].username!.email!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.left),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: wid / 2),
                  child: Text(
                    widget.cal_sub_files[index].fileName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                widget.cal_sub_files[index].uploaded == false
                    ? IconButton(
                        onPressed: () {},
                        icon: const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(color: Colors.white),
                        ))
                    : widget.app_user.email ==
                            widget.cal_sub_files[index].username!.email
                        ? IconButton(
                            onPressed: () async {
                              if (widget.app_user.email == "guest@nitc.ac.in") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Guests are not allowed",
                                  style: TextStyle(color: Colors.white),
                                )));
                              } else {
                                bool error = await notes_servers()
                                    .delete_sub_files_list(widget
                                        .cal_sub_files[index].id
                                        .toString());

                                if (!error) {
                                  setState(() {
                                    widget.cal_sub_files
                                        .remove(widget.cal_sub_files[index]);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                    "error occured please try again",
                                    style: TextStyle(color: Colors.white),
                                  )));
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                          )
                        : (widget.sub_year.username!.email ==
                                    widget.app_user.email &&
                                widget.sub_year.private!)
                            ? IconButton(
                                onPressed: () {
                                  void uploading1() async {
                                    widget.cal_sub_files[index].fileName =
                                        file.path.split("/").last;
                                    widget.cal_sub_files[index].uploaded =
                                        false;
                                    widget.cal_sub_files[index].insert = true;
                                    widget.cal_sub_files[index].file = file;
                                    widget.cal_sub_files[index].fileType =
                                        file_type;
                                    widget.cal_sub_files[index].qnAnsFile = "";
                                    widget.cal_sub_files[index].username =
                                        widget.cal_sub_files[index].username;
                                    List<dynamic> error = await notes_servers()
                                        .edit_cal_sub_files(
                                            widget.cal_sub_files[index]
                                                .username!.email!,
                                            widget.cal_sub_files[index].id!,
                                            file,
                                            widget.sub_year.id.toString(),
                                            file_type);
                                    if (!error[0]) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                        "edited successfully you ca go back and came again.",
                                        style: TextStyle(color: Colors.white),
                                      )));
                                      widget.cal_sub_files[index].uploaded =
                                          true;
                                      setState(() {
                                        widget.cal_sub_files[index].uploaded =
                                            true;
                                      });
                                    } else {
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                          "error occured please go back and come again.",
                                          style: TextStyle(color: Colors.white),
                                        )));
                                      });
                                    }
                                  }

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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                  const SizedBox(height: 10),
                                                  IconButton(
                                                      onPressed: () async {
                                                        final ImagePicker
                                                            _picker =
                                                            ImagePicker();
                                                        final XFile? image1 =
                                                            await _picker.pickImage(
                                                                source:
                                                                    ImageSource
                                                                        .gallery,
                                                                imageQuality:
                                                                    35);
                                                        //final bytes = await File(image1!.path).readAsBytes();
                                                        setState(() {
                                                          file = File(
                                                              image1!.path);
                                                          file_type = "1";
                                                          //final img.Image image = img.decodeImage(bytes)!;
                                                        });
                                                        Navigator.pop(context);
                                                        uploading1();
                                                      },
                                                      icon: const Icon(
                                                          Icons
                                                              .photo_library_outlined,
                                                          size: 20)),
                                                  IconButton(
                                                      onPressed: () async {
                                                        final ImagePicker
                                                            _picker =
                                                            ImagePicker();
                                                        final image1 =
                                                            await _picker
                                                                .pickVideo(
                                                          source: ImageSource
                                                              .gallery,
                                                        );

                                                        //final bytes = await File(image1!.path).readAsBytes();
                                                        setState(() {
                                                          file = File(
                                                              image1!.path);
                                                          file_type = "2";
                                                          //final img.Image image = img.decodeImage(bytes)!;
                                                        });
                                                        Navigator.pop(context);
                                                        uploading1();
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .video_collection_outlined,
                                                        size: 20,
                                                      )),
                                                  IconButton(
                                                      onPressed: () async {
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
                                                          file = File(result!
                                                                  .paths
                                                                  .first ??
                                                              '');
                                                          file_type = "3";
                                                          //final img.Image image = img.decodeImage(bytes)!;
                                                        });
                                                        Navigator.pop(context);
                                                        uploading1();
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
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.file_copy,
                                  color: Colors.white,
                                ),
                              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
