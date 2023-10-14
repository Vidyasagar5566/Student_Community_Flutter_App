import 'package:flutter/material.dart';
import '../Posts/post.dart';
import '../circular_designs/cure_clip.dart';
import 'Servers.dart';
import 'Models.dart';
import '/Posts/Models.dart';
import '/Posts/Servers.dart';
import '/servers/servers.dart';
import '/first_page.dart';
import 'Edit_profile.dart';
//import 'package:link_text/link_text.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show utf8;
import 'package:video_player/video_player.dart';
import '/Files_disply_download/pdf_videos_images.dart';
import 'package:get_time_ago/get_time_ago.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class profilewidget extends StatefulWidget {
  Username app_user;
  profilewidget(this.app_user);

  @override
  State<profilewidget> createState() => _profilewidgetState();
}

class _profilewidgetState extends State<profilewidget> {
  @override
  Widget build(BuildContext context) {
    Username app_user = widget.app_user;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Container(
              color: Colors.indigo,
              //height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipPath(
                          clipper: profile_Clipper(),
                          child: Container(
                            height: 160,
                            width: double.infinity,
                          )),
                      Positioned(
                          bottom: 10,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                        contentPadding: EdgeInsets.all(15),
                                        content: SingleChildScrollView(
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                      SizedBox(height: 6),
                                                      Container(
                                                        height: width,
                                                        width: width,
                                                        child: app_user
                                                                    .fileType! ==
                                                                "1"
                                                            ? Image.network(
                                                                app_user
                                                                    .profilePic!)
                                                            : Image.asset(
                                                                "images/profile.jpg"),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      app_user.fileType == '1'
                                                          ? Column(
                                                              children: [
                                                                const Center(
                                                                    child: Text(
                                                                        "Delete your profile pic?",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold))),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          30),
                                                                  color: Colors
                                                                          .blue[
                                                                      900],
                                                                  child: OutlinedButton(
                                                                      onPressed: () async {
                                                                        bool
                                                                            error =
                                                                            await user_profile_servers().delete_profile_pic();
                                                                        if (!error) {
                                                                          Navigator.of(context).pushAndRemoveUntil(
                                                                              MaterialPageRoute(builder: (BuildContext context) => get_ueser_widget(1)),
                                                                              (Route<dynamic> route) => false);
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Text(
                                                                                "error occured ,plz try again",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                      child: const Center(
                                                                          child: Text(
                                                                        "Delete",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ))),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                      app_user.isSuperuser ==
                                                              false
                                                          ? Center(
                                                              child: Container(
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => editprofile(widget.app_user)));
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "edit your profile",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16),
                                                                        )),
                                                              ),
                                                            )
                                                          : Container(),
                                                      const SizedBox(
                                                          height: 10),
                                                      (app_user.adminRole! ==
                                                                  "club" ||
                                                              app_user.adminRole! ==
                                                                  "sport" ||
                                                              app_user.adminRole! ==
                                                                  "fest")
                                                          ? Center(
                                                              child: Container(
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (app_user.adminRole! ==
                                                                              "club") {
                                                                            //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => edit_club(widget.app_user, app_user.adminRole!)));
                                                                            // } else {
                                                                            //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => edit_sport(widget.app_user)));
                                                                          }
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "edit your club/sport details",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16),
                                                                        )),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ]))));
                                  });
                            },
                            child: Container(
                                child: CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Colors.white,
                                    child: app_user.fileType! == '1'
                                        ? CircleAvatar(
                                            radius: 60,
                                            backgroundImage:
                                                //post.profile_pic
                                                NetworkImage(
                                                    app_user.profilePic!))
                                        : const CircleAvatar(
                                            radius: 60,
                                            backgroundImage:
                                                //post.profile_pic
                                                AssetImage(
                                                    "images/profile.jpg")))),
                          ))
                    ],
                  ),
                  Text(
                    app_user.username!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    app_user.email!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    app_user.rollNum!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.white),
                  ),
                ],
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(8),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your posts",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class user_postswidget extends StatefulWidget {
  String username;
  Username app_user;
  user_postswidget(this.username, this.app_user);
  // const user_postswidget({super.key});

  @override
  State<user_postswidget> createState() => _user_postswidgetState();
}

class _user_postswidgetState extends State<user_postswidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<POST_LIST>>(
      future: user_profile_servers().get_user_post_list(widget.username),
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
            if (post_list.isEmpty) {
              return Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  child: const Text("No posts yet",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.white)));
            } else {
              user_posts = post_list;
              return user_postwidget1(post_list, widget.app_user);
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.grey),
        );
      },
    );
  }
}

class user_postwidget1 extends StatefulWidget {
  List<POST_LIST> post_list;
  Username app_user;
  user_postwidget1(this.post_list, this.app_user);

  @override
  State<user_postwidget1> createState() => _user_postwidget1State();
}

