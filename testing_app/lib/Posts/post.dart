import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Servers.dart';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';
//import 'package:link_text/link_text.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'package:video_player/video_player.dart';
import '../Files_disply_download/pdf_videos_images.dart';
import '/First_page.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:testing_app/Reports/Uploads.dart';
import 'package:testing_app/User_Star_Mark/User_Profile_Star_Mark.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class postwidget extends StatefulWidget {
  Username app_user;
  String domain;
  postwidget(this.app_user, this.domain);

  @override
  State<postwidget> createState() => _postwidgetState();
}

class _postwidgetState extends State<postwidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<POST_LIST>>(
      future: post_servers().get_post_list(domains1[widget.domain]!, 0),
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
            List<POST_LIST> post_list = snapshot.data;
            if (post_list.length == 0) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Center(
                    child: Text(
                      "No Data Was Found",
                    ),
                  ));
            } else {
              all_posts = post_list;
              return postwidget1(post_list, widget.app_user, widget.domain);
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
    );
  }
}

class PostWithappBar extends StatefulWidget {
  Username app_user;
  String domain;
  PostWithappBar(this.app_user, this.domain);
  @override
  State<PostWithappBar> createState() => _PostWithappBarState();
}

class _PostWithappBarState extends State<PostWithappBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(widget.domain, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.indigoAccent[700],
        ),
        body: FutureBuilder<List<POST_LIST>>(
          future: post_servers().get_post_list(domains1[widget.domain]!, 0),
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
                List<POST_LIST> post_list = snapshot.data;
                if (post_list.length == 0) {
                  return Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(30),
                      child: const Center(
                        child: Text("No posts yet",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24)),
                      ));
                } else {
                  all_posts = post_list;
                  return postwidget1(post_list, widget.app_user, widget.domain);
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
        ));
  }
}

class postwidget1 extends StatefulWidget {
  List<POST_LIST> post_list;
  Username app_user;
  String domain;
  postwidget1(this.post_list, this.app_user, this.domain);

  @override
  State<postwidget1> createState() => _postwidget1State();
}

class _postwidget1State extends State<postwidget1> {
  bool total_loaded = true;
  void load_data_fun() async {
    List<POST_LIST> latest_post_list = await post_servers()
        .get_post_list(domains1[widget.domain]!, all_posts.length);
    if (latest_post_list.length != 0) {
      all_posts += latest_post_list;
      setState(() {
        widget.post_list = all_posts;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("all the feed was shown..",
              style: TextStyle(color: Colors.white))));
    }
    setState(() {
      total_loaded = true;
    });
  }

  var _scrollController = ScrollController();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                itemCount: widget.post_list.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 10),
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  POST_LIST post = widget.post_list[index];
                  var _convertedTimestamp = DateTime.parse(
                      post.postedDate!); // Converting into [DateTime] object
                  String post_posted_date =
                      GetTimeAgo.parse(_convertedTimestamp);
                  return single_post(post, widget.app_user, widget.domain,
                      widget.post_list, post_posted_date, index);
                }),
            const SizedBox(height: 10),
            total_loaded
                ? Container(
                    width: width,
                    height: 100,
                    child: Center(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                total_loaded = false;
                              });
                              load_data_fun();
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    size: 40, color: Colors.blue),
                                Text(
                                  "Tap To Load more",
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ))))
                : Container(
                    width: 100,
                    height: 100,
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}

class single_post extends StatefulWidget {
  POST_LIST post;
  Username app_user;
  String domain;
  List<POST_LIST> post_list;
  String post_posted_date;
  int index;
  single_post(this.post, this.app_user, this.domain, this.post_list,
      this.post_posted_date, this.index);

  @override
  State<single_post> createState() => _single_postState();
}

class _single_postState extends State<single_post> {
  bool _showController = true;
  VideoPlayerController? _videoPlayerController;
  bool image_loaded = false;

