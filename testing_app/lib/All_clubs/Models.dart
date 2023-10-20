import 'package:testing_app/User_profile/Models.dart';

class ALL_CLUBS {
  int? id;
  String? name;
  String? logo;
  String? title;
  String? teamMembers;
  String? description;
  String? websites;
  String? dateOfJoin;
  bool? isLike;
  int? likeCount;
  String? domain;
  int? starMark;
  SmallUsername? head;

  int? post_count;
  int? thread_count;
  int? activity_count;

  ALL_CLUBS(
      {this.id,
      this.name,
      this.logo,
      this.title,
      this.teamMembers,
      this.description,
      this.websites,
      this.dateOfJoin,
      this.isLike,
      this.likeCount,
      this.domain,
      this.starMark,
      this.head,
      this.post_count,
      this.thread_count,
      this.activity_count});

  ALL_CLUBS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    title = json['title'];
    teamMembers = json['team_members'];
    description = json['description'];
    websites = json['websites'];
    dateOfJoin = json['date_of_join'];
    isLike = json['is_like'];
    likeCount = json['like_count'];
    domain = json['domain'];
    starMark = json['star_mark'];
    head =
        json['head'] != null ? new SmallUsername.fromJson(json['head']) : null;

    post_count = json['post_count'];
    thread_count = json['thread_count'];
    activity_count = json['activity_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['title'] = this.title;
    data['team_members'] = this.teamMembers;
    data['description'] = this.description;
    data['websites'] = this.websites;
    data['date_of_join'] = this.dateOfJoin;
    data['is_like'] = this.isLike;
    data['like_count'] = this.likeCount;
    data['domain'] = this.domain;
    data['star_mark'] = this.starMark;
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }

    data['post_count'] = this.post_count;
    data['thread_count'] = this.thread_count;
    data['activity_count'] = this.activity_count;
    return data;
  }
}
