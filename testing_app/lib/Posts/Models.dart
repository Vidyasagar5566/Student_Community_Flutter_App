import 'package:testing_app/User_profile/Models.dart';
import 'package:testing_app/SAC/Models.dart';
import 'package:testing_app/All_clubs/Models.dart';
import 'package:testing_app/All_sports/Models.dart';
import 'package:testing_app/All_fests/Models.dart';

class POST_LIST {
  int? id;
  String? title;
  String? description;
  String? img;
  String? profilePic;
  String? tag;
  bool? isLike;
  int? likeCount;
  int? commentCount;
  String? postedDate;
  String? eventDate;
  SmallUsername? username;
  double? imgRatio;
  bool? allUniversities;

  String? post_category;
  ALL_CLUBS? club_post;
  ALL_SPORTS? sport_post;
  ALL_FESTS? fest_post;
  SAC_MEMS? sac_post;

  POST_LIST(
      {this.id,
      this.title,
      this.description,
      this.img,
      this.profilePic,
      this.tag,
      this.isLike,
      this.likeCount,
      this.commentCount,
      this.postedDate,
      this.eventDate,
      this.username,
      this.imgRatio,
      this.allUniversities,
      this.post_category,
      this.club_post,
      this.sport_post,
      this.fest_post,
      this.sac_post});

  POST_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    img = json['img'];
    profilePic = json['profile_pic'];
    tag = json['tag'];
    isLike = json['is_like'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    postedDate = json['posted_date'];
    eventDate = json['event_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    imgRatio = json['img_ratio'];
    allUniversities = json['all_universities'];

    post_category = json['post_category'];
    club_post = json['club_post'] != null
        ? new ALL_CLUBS.fromJson(json['club_post'])
        : null;
    sport_post = json['sport_post'] != null
        ? new ALL_SPORTS.fromJson(json['sport_post'])
        : null;
    fest_post = json['fest_post'] != null
        ? new ALL_FESTS.fromJson(json['fest_post'])
        : null;
    sac_post = json['sac_post'] != null
        ? new SAC_MEMS.fromJson(json['sac_post'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['img'] = this.img;
    data['profile_pic'] = this.profilePic;
    data['tag'] = this.tag;
    data['is_like'] = this.isLike;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['posted_date'] = this.postedDate;
    data['event_date'] = this.eventDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    data['img_ratio'] = this.imgRatio;
    data['all_universities'] = this.allUniversities;

    data['post_category'] = this.post_category;
    if (this.club_post != null) {
      data['club_post'] = this.club_post!.toJson();
    }
    if (this.sport_post != null) {
      data['sport_post'] = this.sport_post!.toJson();
    }
    if (this.fest_post != null) {
      data['fest_post'] = this.fest_post!.toJson();
    }
    if (this.sac_post != null) {
      data['sac_post'] = this.sac_post!.toJson();
    }
    return data;
  }
}

class PST_CMNT {
  int? id;
  String? comment;
  String? postedDate;
  int? postId;
  SmallUsername? username;
  bool? insertMessage = false;
  bool? messageSent = true;

  PST_CMNT(
      {this.id,
      this.comment,
      this.postedDate,
      this.postId,
      this.username,
      this.insertMessage,
      this.messageSent});

  PST_CMNT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['Comment'];
    postedDate = json['posted_date'];
    postId = json['post_id'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Comment'] = this.comment;
    data['posted_date'] = this.postedDate;
    data['post_id'] = this.postId;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}
