import 'package:flutter/material.dart';
import '/User_profile/Models.dart';
import '/Fcm_Notif_Domains/Servers.dart';
import '/User_profile/Profile.dart';
import '/Login/Servers.dart';
import '/All_clubs/Club_page.dart';
import '/All_fests/Fest_page.dart';
import '/All_sports/Sport_page.dart';
import '/SAC/Sac.dart';

star_user_mark(Username app_user) {
  if (app_user.userMark != "St" || app_user.starMark != 0) {
    return;
  }
  //instabook
  else if (app_user.clzClubsHead! ||
      app_user.clzFestsHead! ||
      app_user.clzSacsHead! ||
      app_user.clzSportsHead!) {
    app_user.starMark = 8;
    app_user.userMark = "InstaBookUser";
  }
  //Faculty
  else if (app_user.isFaculty!) {
    app_user.starMark = 3;
    app_user.userMark = "Faculty";
  }
  //heads
  else if (app_user.clzClubs!['head'].isNotEmpty) {
    app_user.starMark = 2;
    app_user.userMark = "ClubAdmin";
  } else if (app_user.clzFests!['head'].isNotEmpty) {
    app_user.starMark = 2;
    app_user.userMark = "FestAdmin";
  } else if (app_user.clzSacs!['head'].isNotEmpty) {
    app_user.starMark = 2;
    app_user.userMark = "SacAdmin";
  } else if (app_user.clzSports!['head'].isNotEmpty) {
    app_user.starMark = 2;
    app_user.userMark = "SportAdmin";
  }
  //team_members
  else if (app_user.clzClubs!['team_member'].isNotEmpty) {
    app_user.starMark = 1;
    app_user.userMark = "ClubMember";
  } else if (app_user.clzFests!['team_member'].isNotEmpty) {
    app_user.starMark = 1;
    app_user.userMark = "FestMember";
  } else if (app_user.clzSacs!['team_member'].isNotEmpty) {
    app_user.starMark = 1;
    app_user.userMark = "SacMember";
  } else if (app_user.clzSports!['team_member'].isNotEmpty) {
    app_user.starMark = 1;
    app_user.userMark = "SportMember";
  }
  //student
  else {
    app_user.starMark = 0;
    app_user.userMark = "St";
  }
}

class userMarkNotation extends StatefulWidget {
  int star_mark;
  userMarkNotation(this.star_mark);

  @override
  State<userMarkNotation> createState() => _userMarkNotationState();
}

class _userMarkNotationState extends State<userMarkNotation> {
  @override
  Widget build(BuildContext context) {
    return widget.star_mark == 8
        ? const Icon(
            Icons.verified_rounded,
            color: Colors.orange,
            size: 18,
          )
        : widget.star_mark == 7
            ? const Icon(
                Icons.verified_outlined,
                color: Colors.orange,
                size: 18,
              )
            : widget.star_mark == 6
                ? const Icon(
                    Icons.verified_rounded,
                    color: Colors.green,
                    size: 18,
                  )
                : widget.star_mark == 5
                    ? const Icon(
                        Icons.verified_outlined,
                        color: Colors.green,
                        size: 18,
                      )
                    : widget.star_mark == 4
                        ? const Icon(
                            Icons.verified_rounded,
                            color: Colors.red,
                            size: 18,
                          )
                        : widget.star_mark == 3
                            ? const Icon(
                                Icons.verified_outlined,
                                color: Colors.red,
                                size: 18,
                              )
                            : widget.star_mark == 2
                                ? const Icon(
                                    Icons.verified_rounded,
                                    color: Colors.blue,
                                    size: 18,
                                  )
                                : widget.star_mark == 1
                                    ? const Icon(
                                        Icons.verified_outlined,
                                        color: Colors.blue,
                                        size: 18,
                                      )
                                    : Container();
  }
}

class smallUserMarkNotation extends StatefulWidget {
  int star_mark;
  smallUserMarkNotation(this.star_mark);

  @override
  State<smallUserMarkNotation> createState() => _smallUserMarkNotationState();
}

class _smallUserMarkNotationState extends State<smallUserMarkNotation> {
  @override
  Widget build(BuildContext context) {
    return widget.star_mark == 8
        ? const Icon(
            Icons.verified_rounded,
            color: Colors.orange,
            size: 12,
          )
        : widget.star_mark == 7
            ? const Icon(
                Icons.verified_outlined,
                color: Colors.orange,
                size: 12,
              )
            : widget.star_mark == 6
                ? const Icon(
                    Icons.verified_rounded,
                    color: Colors.green,
                    size: 12,
                  )
                : widget.star_mark == 5
                    ? const Icon(
                        Icons.verified_outlined,
                        color: Colors.green,
                        size: 12,
                      )
                    : widget.star_mark == 4
                        ? const Icon(
                            Icons.verified_rounded,
                            color: Colors.red,
                            size: 12,
                          )
                        : widget.star_mark == 3
                            ? const Icon(
                                Icons.verified_outlined,
                                color: Colors.red,
                                size: 12,
                              )
                            : widget.star_mark == 2
                                ? const Icon(
                                    Icons.verified_rounded,
                                    color: Colors.blue,
                                    size: 12,
                                  )
                                : widget.star_mark == 1
                                    ? const Icon(
                                        Icons.verified_outlined,
                                        color: Colors.blue,
                                        size: 12,
                                      )
                                    : Container();
  }
}

class UserProfileMark extends StatefulWidget {
  Username app_user;
  SmallUsername profile_user;
  UserProfileMark(this.app_user, this.profile_user);

