import 'package:flutter/material.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/Fcm_Notif_Domains/servers.dart';

star_user_mark(Username app_user) {
  if (app_user.userMark != "St" || app_user.starMark != 0) {
    return;
  }
  //instabook
  else if (app_user.clzClubsHead! ||
      app_user.clzFestsHead! ||
      app_user.clzSacsHead! ||
      app_user.clzSportsHead!) {
    app_user.starMark = 4;
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
    return widget.star_mark == 4
        ? const Icon(
            Icons.verified_rounded,
            color: Colors.green,
            size: 18,
          )
        : widget.star_mark == 3
            ? const Icon(
                Icons.verified_rounded,
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

class UserProfileMark extends StatefulWidget {
  SmallUsername profile_use;
  UserProfileMark(this.profile_use);

  @override
  State<UserProfileMark> createState() => _UserProfileMarkState();
}

class _UserProfileMarkState extends State<UserProfileMark> {
  @override
  Widget build(BuildContext context) {
    SmallUsername user = widget.profile_use;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: (width - 36) / 1.8,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
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
            userMarkNotation(4) //post.username!.starMark!)
          ],
        ),
        Text(
          //"B190838EC",
          domains[user.domain!]! + " (" + user.userMark! + ")",
          overflow: TextOverflow.ellipsis,
          //lst_list.username.rollNum,
          //style: const TextStyle(color: Colors.white),
          maxLines: 1,
        ),
      ]),
    );
  }
}

class UserProfileMarkAdmin extends StatefulWidget {
  SmallUsername profile_use;
  UserProfileMarkAdmin(this.profile_use);

  @override
  State<UserProfileMarkAdmin> createState() => _UserProfileMarkAdminState();
}

class _UserProfileMarkAdminState extends State<UserProfileMarkAdmin> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    SmallUsername user = widget.profile_use;
    return Container(
      padding: EdgeInsets.only(left: 20),
      width: (width - 36) / 1.8,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
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
            userMarkNotation(4) //post.username!.starMark!)
          ],
        ),
        Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: (width - 36) / 2.4),
              child: Text(
                'From ' + user.username!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                //"Vidya Sagar",
                //lst_list[index].username,
                style: const TextStyle(
                  fontSize: 15,
                  //color: Colors.white
                ),
              ),
            ),
            const SizedBox(width: 10),
            userMarkNotation(4) //post.username!.starMark!)
          ],
        ),
        Text(
          //"B190838EC",
          domains[user.domain!]! + " (" + user.userMark! + ")",
          overflow: TextOverflow.ellipsis,
          //lst_list.username.rollNum,
          //style: const TextStyle(color: Colors.white),
          maxLines: 1,
        ),
      ]),
    );
  }
}