  void initState() {
    super.initState();

    if (widget.post.imgRatio == 2) {
      _videoPlayerController = VideoPlayerController.network(widget.post.img!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      _videoPlayerController!.initialize().then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    POST_LIST post = widget.post;
    SmallUsername user = post.username!;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              post.category == 'student'
                  ? UserProfileMark(widget.app_user, post.username!)
                  : UserProfileMarkAdmin(post, post.username, widget.app_user),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          content: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Close"))
                                    ],
                                  ),
                                  const Center(
                                      child: Text("Post details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.blue))),
                                  const SizedBox(height: 20),
                                  Center(
                                      child: Text(user.email!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  Center(
                                      child: Text(widget.post_posted_date,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 4),
                                  Text(
                                    //"Description about the post",
                                    utf8convert(post.description!),
                                    //style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 15),
                                  post.imgRatio == 1
                                      ? Container(
                                          height: width,
                                          width: width,
                                          child: Image.network(post.img!),
                                        )
                                      : Container(),
                                  const SizedBox(height: 10),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return report_upload(
                                              widget.app_user,
                                              "post" +
                                                  " with id: " +
                                                  post.id.toString(),
                                              post.username!.email!);
                                        }));
                                      },
                                      child: const Text("Report this post?")),
                                  TextButton(
                                      onPressed: () async {
                                        if (widget.app_user.email ==
                                            "guest@nitc.ac.in") {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "guest cannot hide contents..",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))));
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    content: Container(
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Text(
                                                                "Please wait while updating....."),
                                                            SizedBox(
                                                                height: 10),
                                                            CircularProgressIndicator()
                                                          ]),
                                                    ));
                                              });
                                          bool error = await post_servers()
                                              .hide_post(post.id!);
                                          Navigator.pop(context);
                                          if (!error) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return firstpage(
                                                  0, widget.app_user);
                                            }),
                                                    (Route<dynamic> route) =>
                                                        false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'This post will no longer in your feed',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ));
                                          } else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'error occured try again',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                          "Hide these type of content?")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return report_upload(
                                              widget.app_user,
                                              "User: " +
                                                  post.username!.email
                                                      .toString(),
                                              post.username!.email!);
                                        }));
                                      },
                                      child: const Text("Report This User?")),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.more_horiz,
                  //color: Colors.white70,
                  size: 30,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
            height: 5,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              utf8convert(post.description!),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              maxLines: post.imgRatio == 0 ? 12 : 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: post.imgRatio == 1
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                        scale: 10, image: AssetImage('images/loading.png')))
                : BoxDecoration(),
            child: GestureDetector(
              onDoubleTap: () async {
                if (widget.app_user.email == "guest@nitc.ac.in") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("guests are not allowed to like..",
                          style: TextStyle(color: Colors.white))));
                } else {
                  setState(() {
                    post.isLike = !post.isLike!;
                    SystemSound.play(SystemSoundType.click);
                  });
                  if (post.isLike!) {
                    setState(() {
                      post.likeCount = post.likeCount! + 1;
                    });
                    bool error = await post_servers().post_post_like(post.id!);
                    if (error) {
                      setState(() {
                        post.likeCount = post.likeCount! - 1;
                        post.isLike = !post.isLike!;
                      });
                    }
                  } else {
                    setState(() {
                      post.likeCount = post.likeCount! - 1;
                    });
                    bool error =
                        await post_servers().delete_post_like(post.id!);
                    if (error) {
                      setState(() {
                        post.likeCount = post.likeCount! + 1;
                        post.isLike = !post.isLike!;
                      });
                    }
                  }
                }
              },
              onTap: () {
                if (post.imgRatio == 2) {
                  _videoPlayerController!.play();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return video_display3(post.img!, _videoPlayerController!);
                  }));
                }
                if (post.imgRatio == 1) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return image_display(
                        false, File('images/icon.png'), post.img!);
                  }));
                }
                if (post.imgRatio == 3) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return pdfviewer1(post.img!, true);
                  }));
                }
              },
              child: post.imgRatio == 0
                  ? Container()
                  : post.imgRatio == 1
                      ? Center(
                          child: Container(
                            height: width,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: NetworkImage(post.img!),
                                    fit: BoxFit.cover)),
                          ),
                        )
                      : post.imgRatio == 2
                          ? AspectRatio(
                              aspectRatio:
                                  _videoPlayerController!.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  VideoPlayer(_videoPlayerController!),
                                  ClosedCaption(text: null),
                                  _showController == true
                                      ? Center(
                                          child: InkWell(
                                          child: Icon(
                                            _videoPlayerController!
                                                    .value.isPlaying
                                                ? Icons.pause_circle_outline
                                                : Icons.play_circle_outline,
                                            color: Colors.blue,
                                            size: 60,
                                          ),
                                          onTap: () {
                                            _videoPlayerController!.play();
                                            print("video ready to play");
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return video_display3(post.img!,
                                                  _videoPlayerController!);
                                            }));
                                          },
                                        ))
                                      : Container(),
                                  // Here you can also add Overlay capacities
                                  VideoProgressIndicator(
                                    _videoPlayerController!,
                                    allowScrubbing: true,
                                    padding: EdgeInsets.all(3),
                                    colors: const VideoProgressColors(
                                      backgroundColor: Colors.black,
                                      playedColor: Colors.white,
                                      bufferedColor: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Container(
                                  height: width * (0.7),
                                  width: width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                          image:
                                              AssetImage("images/Explorer.png"),
                                          fit: BoxFit.cover))),
                            ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () async {
                      if (widget.app_user.email == "guest@nitc.ac.in") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "guests are not allowed to like..",
                                    style: TextStyle(color: Colors.white))));
                      } else {
                        setState(() {
                          post.isLike = !post.isLike!;
                          SystemSound.play(SystemSoundType.click);
                        });
                        if (post.isLike!) {
                          setState(() {
                            post.likeCount = post.likeCount! + 1;
                          });
                          bool error =
                              await post_servers().post_post_like(post.id!);
                          if (error) {
                            setState(() {
                              post.likeCount = post.likeCount! - 1;
                              post.isLike = !post.isLike!;
                            });
                          }
                        } else {
                          setState(() {
                            post.likeCount = post.likeCount! - 1;
                          });
                          bool error =
                              await post_servers().delete_post_like(post.id!);
                          if (error) {
                            setState(() {
                              post.likeCount = post.likeCount! + 1;
                              post.isLike = !post.isLike!;
                            });
                          }
                        }
                      }
                    },
                    icon: post.isLike!
                        ? const FaIcon(
                            FontAwesomeIcons.solidThumbsUp,
                            size: 25,
                            color: Colors.green,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.thumbsUp,
                            size: 25,
                            color: Colors.green,
                          ),
                  ),
                  Text(
                    post.likeCount.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return commentwidget(post, widget.app_user);
                        }));
                      },
                      icon: const FaIcon(FontAwesomeIcons.comment, size: 25)),
                  Text(
                    post.commentCount.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      //color: Colors.white70
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.share, size: 23)),
                ],
              ),
