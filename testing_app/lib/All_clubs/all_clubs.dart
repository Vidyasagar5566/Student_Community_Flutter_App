import 'package:flutter/material.dart';
import 'club_page.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import '/servers/servers.dart';
import 'Servers.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/first_page.dart';
import 'package:testing_app/Reports/Uploads.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class clubpagewidget extends StatefulWidget {
  Username app_user;
  String club_fest;
  String domain;
  clubpagewidget(this.app_user, this.club_fest, this.domain);

  @override
  State<clubpagewidget> createState() => _clubpagewidgetState();
}

class _clubpagewidgetState extends State<clubpagewidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          centerTitle: false,
          title: widget.club_fest == "club"
              ? const Text(
                  "CLUBS PAGE",
                  style: TextStyle(color: Colors.black),
                )
              : const Text(
                  "FESTS PAGE",
                  style: TextStyle(color: Colors.black),
                ),
          actions: [
            DropdownButton<String>(
                value: widget.domain,
                underline: Container(),
                elevation: 0,
                items:
                    domains_list.map<DropdownMenuItem<String>>((String value) {
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
                    widget.domain = value!;
                  });
                })
          ],
          backgroundColor: Colors.white70,
        ),
        body: FutureBuilder<List<CLB_SPRT_LIST>>(
          future: all_clubs_servers()
              .get_club_sprt_list(widget.club_fest, domains1[widget.domain]!),
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
                List<CLB_SPRT_LIST> clb_sprt_list = snapshot.data;
                if (clb_sprt_list.isEmpty) {
                  return Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(30),
                      child: widget.club_fest == "club"
                          ? const Text("No clubs joined yet",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 24))
                          : const Text("No Fests joined yet",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 24)));
                } else {
                  return clubpagewidget1(
                      clb_sprt_list, widget.app_user, widget.club_fest);
                }
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class clubpagewidget1 extends StatefulWidget {
  List<CLB_SPRT_LIST> clb_sprt_list;
  Username app_user;
  String club_fest;
  clubpagewidget1(this.clb_sprt_list, this.app_user, this.club_fest);

  @override
  State<clubpagewidget1> createState() => _clubpagewidget1State();
}

