import 'package:testing_app/User_profile/Models.dart';

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
