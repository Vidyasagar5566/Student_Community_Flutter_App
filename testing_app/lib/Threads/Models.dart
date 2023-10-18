import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/SAC/Models.dart';
import 'package:testing_app/All_clubs/Models.dart';
import 'package:testing_app/All_sports/Models.dart';
import 'package:testing_app/All_fests/Models.dart';

class ALERT_LIST {
  int? id;
  String? title;
  String? description;
  String? img;
  double? imgRatio;
  int? commentCount;
  String? postedDate;
  SmallUsername? username;
  bool? allUniversities;

  String? category;
  ALL_CLUBS? club;
  ALL_SPORTS? sport;
  ALL_FESTS? fest;
  SAC_MEMS? sac;

  ALERT_LIST(
      {this.id,
      this.title,
      this.description,
      this.img,
      this.commentCount,
      this.postedDate,
      this.username,
      this.imgRatio,
      this.allUniversities,
      this.category,
      this.club,
      this.sport,
      this.fest,
      this.sac});

  ALERT_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];

    commentCount = json['comment_count'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    imgRatio = json['img_ratio'];
    img = json['img'];
    allUniversities = json['all_universities'];

    category = json['category'];
    club = json['club'] != null ? new ALL_CLUBS.fromJson(json['club']) : null;
    sport =
        json['sport'] != null ? new ALL_SPORTS.fromJson(json['sport']) : null;
    fest = json['fest'] != null ? new ALL_FESTS.fromJson(json['fest']) : null;
    sac = json['sac'] != null ? new SAC_MEMS.fromJson(json['sac']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;

    data['comment_count'] = this.commentCount;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    data['img_ratio'] = this.imgRatio;
    data['img'] = this.img;
    data['all_universities'] = this.allUniversities;

    data['category'] = this.category;
    if (this.club != null) {
      data['club'] = this.club!.toJson();
    }
    if (this.sport != null) {
      data['sport'] = this.sport!.toJson();
    }
    if (this.fest != null) {
      data['fest'] = this.fest!.toJson();
    }
    if (this.sac != null) {
      data['sac'] = this.sac!.toJson();
    }
    return data;
  }
}

class ALERT_CMNT {
  int? id;
  String? alertId;
  String? comment;
  String? postedDate;
  int? alertCmntId;
  String? img;
  double? imgRatio;
  SmallUsername? username;
  bool? insertMessage = false;
  bool? messageSent = true;

  ALERT_CMNT(
      {this.id,
      this.alertId,
      this.comment,
      this.postedDate,
      this.alertCmntId,
      this.username,
      this.insertMessage,
      this.messageSent,
      this.img,
      this.imgRatio});

  ALERT_CMNT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alertId = json['alert_id'];
    comment = json['Comment'];
    postedDate = json['posted_date'];
    alertCmntId = json['alert_cmnt_id'];
    imgRatio = json['img_ratio'];
    img = json['img'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alert_id'] = this.alertId;
    data['Comment'] = this.comment;
    data['posted_date'] = this.postedDate;
    data['alert_cmnt_id'] = this.alertCmntId;
    data['img_ratio'] = this.imgRatio;
    data['img'] = this.img;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}