class _clubpagewidget1State extends State<clubpagewidget1> {
  @override
  Widget build(BuildContext context) {
    List<CLB_SPRT_LIST> clb_sprt_list = widget.clb_sprt_list;
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                //image: post.post_pic,
                image: AssetImage("images/event background.jpg"),
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: ListView.builder(
              itemCount: clb_sprt_list.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                CLB_SPRT_LIST club_sport = clb_sprt_list[index];
                return _buildLoadingScreen(club_sport);
              }),
        ));
  }

  Widget _buildLoadingScreen(CLB_SPRT_LIST club_sport) {
    var width = MediaQuery.of(context).size.width;
    SmallUsername user = club_sport.username!;
    SmallUsername head = club_sport.head!;
    return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return dndpagewidget(
                    club_sport, widget.app_user, widget.club_fest);
              }));
            },
            onDoubleTap: () async {
              if (widget.app_user.email == "guest@nitc.ac.in") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("guests are not allowed to like..",
                        style: TextStyle(color: Colors.white))));
              } else {
                setState(() {
                  club_sport.isLike = !club_sport.isLike!;
                });
                if (club_sport.isLike!) {
                  setState(() {
                    club_sport.likeCount = club_sport.likeCount! + 1;
                  });
                  bool error =
                      await all_clubs_servers().post_club_sport_like(club_sport.id!);
                  if (error) {
                    setState(() {
                      club_sport.likeCount = club_sport.likeCount! - 1;
                      club_sport.isLike = !club_sport.isLike!;
                    });
                  }
                } else {
                  setState(() {
                    club_sport.likeCount = club_sport.likeCount! - 1;
                  });
                  bool error =
                      await all_clubs_servers().delete_club_sport_like(club_sport.id!);
                  if (error) {
                    setState(() {
                      club_sport.likeCount = club_sport.likeCount! + 1;
                      club_sport.isLike = !club_sport.isLike!;
                    });
                  }
                }
              }
              SystemSound.play(SystemSoundType.click);
            },
            child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(club_sport.logo!
                                              //'images/DND-clun-profile.png'
                                              )),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: (width - 36) / 1.8,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: (width - 36) / 2.4),
                                              child: Text(
                                                user.username! +
                                                    ' ' +
                                                    club_sport.title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                //"Vidya Sagar",
                                                //lst_list[index].username,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  //color: Colors.white
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            9 % 9 == 0
                                                ? const Icon(
                                                    Icons
                                                        .verified_rounded, //verified_rounded,verified_outlined
                                                    color: Colors.green,
                                                    size: 18,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        Text(
                                          //"B190838EC",
                                          domains[user.domain!]! +
                                              " (" +
                                              user.userMark! +
                                              ")",
                                          overflow: TextOverflow.ellipsis,
                                          //lst_list.username.rollNum,
                                          //style: const TextStyle(color: Colors.white),
                                          maxLines: 1,
                                        )
                                      ]),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  if (widget.app_user.username ==
                                      club_sport.username!.username) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return edit_club(
                                          widget.app_user,
                                          club_sport.title,
                                          club_sport.description,
                                          club_sport.logo,
                                          club_sport.imgRatio,
                                          club_sport.head!.email,
                                          club_sport.teamMembers,
                                          club_sport.websites,
                                          widget.club_fest);
                                    }));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Only for club admin',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return report_upload(
                                                        widget.app_user,
                                                        widget.club_fest +
                                                            " :" +
                                                            user.username!,
                                                        head.username!);
                                                  }));
                                                },
                                                child: const Text(
                                                  "Report",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.more_horiz))
                          ]),
                      const SizedBox(height: 6),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text(utf8convert(club_sport.description!),
                                //'''The Forum for Dance and Dramatics, affectionately known as DnD,is one of the foremost entities of NITC, aimed to promote the culture of dance and drama among the students.Formed in 2002''',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                                "club head : " +
                                    head.username! +
                                    ", contact : " +
                                    head.phnNum!,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                          )
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(children: [
                        IconButton(
                          onPressed: () async {
                            if (widget.app_user.email == "guest@nitc.ac.in") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "guests are not allowed to like..",
                                          style:
                                              TextStyle(color: Colors.white))));
                            } else {
                              setState(() {
                                club_sport.isLike = !club_sport.isLike!;
                              });
                              if (club_sport.isLike!) {
                                setState(() {
                                  club_sport.likeCount =
                                      club_sport.likeCount! + 1;
                                });
                                bool error = await all_clubs_servers()
                                    .post_club_sport_like(club_sport.id!);
                                if (error) {
                                  setState(() {
                                    club_sport.likeCount =
                                        club_sport.likeCount! - 1;
                                    club_sport.isLike = !club_sport.isLike!;
                                  });
                                }
                              } else {
                                setState(() {
                                  club_sport.likeCount =
                                      club_sport.likeCount! - 1;
                                });
                                bool error = await all_clubs_servers()
                                    .delete_club_sport_like(club_sport.id!);
                                if (error) {
                                  setState(() {
                                    club_sport.likeCount =
                                        club_sport.likeCount! + 1;
                                    club_sport.isLike = !club_sport.isLike!;
                                  });
                                }
                              }
                              SystemSound.play(SystemSoundType.click);
                            }
                          },
                          icon: club_sport.isLike!
                              ? const Icon(
                                  Icons.favorite,
                                  size: 28,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border_outlined,
                                  size: 28,
                                  color: Colors.red,
                                ),
                        ),
                        // Text(post.likes.toString() + "likes")
                        Text(
                          club_sport.likeCount.toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(width: 25),
                        const Text(
                          "Tap on image to see full details",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        )
                      ]),
                      const SizedBox(height: 5)
                    ]))));
  }
}

class edit_club extends StatefulWidget {
  Username app_user;
  var title;
  var description;
  var image;
  var image_ratio;
  var email;
  var team_members;
  var websites;
  String club_fest;
  edit_club(
      this.app_user,
      this.title,
      this.description,
      this.image,
      this.image_ratio,
      this.email,
      this.team_members,
      this.websites,
      this.club_fest);

  @override
  State<edit_club> createState() => _edit_clubState();
}

class _edit_clubState extends State<edit_club> {
  String image_type = "network";
  File image = File("image/profile.jpg");
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
                            initialValue: widget.email,
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
                                widget.email = value;
                                if (widget.email == "") {
                                  widget.email = null;
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
                            initialValue: widget.team_members,
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
                                widget.email != null &&
                                widget.team_members != null &&
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
                                        widget.title,
                                        widget.email,
                                        widget.team_members,
                                        widget.description,
                                        widget.websites,
                                        image_type,
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
