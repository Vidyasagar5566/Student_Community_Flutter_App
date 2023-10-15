import 'package:flutter/material.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Servers.dart';
import '/first_page.dart';
import 'Search_bar(head_change).dart';

class edit_sport extends StatefulWidget {
  Username app_user;
  int id;
  var title;
  var description;
  var image;
  var name;
  var team_members;
  var websites;
  var image2;
  var sport_ground;
  edit_sport(
      this.app_user,
      this.id,
      this.title,
      this.description,
      this.image,
      this.name,
      this.team_members,
      this.websites,
      this.image2,
      this.sport_ground);

  @override
  State<edit_sport> createState() => _edit_sportState();
}

class _edit_sportState extends State<edit_sport> {
  String image_type = "network";
  String image2_type = "network";
  File image = File("images/profile.jpg");
  File image2 = File("images/profile.jpg");
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
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return sport_search_bar(
                        widget.app_user, widget.id, widget.app_user.domain!);
                  }));
                },
                icon: const Icon(Icons.person_add_alt_outlined,
                    color: Colors.blue, size: 28))
          ],
          backgroundColor: Colors.white70,
        ),
        body: Container(
          //color: Colors.pink[100],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Upload Your sport details",
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
                            hintText: 'technical club/inter nitc sport',
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
                            return value!.isEmpty ? 'please enter email' : null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.name,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'sport_head_email',
                            hintText: 'arun_b190725@nitc.ac.in',
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
                            return value!.isEmpty ? 'please enter email' : null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.team_members,
                          keyboardType: TextInputType.multiline,
                          minLines: 3, //Normal textInputField will be displayed
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Team members',
                            hintText:
                                'arun_b190725@nitc.ac.in#arun_b190725@nitc.ac.in#arun_b190725@nitc.ac.in',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.team_members = value;
                              if (widget.team_members == "") {
                                widget.team_members = null;
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
                          initialValue: widget.description,
                          keyboardType: TextInputType.multiline,
                          minLines: 4, //Normal textInputField will be displayed
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
                          minLines: 2, //Normal textInputField will be displayed
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
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          initialValue: widget.sport_ground,
                          keyboardType: TextInputType.multiline,
                          minLines: 4, //Normal textInputField will be displayed
                          maxLines: 10,
                          decoration: const InputDecoration(
                            labelText: 'sport ground details',
                            hintText:
                                'located at ....... Maps link -- https://google.maps.nitc-cricketground',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              widget.sport_ground = value;
                              if (widget.sport_ground == "") {
                                widget.sport_ground = null;
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
                      widget.image != null
                          ? Container(
                              height: width * 1.4, // image_ratio,
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
                      const Text(
                        "Add Ground image",
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
                            image2 = File(image1!.path);
                            image2_type = "file";
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
                      widget.image2 != null
                          ? Container(
                              height: width * 1.4, // image_ratio,
                              width: width,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: image2_type == "file"
                                  ? Image.file(image2)
                                  : Image.network(widget.image2),
                            )
                          : Container(),
                      const SizedBox(height: 10),
                      (widget.title != null &&
                              widget.description != null &&
                              widget.image != null &&
                              widget.name != null &&
                              widget.team_members != null &&
                              widget.websites != null &&
                              widget.sport_ground != null &&
                              widget.image2 != null)
                          ? Container(
                              padding: EdgeInsets.only(left: 40, right: 40),
                              margin: EdgeInsets.only(top: 8),
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
                                            contentPadding: EdgeInsets.all(15),
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
                                  bool error = await all_sports_servers()
                                      .edit_sport_list(
                                          widget.id,
                                          image,
                                          widget.title,
                                          widget.name,
                                          widget.team_members,
                                          widget.description,
                                          widget.websites,
                                          widget.sport_ground,
                                          image2,
                                          image_type,
                                          image2_type);

                                  Navigator.pop(context);
                                  if (!error) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return firstpage(0, widget.app_user);
                                    }), (Route<dynamic> route) => false);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Failed",
                                          style: TextStyle(color: Colors.white),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
