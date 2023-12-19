import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/First_page.dart';
import 'Servers.dart';
import '/User_profile/Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';

List<String> lostCategory = [
  "cards",
  "essentials",
  "smartDevices",
  "belongings",
  "clothings",
  "valuables",
  "others"
];

class lst_found_upload extends StatefulWidget {
  Username app_user;
  String tag;
  String category;
  lst_found_upload(this.app_user, this.tag, this.category);

  @override
  State<lst_found_upload> createState() => _lst_found_uploadState();
}

class _lst_found_uploadState extends State<lst_found_upload> {
  var title;
  var description;
  var image;
  var image_ratio = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: true,
          title: const Text(
            "Lost/Found",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: SingleChildScrollView(
          child: Container(
            //color: Colors.pink[100],
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
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
                    "Upload Your Lost or Found",
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tag : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                DropdownButton<String>(
                                    value: widget.tag,
                                    underline: Container(),
                                    elevation: 0,
                                    items: ["lost", "found"]
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
                                        widget.tag = value!;
                                      });
                                    }),
                              ]),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Category : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                DropdownButton<String>(
                                    value: widget.category,
                                    underline: Container(),
                                    elevation: 0,
                                    items: lostCategory
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
                                        widget.category = value!;
                                      });
                                    }),
                              ]),
                        ),
                        const SizedBox(height: 10),
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
                              hintText: 'i lost my id before atm circle.....',
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
                          "Add an image(optional)",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image1 = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 35);
                              setState(() {
                                image = File(image1!.path);
                                image_ratio = "1";
                              });
                            } else {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image1 = await _picker.pickImage(
                                  source: ImageSource.gallery, imageQuality: 5);
                              setState(() {
                                image = File(image1!.path);
                                image_ratio = "1";
                              });
                            }
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
                                    if (widget.app_user.email!.split('@')[0] ==
                                        "guest") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: Text(
                                                  "guest are not allowed to share lost/found..",
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
                                      if (image_ratio == "0") {
                                        image = File("images/background.jpg");
                                      }
                                      bool error = await lf_servers().post_lst(
                                          title,
                                          description,
                                          image,
                                          image_ratio,
                                          widget.tag,
                                          widget.category);
                                      Navigator.pop(context);
                                      if (!error) {
                                        widget.app_user.lstCount =
                                            widget.app_user.lstCount! + 1;
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                          return firstpage(0, widget.app_user);
                                        }), (Route<dynamic> route) => false);

                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        bool res = await servers()
                                            .send_notifications(
                                                widget.app_user.email!,
                                                title + " : " + description,
                                                0);
                                        if (res) {
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
                                // image_ratio,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(image))
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