class _user_postwidget1State extends State<user_postwidget1> {
  @override
  Widget build(BuildContext context) {
    List<POST_LIST> post_list = widget.post_list;
    return ListView.builder(
        itemCount: post_list.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 10),
        itemBuilder: (BuildContext context, int index) {
          POST_LIST post = user_posts[index];

          var _convertedTimestamp = DateTime.parse(
              post.postedDate!); // Converting into [DateTime] object
          String post_posted_date = GetTimeAgo.parse(_convertedTimestamp);
          return single_post(
              post, widget.post_list, widget.app_user, post_posted_date);
        });
  }
}

class single_post extends StatefulWidget {
  POST_LIST post;
  List<POST_LIST> post_list;
  Username app_user;
  String post_posted_date;
  single_post(this.post, this.post_list, this.app_user, this.post_posted_date);

  @override
  State<single_post> createState() => _single_postState();
}

class _single_postState extends State<single_post> {
  bool _showController = true;
  VideoPlayerController? _videoPlayerController;

  void initState() {
    super.initState();
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

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
    List<POST_LIST> post_list = widget.post_list;
    String delete_error = "";
    bool full_text = false;
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
              Row(
                children: [
                  Container(
                    width: 48, //post.profile_pic
                    child: user.fileType == '1'
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic!))
                        : const CircleAvatar(
                            backgroundImage: AssetImage("images/profile.jpg")),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: (width - 36) / 1.8,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: (width - 36) / 2.4),
                                child: Text(
                                  user.username!,
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
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContex) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(15),
                          content: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4),
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
                                  user.username == widget.app_user.username
                                      ? Column(
                                          children: [
                                            const Center(
                                                child: Text(
                                                    "Do you want to delete this?",
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
                                                    Navigator.pop(context);
                                                    bool error =
                                                        await post_servers()
                                                            .delete_post(
                                                                post.id!);
                                                    user_posts.remove(post);

                                                    if (!error) {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                        return firstpage(
                                                          2,
                                                          widget.app_user,
                                                        );
                                                      }),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    } else {
                                                      //post_list.add(post);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Failed",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: const Center(
                                                      child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        )
                                      : Container(),
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
                                  const SizedBox(height: 10),
                                  //Link
                                  Text(
                                    //"Description about the post",
                                    utf8convert(post.description!),
                                    //style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 15),
                                  post.imgRatio == 1
                                      ? Container(
                                          height: width,
                                          width: width,
                                          child: Image.network(post.img!),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.more_horiz,
                  size: 31,
                  color: Colors.black,
                ),
              )
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
            height: 3,
          ),
          Text(
            utf8convert(post.description!),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
              onDoubleTap: () {
                setState(() async {
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
                });
              },
              onTap: () {
                if (post.imgRatio == 2) {
                  _videoPlayerController!.play();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return video_display3(post.img!, _videoPlayerController!);
                  }));
                }
              },
              child: post.imgRatio == 1
                  ? Center(
                      child: Container(
                        height: width,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(post.img!),
                                fit: BoxFit.cover)),
                        /*child: CircularProgressIndicator(
                            color: Colors.grey[400],
                            strokeWidth: 2,
                          )*/
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
                                        _videoPlayerController!.value.isPlaying
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_outline,
                                        color: Colors.blue,
                                        size: 60,
                                      ),
                                      onTap: () {
                                        _videoPlayerController!.play();
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
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return pdfviewer1(post.img!, true);
                            }));
                          },
                          child: Center(
                            child: Container(
                                height: width * (0.7),
                                width: width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage("images/Explorer.png"),
                                        fit: BoxFit.cover))),
                          )),
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
                  IconButton(
                    onPressed: () async {
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
                    },
                    icon: post.isLike!
                        ? const Icon(
                            Icons.favorite,
                            size: 30,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border_outlined,
                            size: 30,
                            color: Colors.red,
                          ),
                  ),
                  // Text(post.likes.toString() + "likes")
                  Text(
                    post.likeCount.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return commentwidget(post, widget.app_user);
                      }));
                    },
                    icon: const Icon(
                      Icons.comment_rounded,
                      //color: Colors.white70,
                      size: 30,
                    ),
                  ),
                  Text(
                    post.commentCount.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      //color: Colors.white70
                    ),
                  )
                ],
              ),
              //Container(
              //  margin: const EdgeInsets.only(right: 20),
              //  child: Transform.rotate(
              //    angle: 0,
              //    child: IconButton(
              //      onPressed: () {
              //        //Share.share(
              //        //    'hey! check out this new app https://play.google.com/store/search?q=pub%3ADivTag&c=apps');
              //      },
              //      icon: const Icon(
              //        Icons.send,
              //        size: 24,
              //     ),
              //    ),
              //  ),
              //)
            ],
          ),
        ],
      ),
    );
  }
}
