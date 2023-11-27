import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/Dating/dummyChat.dart';
import '/Fcm_Notif_Domains/servers.dart';
import '/Messanger/Models.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import '/User_profile/Models.dart';
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
  bool adding_profile = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect"),
        centerTitle: false,
        actions: [
          widget.app_user.dating_profile!
              ? Container(
                  margin: EdgeInsets.only(right: 10),
                  child: widget.app_user.fileType == '1'
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.app_user.profilePic!))
                      : const CircleAvatar(
                          backgroundImage: AssetImage("images/profile.jpg")))
              : Container()
        ],
      ),
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
      floatingActionButton: widget.app_user.dating_profile!
          ? Container()
          : ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                            contentPadding: EdgeInsets.all(15),
                            content: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          final ImagePicker _picker =
                                              ImagePicker();
                                          final XFile? image1 =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 35);
                                          setState(() {
                                            dummyProfile = File(image1!.path);
                                          });
                                        } else {
                                          final ImagePicker _picker =
                                              ImagePicker();
                                          final XFile? image1 =
                                              await _picker.pickImage(
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
                                                        BorderRadius.circular(
                                                            10),
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            'images/profile.jpg'),
                                                        fit: BoxFit.cover))
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: TextFormField(
                                        initialValue: dummyName,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                          labelText: 'name',
                                          hintText: 'Rathika',
                                          prefixIcon: Icon(Icons.text_fields),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("University"),
                                          DropdownButton<String>(
                                              value: dummyDomain,
                                              underline: Container(),
                                              elevation: 0,
                                              items: domains_list_ex_all.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style:
                                                        TextStyle(fontSize: 10),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(22)),
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
                                          onPressed: () async {
                                            setState(() {
                                              adding_profile = true;
                                            });
                                            bool error = await dating_servers()
                                                .post_dating_user(
                                                    dummyName,
                                                    dummyBio,
                                                    dummyProfile,
                                                    domains1[dummyDomain]!);
                                            Navigator.pop(context);
                                            setState(() {
                                              adding_profile = false;
                                            });
                                            if (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      content: Text(
                                                          "Error occured try again",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))));
                                            }
                                          },
                                          child: !adding_profile
                                              ? const Text(
                                                  "Join",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : const SizedBox(
                                                  height: 12,
                                                  width: 12,
                                                  child:
                                                      CircularProgressIndicator())),
                                    )
                                  ]),
                            ));
                      });
                    });
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text("Join",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
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
    return ListView.builder(
        itemCount: widget.dating_list.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 10),
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          DatingUser dating_user = widget.dating_list[index];
          return build_loading_screen(dating_user);
        });
  }

  Widget build_loading_screen(DatingUser dating_user) {
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
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
              maxLines: 2,
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
        const SizedBox(height: 2),
        const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(
            children: [
              Text('🔥', style: TextStyle(fontSize: 20)),
              Positioned(
                  left: 10,
                  top: 10,
                  child: Text("24", style: TextStyle(fontSize: 7)))
            ],
          ),
          Stack(
            children: [
              Text('🩷', style: TextStyle(fontSize: 30)),
              Positioned(
                  left: 10,
                  top: 10,
                  child: Text("24", style: TextStyle(fontSize: 7)))
            ],
          ),
          Stack(
            children: [
              Text('🥺', style: TextStyle(fontSize: 20)),
              Positioned(
                  left: 10,
                  top: 10,
                  child: Text("24", style: TextStyle(fontSize: 7)))
            ],
          ),
        ]),
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
              onPressed: () async {
                if (widget.app_user.email!.split('@')[0] == "guest") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 400),
                      content: Text("guest cannot chat with others..",
                          style: TextStyle(color: Colors.white))));
                } else {
                  ChatRoomModel? chatroomModel =
                      await getChatRoomModel(dating_user.username!);
                  if (chatroomModel != null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return DummychatRoomStream(
                          targetuser: dating_user.username!,
                          chatRoom: chatroomModel,
                          app_user: widget.app_user);
                    }));
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Get Contacter",
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

  Future<ChatRoomModel?> getChatRoomModel(SmallUsername targetuser) async {
    ChatRoomModel? chatroom1;
    List<List<bool>> all_poss = [
      [true, false],
      [false, true],
      [false, false]
    ];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("dummyChatrooms")
        .where("group", isEqualTo: false)
        .where("participants.${widget.app_user.userUuid}", isEqualTo: true)
        .where("participants.${targetuser.userUuid}", isEqualTo: true)
        .get();
    for (int i = 0; i < 3; i++) {
      if (snapshot.docs.length > 0) {
        break;
      }
      snapshot = await FirebaseFirestore.instance
          .collection("dummyChatrooms")
          .where("group", isEqualTo: false)
          .where("participants.${widget.app_user.userUuid}",
              isEqualTo: all_poss[i][0])
          .where("participants.${targetuser.userUuid}",
              isEqualTo: all_poss[i][1])
          .get();
    }

    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingchatroom =
          ChatRoomModel.FromMap(docData as Map<String, dynamic>);
      chatroom1 = existingchatroom;
    } else {
      ChatRoomModel newchatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastmessage: "",
        lastmessagetype: 0,
        lastmessageseen: false,
        lastmessagetime: DateTime.now(),
        lastmessagesender: widget.app_user.email,
        participants: {
          widget.app_user.userUuid.toString(): true,
          targetuser.userUuid.toString(): true
        },
        group: false,
      );
      await FirebaseFirestore.instance
          .collection("dummyChatrooms")
          .doc(newchatroom.chatroomid)
          .set(newchatroom.toMap());
      chatroom1 = newchatroom;
    }
    return chatroom1;
  }
}
