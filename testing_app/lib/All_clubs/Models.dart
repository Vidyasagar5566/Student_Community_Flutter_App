import 'package:testing_app/User_profile/Models.dart';

class CLB_SPRT_LIST {
  int? id;
  String? logo;
  String? title;
  String? clubRSport;
  String? teamMembers;
  String? description;
  String? websites;
  SmallUsername? username;
  SmallUsername? head;
  bool? isLike;
  int? likeCount;
  String? sportGround;
  String? sportGroundImage;
  double? imgRatio;
  String? domain;

  CLB_SPRT_LIST(
      {this.id,
      this.logo,
      this.title,
      this.clubRSport,
      this.teamMembers,
      this.description,
      this.websites,
      this.username,
      this.head,
      this.isLike,
      this.likeCount,
      this.sportGround,
      this.sportGroundImage,
      this.imgRatio,
      this.domain});

  CLB_SPRT_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    title = json['title'];
    clubRSport = json['club_r_sport'];
    teamMembers = json['team_members'];
    description = json['description'];
    websites = json['websites'];
    sportGround = json['sport_ground'];
    sportGroundImage = json['sport_ground_img'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    head =
        json['head'] != null ? new SmallUsername.fromJson(json['head']) : null;
    isLike = json['is_like'];
    likeCount = json['like_count'];
    imgRatio = json['img_ratio'];
    domain = json['domain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['title'] = this.title;
    data['club_r_sport'] = this.clubRSport;
    data['team_members'] = this.teamMembers;
    data['description'] = this.description;
    data['websites'] = this.websites;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    data['is_like'] = this.isLike;
    data['like_count'] = this.likeCount;
    data['img_ratio'] = this.imgRatio;
    data['domain'] = this.domain;
    return data;
  }
}
