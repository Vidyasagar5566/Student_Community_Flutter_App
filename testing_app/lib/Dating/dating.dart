import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'models.dart';
import 'servers.dart';

class datingUser extends StatefulWidget {
  String domain;
  Username app_user;
  datingUser({required this.domain, required this.app_user, super.key});

  @override
  State<datingUser> createState() => _datingUserState();
}

class _datingUserState extends State<datingUser> {
  var dummyProfile;
  var dummyName;
  var dummyBio;
  String dummyDomain = "Nit Calicut";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connect"), centerTitle: false),
      body: FutureBuilder<List<DatingUser>>(
        future: dating_servers().get_dating_user_list(widget.domain),
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
              List<DatingUser> dating_list = snapshot.data;
              if (dating_list.isEmpty) {
                return Container(
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(30),
                    child: const Center(
                      child: Text(
                        "No Data Was Found",
                      ),
                    ));
              } else {
                return datingUser1(
                    dating_list: dating_list, app_user: widget.app_user);
              }
            }
          }
          return Center(
            child: Container(
                margin: EdgeInsets.all(50),
                padding: EdgeInsets.all(50),
                child: CircularProgressIndicator()),
          );
        },
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                      contentPadding: EdgeInsets.all(15),
                      content: Container(
                        margin: EdgeInsets.all(10),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                )
                              ]),
                          GestureDetector(
                            onTap: () async {
                              if (Platform.isAndroid) {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image1 = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 35);
                                setState(() {
                                  dummyProfile = File(image1!.path);
                                });
                              } else {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image1 = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 5);
                                setState(() {
                                  dummyProfile = File(image1!.path);
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 150,
                                  width: 150,
                                  decoration: dummyProfile == null
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'images/profile.jpg'),
                                              fit: BoxFit.cover))
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                  child: dummyProfile != null
                                      ? Image.file(dummyProfile)
                                      : Container(),
                                ),
                                const Positioned(
                                    left: 125,
                                    top: 125,
                                    child: Icon(Icons.add_a_photo,
                                        size: 30, color: Colors.blue))
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              initialValue: dummyName,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'name',
                                hintText: 'Rathika',
                                prefixIcon: Icon(Icons.text_fields),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  dummyName = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              initialValue: dummyBio,
                              keyboardType: TextInputType.multiline,
                              minLines:
                                  2, //Normal textInputField will be displayed
                              maxLines: 5,
                              decoration: const InputDecoration(
                                labelText: 'Bio',
                                hintText:
                                    'i want to chat with funny guys who can.....',
                                prefixIcon: Icon(Icons.text_fields),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  dummyBio = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("University"),
                                DropdownButton<String>(
                                    value: dummyDomain,
                                    underline: Container(),
                                    elevation: 0,
                                    items: domains_list_ex_all
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
                                        dummyDomain = value!;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade300,
                                    Colors.pink,
                                    Colors.orange.shade700
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                            child: OutlinedButton(
                                onPressed: () {},
                                child: const Text(
                                  "Join",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ]),
                      ));
                });
              });
        },
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("Join",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
      ),
    );
  }
}

class datingUser1 extends StatefulWidget {
  List<DatingUser> dating_list;
  Username app_user;
  datingUser1({required this.dating_list, required this.app_user, super.key});

  @override
  State<datingUser1> createState() => _datingUser1State();
}

class _datingUser1State extends State<datingUser1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.dating_list.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 10),
          scrollDirection: Axis.horizontal,
          physics: PageScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            DatingUser dating_user = widget.dating_list[index];
            return build_loading_screen(dating_user);
          }),
    );
  }

  Widget build_loading_screen(DatingUser dating_user) {
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: width,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(dating_user.dummyName!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        ),
        const SizedBox(height: 4),
        Container(
          width: width,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(domains[dating_user.dummyDomain]!,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: width,
          child: Text(dating_user.dummyBio!,
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20)),
        ),
        const SizedBox(height: 4),
        Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                    scale: 10, image: AssetImage('images/loading.png'))),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return image_display(false, File('images/icon.png'),
                      dating_user.dummyProfile!);
                }));
              },
              child: Container(
                margin: EdgeInsets.all(10),
                height: width,
                width: width - 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(dating_user.dummyProfile!),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 50,
          width: width - 70.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22)),
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade300,
                  Colors.pink,
                  Colors.orange.shade700
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
          child: OutlinedButton(
              onPressed: () {},
              child: Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Get   Contacter",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Icon(Icons.send_to_mobile_outlined,
                        color: Colors.white, size: 25)
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
