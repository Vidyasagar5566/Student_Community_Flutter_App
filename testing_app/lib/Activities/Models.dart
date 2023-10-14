import 'package:testing_app/User_profile/models.dart';

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
      this.allUniversities});

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
    return data;
  }
}