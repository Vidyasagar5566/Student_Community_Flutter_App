import 'package:flutter/material.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '/First_page.dart';
import '/Register_Update/Register.dart';

class editprofile extends StatefulWidget {
  Username app_user;
  editprofile(this.app_user);

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  var profile_image;

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
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Edit Your Profile",
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
                            initialValue: widget.app_user.username,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'username',
                              hintText: widget.app_user.username,
                              prefixIcon: Icon(Icons.text_fields),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.app_user.username = value;
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
                            maxLines: 4,
                            minLines: 2,
                            initialValue: widget.app_user.bio,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'bio',
                              hintText: 'I am working as a br and ...',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.app_user.bio = value;
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
                            initialValue: widget.app_user.phnNum,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'contact number',
                              hintText: widget.app_user.phnNum,
                              prefixIcon: Icon(Icons.text_fields),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                if (value.length == 10) {
                                  widget.app_user.phnNum = value;
                                } else {
                                  widget.app_user.phnNum = "";
                                }
                              });
                            },
                            validator: (value) {
                              if (value!.length > 10) {
                                return 'please enter 10 digit number';
                              } else {
                                return value.isEmpty
                                    ? 'please enter number'
                                    : null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            initialValue: widget.app_user.batch,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Section',
                              hintText:
                                  'MEC2 or A or L etc..(plz write just exact batch name)',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                widget.app_user.batch = value;
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
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Course",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 20),
                                DropdownButton<String>(
                                    value: widget.app_user.course,
                                    underline: Container(),
                                    elevation: 0,
                                    items: courses
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                        widget.app_user.course = value!;
                                        widget.app_user.year = 1;
                                      });
                                    }),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Year",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 20),
                                DropdownButton<int>(
                                    value: widget.app_user.year,
                                    underline: Container(),
                                    elevation: 0,
                                    items: (widget.app_user.course == "B.Tech"
                                            ? years
                                            : widget.app_user.course == "M.Tech"
                                                ? years1
                                                : widget.app_user.course == "PG"
                                                    ? years1
                                                    : widget.app_user.course ==
                                                            "Phd"
                                                        ? years2
                                                        : widget.app_user
                                                                    .course ==
                                                                "MBA"
                                                            ? years1
                                                            : years2)
                                        .map<DropdownMenuItem<int>>(
                                            (int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.app_user.year = value!;
                                      });
                                    }),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Branch",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 20),
                                DropdownButton<String>(
                                    value: widget.app_user.branch,
                                    underline: Container(),
                                    elevation: 0,
                                    items: branches
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                        widget.app_user.branch = value!;
                                      });
                                    }),
                              ],
                            ),
                          ]),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Add new profile",
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
                                source: ImageSource.gallery, imageQuality: 12);
                            setState(() {
                              profile_image = File(image1!.path);
                              widget.app_user.fileType = "2";
                            });
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            height: width,
                            width: width,
                            child: widget.app_user.fileType == '1'
                                ? Image(
                                    image: NetworkImage(
                                        widget.app_user.profilePic!))
                                : widget.app_user.fileType == '0'
                                    ? const Image(
                                        image: AssetImage("images/profile.jpg"))
                                    : Image(image: FileImage(profile_image))),
                        const SizedBox(height: 10),
                        (widget.app_user.username != "" &&
                                widget.app_user.phnNum != "" &&
                                widget.app_user.bio != '' &&
                                widget.app_user.batch != '')
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
                                        "guest") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "guest cannot update profile section..",
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                    } else {
                                      if (widget.app_user.fileType == '0' ||
                                          widget.app_user.fileType == '1') {
                                        profile_image =
                                            File("images/profile.jpg");
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

                                      bool error = await user_profile_servers()
                                          .edit_profile2(
                                              widget.app_user.username!,
                                              widget.app_user.phnNum!,
                                              profile_image,
                                              widget.app_user.fileType!,
                                              widget.app_user.course!,
                                              widget.app_user.branch!,
                                              widget.app_user.year!,
                                              widget.app_user.bio!,
                                              widget.app_user.batch!);
                                      Navigator.pop(context);
                                      if (!error) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return get_ueser_widget(4);
                                        }), (Route<dynamic> route) => false);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration:
                                                Duration(milliseconds: 2000),
                                            content: Text(
                                              "Failed/May be the username was already taken/check your connection",
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
                                    "Update",
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
                                        duration: Duration(milliseconds: 1500),
                                        content: Text(
                                          "Username cant be null and phone number must be exactly 10 digits",
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
          ),
        ));
  }
}