  @override
  State<UserProfileMark> createState() => _UserProfileMarkState();
}

class _UserProfileMarkState extends State<UserProfileMark> {
  @override
  Widget build(BuildContext context) {
    SmallUsername user = widget.profile_user;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        if (widget.app_user.email != widget.profile_user.email) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Container(
                      margin: EdgeInsets.all(10),
                      child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Please wait while loading....."),
                            SizedBox(height: 10),
                            CircularProgressIndicator()
                          ]),
                    ));
              });
          Username all_profile_user =
              await login_servers().get_user(widget.profile_user.email!);
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: userProfilePage(widget.app_user, all_profile_user));
          }));
        }
      },
      child: Row(
        children: [
          Container(
            width: 50, //post.profile_pic
            child: user.fileType == '1'
                ? CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic!)))
                : const CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                        backgroundImage: AssetImage("images/profile.jpg"))),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            width: (width - 36) / 1.8,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
                    child: Text(
                      user.username!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  userMarkNotation(user.starMark!)
                ],
              ),
              Text(
                domains[user.domain!]! + " (" + user.userMark! + ")",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class smallUserProfileMark extends StatefulWidget {
  Username app_user;
  SmallUsername profile_user;
  smallUserProfileMark(this.app_user, this.profile_user);

  @override
  State<smallUserProfileMark> createState() => _smallUserProfileMarkState();
}

class _smallUserProfileMarkState extends State<smallUserProfileMark> {
  @override
  Widget build(BuildContext context) {
    SmallUsername user = widget.profile_user;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        if (widget.app_user.email != widget.profile_user.email) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Container(
                      margin: EdgeInsets.all(10),
                      child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Please wait while loading....."),
                            SizedBox(height: 10),
                            CircularProgressIndicator()
                          ]),
                    ));
              });
          Username all_profile_user =
              await login_servers().get_user(widget.profile_user.email!);
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: userProfilePage(widget.app_user, all_profile_user));
          }));
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Container(
              width: 25, //post.profile_pic
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
                          constraints:
                              BoxConstraints(maxWidth: (width - 36) / 2.4),
                          child: Text(
                            user.username!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        smallUserMarkNotation(user.starMark!)
                      ],
                    ),
                    Text(
                      domains[user.domain!]! + " (" + user.userMark! + ")",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileMarkAdmin extends StatefulWidget {
  var post;
  var user;
  Username app_user;
  UserProfileMarkAdmin(this.post, this.user, this.app_user);

  @override
  State<UserProfileMarkAdmin> createState() => _UserProfileMarkAdminState();
}

class _UserProfileMarkAdminState extends State<UserProfileMarkAdmin> {
  @override
  Widget build(BuildContext context) {
    var category;
    var width = MediaQuery.of(context).size.width;
    if (widget.post.category == 'club') {
      category = widget.post.club!;
    } else if (widget.post.category == 'fest') {
      category = widget.post.fest!;
    } else if (widget.post.category == 'sport') {
      category = widget.post.sport!;
    } else if (widget.post.category == 'sac') {
      category = widget.post.sac!;
    }
    return GestureDetector(
      onTap: () async {
        if (widget.app_user.email != widget.user.email) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Container(
                      margin: EdgeInsets.all(10),
                      child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Please wait while loading....."),
                            SizedBox(height: 10),
                            CircularProgressIndicator()
                          ]),
                    ));
              });
          Username all_profile_user =
              await login_servers().get_user(widget.user.email!);
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: userProfilePage(widget.app_user, all_profile_user));
          }));
        }
      },
      child: Row(
        children: [
          Container(
              width: 50, //post.profile_pic
              child:
                  CircleAvatar(backgroundImage: NetworkImage(category.logo!))),
          Container(
            padding: EdgeInsets.only(left: 20),
            width: (width - 36) / 1.8,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
                    child: Text(
                      category.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  userMarkNotation(category.starMark!)
                ],
              ),
              Text(
                domains[widget.user.domain!]! +
                    " (" +
                    widget.post.category! +
                    ")",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
                    child: Text(
                      'From ' + widget.user.username!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        //color: Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  userMarkNotation(widget.user.starMark!)
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class UserMarkAdmin extends StatefulWidget {
  var category_post;
  var category;
  Username app_user;
  UserMarkAdmin(this.category_post, this.category, this.app_user);

  @override
  State<UserMarkAdmin> createState() => _UserMarkAdminState();
}

class _UserMarkAdminState extends State<UserMarkAdmin> {
  @override
  Widget build(BuildContext context) {
    var category;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        if (widget.category == 'club') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: clubpagewidget(widget.category_post, widget.app_user));
          }));
        } else if (widget.category == 'fest') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: festpagewidget(widget.category_post, widget.app_user));
          }));
        } else if (widget.category == 'sport') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: sportpagewidget(widget.category_post, widget.app_user));
          }));
        } else if (widget.category == 'sac') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
                body: sacProfilePage(widget.app_user, widget.category_post, 0));
          }));
        }
      },
      child: Row(
        children: [
          Container(
            width: 48,
            child: CircleAvatar(
                backgroundImage: NetworkImage(widget.category_post.logo!)),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            width: (width - 36) / 1.8,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
                    child: Text(
                      widget.category_post.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  userMarkNotation(widget.category_post.starMark!)
                ],
              ),
              Text(
                domains[widget.category_post.domain!]! +
                    " (" +
                    widget.category_post.title! +
                    ") ",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
                    child: Text(
                      'From ' + widget.category_post.head.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        //color: Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  userMarkNotation(widget.category_post.head.starMark!)
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
