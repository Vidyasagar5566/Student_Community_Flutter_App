import '/User_profile/Models.dart';
import '/SAC/Models.dart';
import '/All_clubs/Models.dart';
import '/All_sports/Models.dart';
import '/All_fests/Models.dart';

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

  String? category;
  ALL_CLUBS? club;
  ALL_SPORTS? sport;
  ALL_FESTS? fest;
  SAC_MEMS? sac;

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
      this.category,
      this.club,
      this.sport,
      this.fest,
      this.sac});

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

    data['category'] = this.category;
    if (this.club != null) {
      data['club'] = this.club!.toJson();
    } else if (this.sport != null) {
      data['sport'] = this.sport!.toJson();
    } else if (this.fest != null) {
      data['fest'] = this.fest!.toJson();
    } else if (this.sac != null) {
      data['sac'] = this.sac!.toJson();
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
