import 'package:flutter/material.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Servers.dart';
import '/first_page.dart';
import 'Search_bar.dart';
import 'Club_page.dart';

class edit_club extends StatefulWidget {
  Username app_user;
  int id;
  var title;
  var description;
  var image;
  var name;
  var websites;
  edit_club(this.app_user, this.id, this.title, this.description, this.image,
      this.name, this.websites);

  @override
  State<edit_club> createState() => _edit_clubState();
}

class _edit_clubState extends State<edit_club> {
  String image_type = "network";
  File image = File("image/profile.jpg");
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: Text(
            widget.app_user.username!,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return club_search_bar(widget.app_user, widget.id,
                        widget.app_user.domain!, false, false);
                  }));
                },
                icon: const Icon(Icons.transfer_within_a_station_outlined,
                    color: Colors.blue, size: 28))
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
                    "Upload Your club details",
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
                            initialValue: widget.title,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'title',
                              hintText: 'technical club',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.title = value;
                                if (widget.title == "") {
                                  widget.title = null;
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
                            initialValue: widget.name,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Club Name',
                              hintText: 'AI CLUB',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.name = value;
                                if (widget.name == "") {
                                  widget.name = null;
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
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return club_search_bar(widget.app_user, widget.id,
                                  widget.app_user.domain!, false, true);
                            })).then((value) {
                              setState(() {
                                print(value);
                              });
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(left: 40, right: 40),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Team Members : "),
                                      Container()
                                    ]),
                                const SizedBox(height: 5),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(team_mems.keys.join('#'),
                                        maxLines: 10)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            initialValue: widget.description,
                            keyboardType: TextInputType.multiline,
                            minLines:
                                4, //Normal textInputField will be displayed
                            maxLines: 10,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'about the club and other details.....',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.description = value;
                                if (widget.description == "") {
                                  widget.description = null;
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
                          child: TextFormField(
                            initialValue: widget.websites,
                            keyboardType: TextInputType.multiline,
                            minLines:
                                2, //Normal textInputField will be displayed
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'websites',
                              hintText:
                                  'https://cricket.nitc.ac.in    https://club_dnd.nitc.ac.in',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.websites = value;
                                if (widget.websites == "") {
                                  widget.websites = null;
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
                          "Add club/sport logo",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image1 = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 30);
                            //final bytes = await File(image1!.path).readAsBytes();
                            setState(() {
                              image = File(image1!.path);
                              image_type = "file";
                              //final img.Image image = img.decodeImage(bytes)!;
                            });
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        (widget.title != null &&
                                widget.description != null &&
                                widget.image != null &&
                                widget.name != null &&
                                widget.websites != null)
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
                                    bool error = await all_clubs_servers()
                                        .edit_club_list(
                                            widget.id,
                                            image,
                                            widget.title,
                                            widget.name,
                                            team_mems.keys.join("#"),
                                            widget.description,
                                            widget.websites,
                                            image_type);

                                    Navigator.pop(context);
                                    if (!error) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return firstpage(0, widget.app_user);
                                      }), (Route<dynamic> route) => false);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          
                                          duration: Duration(milliseconds: 500),
                                          content: Text(
                                            "Failed",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
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
                                        duration: Duration(milliseconds: 500),
                                        content: Text(
                                          "Anything cant be null",
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
                        widget.image != null
                            ? Container(
                                height: width, // image_ratio,
                                width: width,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: image_type == "file"
                                    ? Image.file(image)
                                    : Image.network(widget.image),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