//              Container(
//                margin: const EdgeInsets.only(right: 20),
//                child: Transform.rotate(
//                  angle: 0,
//                  child: IconButton(
//                    onPressed: () {
//                      //Share.share(
//                      //    'hey! check out this new app https://play.google.com/store/search?q=pub%3ADivTag&c=apps');
//                    },
//                    icon: const Icon(
//                      Icons.send,
//                      size: 24,
//                    ),
//                  ),
//                ),
//              )
            ],
          ),
        ],
      ),
    );
  }
}

class commentwidget extends StatefulWidget {
  POST_LIST post;
  Username app_user;
  commentwidget(this.post, this.app_user);

  @override
  State<commentwidget> createState() => _commentwidgetState();
}

class _commentwidgetState extends State<commentwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.blue, // <-- SEE HERE
          ),
          title: const Text(
            "comments",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
        ),
        body: FutureBuilder<List<PST_CMNT>>(
          future: post_servers().get_post_cmnt_list(widget.post.id!),
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
                List<PST_CMNT> pst_cmnt_list = snapshot.data;
                return commentwidget1(
                    pst_cmnt_list, widget.app_user, widget.post);
              }
            }
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ));
  }
}

class commentwidget1 extends StatefulWidget {
  List<PST_CMNT> pst_cmnt_list;
  Username app_user;
  POST_LIST post;
  commentwidget1(this.pst_cmnt_list, this.app_user, this.post);

  @override
  State<commentwidget1> createState() => _commentwidget1State();
}

