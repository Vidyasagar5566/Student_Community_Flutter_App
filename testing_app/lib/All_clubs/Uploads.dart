import 'package:flutter/material.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Servers.dart';
import '/first_page.dart';

class edit_club extends StatefulWidget {
  Username app_user;
  String club_fest;
  edit_club(this.app_user, this.club_fest);

  @override
  State<edit_club> createState() => _edit_clubState();
}

class _edit_clubState extends State<edit_club> {
  var title;
  var description;
  var image;
  var email;
  var team_members;
  var websites;
  @override
  Widget build(BuildContext context) {
    String error = "Fill all the above details";
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'club_head_email',
                              hintText: 'arun_b190725@nitc.ac.in',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                email = value;
                                if (email == "") {
                                  email = null;
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
                                3, //Normal textInputField will be displayed
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
                                team_members = value;
                                if (team_members == "") {
                                  team_members = null;
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
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines:
                                2, //Normal textInputField will be displayed
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'websites',
                              hintText:
                                  'https://cricket.nitc.ac.in   https://club_dnd.nitc.ac.in',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                websites = value;
                                if (websites == "") {
                                  websites = null;
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
                        (title != null &&
                                description != null &&
                                image != null &&
                                email != null &&
                                team_members != null &&
                                websites != null)
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
                                    bool error = await all_clubs_servers().edit_club_list(
                                        image,
                                        title,
                                        email,
                                        team_members,
                                        description,
                                        websites,
                                        "file",
                                        widget.club_fest);
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
                                height: width * 1.4, // image_ratio,
                                width: width,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(image),
                              )
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
}

class edit_sport extends StatefulWidget {
  Username app_user;
  edit_sport(this.app_user);

  @override
  State<edit_sport> createState() => _edit_sportState();
}

class _edit_sportState extends State<edit_sport> {
  var title;
  var description;
  var image;
  var email;
  var team_members;
  var websites;
  var image2;
  var sport_ground;
  @override
  Widget build(BuildContext context) {
    String error = "Fill all the above details";
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
                              title = value;
                              if (title == "") {
                                title = null;
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
                              email = value;
                              if (email == "") {
                                email = null;
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
                              team_members = value;
                              if (team_members == "") {
                                team_members = null;
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
                        child: TextFormField(
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
                              websites = value;
                              if (websites == "") {
                                websites = null;
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
                              sport_ground = value;
                              if (sport_ground == "") {
                                sport_ground = null;
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
                      image != null
                          ? Container(
                              height: width * 1.4, // image_ratio,
                              width: width,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Image.file(image),
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
                      (title != null &&
                              description != null &&
                              image != null &&
                              email != null &&
                              team_members != null &&
                              websites != null &&
                              sport_ground != null &&
                              image2 != null)
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
                                  bool error = await all_clubs_servers().edit_sport_list(
                                      image,
                                      title,
                                      email,
                                      team_members,
                                      description,
                                      websites,
                                      sport_ground,
                                      image2,
                                      "file",
                                      "file");
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
                      image2 != null
                          ? Container(
                              height: width * 1.4, // image_ratio,
                              width: width,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Image.file(image2),
                            )
                          : Container(),
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
