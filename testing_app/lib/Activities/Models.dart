import 'package:testing_app/User_profile/models.dart';
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
  Username? username;
  double? imgRatio;
  bool? allUniversities;

  String? event_category;
  ALL_CLUBS? club_event;
  ALL_SPORTS? sport_event;
  ALL_FESTS? fest_event;
  SAC_MEMS? sac_event;

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
      this.event_category,
      this.club_event,
      this.sport_event,
      this.fest_event,
      this.sac_event});

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
        ? new Username.fromJson(json['username'])
        : null;
    imgRatio = json['img_ratio'];
    allUniversities = json['all_universities'];

    event_category = json['event_category'];
    club_event = json['club_event'] != null
        ? new ALL_CLUBS.fromJson(json['club_event'])
        : null;
    sport_event = json['sport_event'] != null
        ? new ALL_SPORTS.fromJson(json['sport_event'])
        : null;
    fest_event = json['fest_event'] != null
        ? new ALL_FESTS.fromJson(json['fest_event'])
        : null;
    sac_event = json['sac_event'] != null
        ? new SAC_MEMS.fromJson(json['sac_event'])
        : null;
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

    data['event_category'] = this.event_category;
    if (this.club_event != null) {
      data['club_event'] = this.club_event!.toJson();
    }
    if (this.sport_event != null) {
      data['sport_event'] = this.sport_event!.toJson();
    }
    if (this.fest_event != null) {
      data['fest_event'] = this.fest_event!.toJson();
    }
    if (this.sac_event != null) {
      data['sac_event'] = this.sac_event!.toJson();
    }

    return data;
  }
}