class _commentwidget1State extends State<commentwidget1> {
  var comment;
  bool sending_cmnt = false;
  @override
  Widget build(BuildContext context) {
    List<PST_CMNT> pst_cmnt_list = widget.pst_cmnt_list;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              reverse: true,
              child: ListView.builder(
                  itemCount: widget.pst_cmnt_list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 10),
                  itemBuilder: (BuildContext context, int index) {
                    PST_CMNT pst_cmnt = pst_cmnt_list[index];
                    return _buildLoadingScreen(pst_cmnt);
                  }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.only(right: 12),
              margin: const EdgeInsets.all(20),
              width: width,
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: width * 0.70,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1, //Normal textInputField will be displayed
                      maxLines: 2,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'comment',
                        hintText: 'add comment',
                        prefixIcon: Icon(Icons.text_fields),
                        border: InputBorder.none,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          comment = value;
                          if (comment == "") {
                            comment = null;
                          }
                        });
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'please enter email' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 2),
                  (comment == null && sending_cmnt == false)
                      ? Container(
                          child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.double_arrow,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ))
                      : (comment != null)
                          ? Container(
                              child: IconButton(
                                onPressed: () async {
                                  if (widget.app_user.email ==
                                      "guest@nitc.ac.in") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "guest cannot share comments..",
                                                style: TextStyle(
                                                    color: Colors.white))));
                                  } else {
                                    PST_CMNT a = PST_CMNT();
                                    String curr_comment = comment;
                                    a.username = user_min(widget.app_user);
                                    a.comment = curr_comment;
                                    a.postId = widget.post.id;
                                    a.postedDate = "";
                                    a.insertMessage = true;
                                    a.messageSent = false;
                                    pst_cmnt_list.add(a);
                                    setState(() {
                                      comment = null;
                                      sending_cmnt = true;
                                    });
                                    List<dynamic> error = await post_servers()
                                        .post_post_cmnt(
                                            curr_comment, widget.post.id!);
                                    setState(() {
                                      sending_cmnt = false;
                                    });

                                    if (!error[0]) {
                                      setState(() {
                                        a.id = error[1];
                                        a.messageSent = true;
                                      });
                                      await Future.delayed(
                                          Duration(seconds: 2));

                                      bool error1 = await servers()
                                          .send_notifications(
                                              widget.app_user.email!,
                                              " Commented on " +
                                                  " : " +
                                                  widget.post.description! +
                                                  " : " +
                                                  comment,
                                              5);
                                      if (error1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Failed to send notifications",
                                                    style: TextStyle(
                                                        color: Colors.white))));
                                      }
                                    } else {
                                      pst_cmnt_list.remove(a);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.double_arrow,
                                    size: 38, color: Colors.blue),
                              ),
                            )
                          : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(
    PST_CMNT pst_cmnt,
  ) {
    String delete_error = "";
    SmallUsername user = pst_cmnt.username!;
    return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const Icon(
                Icons.person_2_outlined,
                size: 31,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                user.email!,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
              const SizedBox(
                width: 50,
              ),
              (!pst_cmnt.messageSent!)
                  ? const SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(color: Colors.blue))
                  : (user.email == widget.app_user.email)
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.all(15),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(Icons.close))
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          const Center(
                                              child: Text(
                                                  "Are you sure do you want to delete this?",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          const SizedBox(height: 10),
                                          Container(
                                            margin: const EdgeInsets.all(30),
                                            color: Colors.blue[900],
                                            child: OutlinedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.pst_cmnt_list
                                                        .remove(pst_cmnt);
                                                    Navigator.pop(context);
                                                  });
                                                  bool error =
                                                      await post_servers()
                                                          .delete_post_cmnt(
                                                              pst_cmnt.id!,
                                                              widget.post.id!);
                                                  if (error) {
                                                    setState(() {
                                                      widget.pst_cmnt_list
                                                          .add(pst_cmnt);
                                                    });
                                                  }
                                                },
                                                child: const Center(
                                                    child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 31,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : Container()
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            child: Row(
              children: [
                const Text(
                  "Comment : ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(pst_cmnt.insertMessage!
                          ? pst_cmnt.comment!
                          : utf8convert(pst_cmnt.comment!)
                      //   "This is the ultimate opportunity for us to experience the thrill of competition and spirit of camaraderie"
                      ),
                ),
              ],
            ),
          )
        ]));
  }
}
