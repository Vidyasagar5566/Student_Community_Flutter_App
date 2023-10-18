import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/SAC/Models.dart';
import 'package:testing_app/All_clubs/Models.dart';
import 'package:testing_app/All_sports/Models.dart';
import 'package:testing_app/All_fests/Models.dart';

class EVENT_LIST {
  int? id;
  String? title;
  String? description;
  String? eventImg;
  String? eventVedio;
  bool? isLike;
  int? likeCount;
  String? postedDate;
  String? eventUpdate;
  SmallUsername? username;
  double? imgRatio;
  bool? allUniversities;

  String? category;
  ALL_CLUBS? club;
  ALL_SPORTS? sport;
  ALL_FESTS? fest;
  SAC_MEMS? sac;

  EVENT_LIST(
      {this.id,
      this.title,
      this.description,
      this.eventImg,
      this.eventVedio,
      this.isLike,
      this.likeCount,
      this.postedDate,
      this.eventUpdate,
      this.username,
      this.imgRatio,
      this.allUniversities,
      this.category,
      this.club,
      this.sport,
      this.fest,
      this.sac});

  EVENT_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    eventImg = json['event_img'];
    eventVedio = json['event_vedio'];
    isLike = json['is_like'];
    likeCount = json['like_count'];
    eventUpdate = json['event_updates'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    imgRatio = json['img_ratio'];
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
    data['event_img'] = this.eventImg;
    data['event_vedio'] = this.eventVedio;
    data['is_like'] = this.isLike;
    data['like_count'] = this.likeCount;
    data['posted_date'] = this.postedDate;
    data['event_updates'] = this.eventUpdate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    data['img_ratio'] = this.imgRatio;
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
