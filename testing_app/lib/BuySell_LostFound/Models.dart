import '/User_profile/Models.dart';

class Lost_Found {
  int? id;
  String? title;
  String? description;
  String? img;
  int? commentCount;
  String? postedDate;
  SmallUsername? username;
  double? imgRatio;
  String? tag;

  Lost_Found(
      {this.id,
      this.title,
      this.description,
      this.img,
      this.commentCount,
      this.postedDate,
      this.username,
      this.imgRatio,
      this.tag});

  Lost_Found.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    img = json['img'];
    commentCount = json['comment_count'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    imgRatio = json['img_ratio'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['img'] = this.img;
    data['comment_count'] = this.commentCount;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    data['img_ratio'] = this.imgRatio;
    data['tag'] = this.tag;
    return data;
  }
}

class LST_CMNT {
  int? id;
  String? lstId;
  String? comment;
  String? postedDate;
  int? lstCmntId;
  SmallUsername? username;
  bool? insertMessage = false;
  bool? messageSent = true;
  bool? loaded = true;

  LST_CMNT(
      {this.id,
      this.lstId,
      this.comment,
      this.postedDate,
      this.lstCmntId,
      this.username,
      this.insertMessage,
      this.messageSent,
      this.loaded});

  LST_CMNT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lstId = json['lst_id'];
    comment = json['Comment'];
    postedDate = json['posted_date'];
    lstCmntId = json['lst_cmnt_id'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lst_id'] = this.lstId;
    data['Comment'] = this.comment;
    data['posted_date'] = this.postedDate;
    data['lst_cmnt_id'] = this.lstCmntId;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}
