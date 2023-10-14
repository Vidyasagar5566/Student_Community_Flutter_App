import 'dart:io';
import 'package:flutter/material.dart';

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
      this.allUniversities});

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

  ALERT_LIST(
      {this.id,
      this.title,
      this.description,
      this.img,
      this.commentCount,
      this.postedDate,
      this.username,
      this.imgRatio,
      this.allUniversities});

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

class SAC_LIST {
  String? username;
  String? email;
  String? rollNum;
  String? sacRole;
  String? phnNum;
  String? profilePic;
  String? bio;
  bool? isSac;
  bool? isAdmin;

  SAC_LIST(
      {this.username,
      this.email,
      this.rollNum,
      this.sacRole,
      this.phnNum,
      this.profilePic,
      this.bio,
      this.isSac,
      this.isAdmin});

  SAC_LIST.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    rollNum = json['roll_num'];
    sacRole = json['sac_role'];
    phnNum = json['phn_num'];
    profilePic = json['profile_pic'];
    bio = json['bio'];
    isSac = json['is_sac'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['roll_num'] = this.rollNum;
    data['sac_role'] = this.sacRole;
    data['phn_num'] = this.phnNum;
    data['profile_pic'] = this.profilePic;
    data['bio'] = this.bio;
    data['is_sac'] = this.isSac;
    data['is_admin'] = this.isAdmin;
    return data;
  }
}

class MESS_LIST {
  int? id;
  String? hostel;
  String? sun;
  String? mon;
  String? tue;
  String? wed;
  String? thu;
  String? fri;
  String? sat;

  MESS_LIST(
      {this.id,
      this.hostel,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat});

  MESS_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hostel = json['hostel'];
    sun = json['sun'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hostel'] = this.hostel;
    data['sun'] = this.sun;
    data['mon'] = this.mon;
    data['tue'] = this.tue;
    data['wed'] = this.wed;
    data['thu'] = this.thu;
    data['fri'] = this.fri;
    data['sat'] = this.sat;
    return data;
  }
}

class ACADEMIC_LIST {
  int? id;
  String? academic_name;
  String? sun;
  String? mon;
  String? tue;
  String? wed;
  String? thu;
  String? fri;
  String? sat;

  ACADEMIC_LIST(
      {this.id,
      this.academic_name,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat});

  ACADEMIC_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    academic_name = json['academic_name'];
    sun = json['sun'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['academic_name'] = this.academic_name;
    data['sun'] = this.sun;
    data['mon'] = this.mon;
    data['tue'] = this.tue;
    data['wed'] = this.wed;
    data['thu'] = this.thu;
    data['fri'] = this.fri;
    data['sat'] = this.sat;
    return data;
  }
}

class TIMETABLE_LIST {
  int? id;
  String? branch;
  String? sun;
  String? mon;
  String? tue;
  String? wed;
  String? thu;
  String? fri;
  String? sat;

  TIMETABLE_LIST(
      {this.id,
      this.branch,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat});

  TIMETABLE_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branch = json['branch_name'];
    sun = json['sun'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_name'] = this.branch;
    data['sun'] = this.sun;
    data['mon'] = this.mon;
    data['tue'] = this.tue;
    data['wed'] = this.wed;
    data['thu'] = this.thu;
    data['fri'] = this.fri;
    data['sat'] = this.sat;
    return data;
  }
}

class Notifications {
  int? id;
  String? title;
  String? description;
  String? branch;
  String? batch;
  String? year;
  String? img;
  double? imgRatio;
  String? postedDate;
  SmallUsername? username;

  Notifications(
      {this.id,
      this.title,
      this.description,
      this.branch,
      this.batch,
      this.year,
      this.img,
      this.imgRatio,
      this.postedDate,
      this.username});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    branch = json['branch'];
    batch = json['batch'];
    year = json['year'];
    img = json['img'];
    imgRatio = json['img_ratio'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['branch'] = this.branch;
    data['batch'] = this.batch;
    data['year'] = this.year;
    data['img'] = this.img;
    data['img_ratio'] = this.imgRatio;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}

class Messanger {
  int? id;
  String? messageBody;
  String? messageFile;
  String? messagFileType;
  String? messageBodyFile;
  String? messageReplyto;
  bool? messageSeen;
  String? messageDate;
  SmallUsername? messageSender;
  SmallUsername? messageReceiver;
  File? file;
  bool? insertMessage = false;
  bool? messageSent = true;
  int? index;

  Messanger(
      {this.id,
      this.messageBody,
      this.messageFile,
      this.messagFileType,
      this.messageBodyFile,
      this.messageReplyto,
      this.messageSeen,
      this.messageDate,
      this.messageSender,
      this.messageReceiver,
      this.file,
      this.insertMessage,
      this.messageSent,
      this.index});

  Messanger.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageBody = json['message_body'];
    messageFile = json['message_file'];
    messagFileType = json['messag_file_type'];
    messageBodyFile = json['message_body_file'];
    messageReplyto = json['message_replyto'];
    messageSeen = json['message_seen'];
    messageDate = json['message_date'];
    messageSender = json['message_sender'] != null
        ? SmallUsername.fromJson(json['message_sender'])
        : null;
    messageReceiver = json['message_receiver'] != null
        ? SmallUsername.fromJson(json['message_receiver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message_body'] = this.messageBody;
    data['message_file'] = this.messageFile;
    data['messag_file_type'] = this.messagFileType;
    data['message_body_file'] = this.messageBodyFile;
    data['message_replyto'] = this.messageReplyto;
    data['message_seen'] = this.messageSeen;
    data['message_date'] = this.messageDate;
    if (this.messageSender != null) {
      data['message_sender'] = this.messageSender!.toJson();
    }
    if (this.messageReceiver != null) {
      data['message_receiver'] = this.messageReceiver!.toJson();
    }
    return data;
  }
}

class CALENDER_EVENT {
  int? id;
  String? calEventType;
  String? title;
  String? description;
  String? calenderDateFile;
  String? fileType;
  String? branch;
  String? year;
  String? eventDate;
  String? postedDate;
  SmallUsername? username;
  bool? insertMessage = false;
  bool? messageSent = true;

  CALENDER_EVENT(
      {this.id,
      this.calEventType,
      this.title,
      this.description,
      this.calenderDateFile,
      this.fileType,
      this.branch,
      this.year,
      this.eventDate,
      this.postedDate,
      this.username,
      this.insertMessage,
      this.messageSent});

  CALENDER_EVENT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    calEventType = json['cal_event_type'];
    title = json['title'];
    description = json['description'];
    calenderDateFile = json['calender_date_file'];
    fileType = json['file_type'];
    branch = json['branch'];
    year = json['year'];
    eventDate = json['event_date'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cal_event_type'] = this.calEventType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['calender_date_file'] = this.calenderDateFile;
    data['file_type'] = this.fileType;
    data['branch'] = this.branch;
    data['year'] = this.year;
    data['event_date'] = this.eventDate;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}


class ALL_BRANCHES {
  int? id;
  String? course;
  String? branchName;
  String? semisters;
  String? postedDate;
  String? domain;
  SmallUsername? username;

  ALL_BRANCHES(
      {this.id,
      this.course,
      this.branchName,
      this.semisters,
      this.postedDate,
      this.domain,
      this.username});

  ALL_BRANCHES.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    branchName = json['branch_name'];
    semisters = json['semisters'];
    postedDate = json['posted_date'];
    domain = json['domain'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course'] = this.course;
    data['branch_name'] = this.branchName;
    data['semisters'] = this.semisters;
    data['posted_date'] = this.postedDate;
    data['domain'] = this.domain;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}
class CAL_SUB_NAMES {
  int? id;
  String? subName;
  String? subId;
  String? allYears = "";
  String? description;
  String? postedDate;
  int? totRatingsVal;
  int? numRatings;
  SmallUsername? username;

  CAL_SUB_NAMES(
      {this.id,
      this.subName,
      this.subId,
      this.allYears,
      this.description,
      this.postedDate,
      this.totRatingsVal,
      this.numRatings,
      this.username});

  CAL_SUB_NAMES.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subName = json['sub_name'];
    subId = json['sub_id'];
    allYears = json['all_years'];
    description = json['description'];
    postedDate = json['posted_date'];
    totRatingsVal = json['tot_ratings_val'];
    numRatings = json['num_ratings'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_name'] = this.subName;
    data['sub_id'] = this.subId;
    data['all_years'] = this.allYears;
    data['description'] = this.description;
    data['posted_date'] = this.postedDate;
    data['tot_ratings_val'] = this.totRatingsVal;
    data['num_ratings'] = this.numRatings;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}

class CAL_SUB_YEARS {
  int? id;
  int? subName;
  bool? private;
  String? yearName;
  String? description;
  String? postedDate;
  SmallUsername? username;

  CAL_SUB_YEARS(
      {this.id,
      this.subName,
      this.private,
      this.yearName,
      this.description,
      this.postedDate,
      this.username});

  CAL_SUB_YEARS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subName = json['sub_name'];
    private = json['private'];
    yearName = json['year_name'];
    description = json['description'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_name'] = this.subName;
    data['private'] = this.private;
    data['year_name'] = this.yearName;
    data['description'] = this.description;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}

class CAL_SUB_FILES {
  int? id;
  String? description;
  String? qnAnsFile;
  String? fileType;
  String? fileName;
  String? year;
  String? postedDate;
  SmallUsername? username;
  int? yearId;
  bool insert = false;
  File? file = File("images/icon.png");
  bool uploaded = true;

  CAL_SUB_FILES(
      {this.id,
      this.description,
      this.qnAnsFile,
      this.fileType,
      this.fileName,
      this.year,
      this.postedDate,
      this.username,
      this.yearId});

  CAL_SUB_FILES.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    qnAnsFile = json['qn_ans_file'];
    fileType = json['file_type'];
    fileName = json['file_name'];
    year = json['year'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    yearId = json['year_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['qn_ans_file'] = this.qnAnsFile;
    data['file_type'] = this.fileType;
    data['file_name'] = this.fileName;
    data['year'] = this.year;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    data['year_id'] = this.yearId;
    return data;
  }
}

class RATINGS {
  int? id;
  int? subName;
  bool? verified;
  int? rating;
  String? postedDate;
  String? description;
  SmallUsername? username;

  RATINGS(
      {this.id,
      this.subName,
      this.verified,
      this.rating,
      this.postedDate,
      this.description,
      this.username});

  RATINGS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subName = json['sub_name'];
    verified = json['verified'];
    rating = json['rating'];
    postedDate = json['posted_date'];
    description = json['description'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_name'] = this.subName;
    data['verified'] = this.verified;
    data['rating'] = this.rating;
    data['posted_date'] = this.postedDate;
    data['description'] = this.description;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}

class Username {
  int? id;
  String? password;
  bool? isSuperuser;
  String? firstName;
  String? lastName;
  bool? isStaff;
  bool? isActive;
  String? dateJoined;
  String? email;
  String? username;
  String? password1;
  String? rollNum;
  String? phnNum;
  String? profilePic;
  String? fileType;
  String? bio;
  var skills;
  String? course;
  String? branch;
  String? batch;
  int? year;
  String? dateOfBirth;
  bool? isInstabook;
  bool? isFaculty;
  bool? isAdmin;
  bool? isStudentAdmin;
  String? instabookRole;
  String? facultyRole;
  String? adminRole;
  String? studentAdminRole;
  String? userMark;
  int? starMark;
  int? highPostCount;
  int? highLstCount;
  bool? notifSeen;
  int? notifCount;
  String? notifIds;
  String? notifSettings;
  String? token;
  String? platform;
  String? domain;
  bool? isDetails;

  Username(
      {this.id,
      this.password,
      this.isSuperuser,
      this.firstName,
      this.lastName,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.email,
      this.username,
      this.password1,
      this.rollNum,
      this.phnNum,
      this.profilePic,
      this.fileType,
      this.bio,
      this.skills,
      this.course,
      this.branch,
      this.batch,
      this.year,
      this.dateOfBirth,
      this.isInstabook,
      this.isFaculty,
      this.isAdmin,
      this.isStudentAdmin,
      this.instabookRole,
      this.facultyRole,
      this.adminRole,
      this.studentAdminRole,
      this.userMark,
      this.starMark,
      this.highPostCount,
      this.highLstCount,
      this.notifSeen,
      this.notifCount,
      this.notifIds,
      this.notifSettings,
      this.token,
      this.platform,
      this.domain,
      this.isDetails});

  Username.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    isSuperuser = json['is_superuser'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    email = json['email'];
    username = json['username'];
    password1 = json['password1'];
    rollNum = json['roll_num'];
    phnNum = json['phn_num'];
    profilePic = json['profile_pic'];
    fileType = json['file_type'];
    bio = json['bio'];
    skills = json['skills'];
    course = json['course'];
    branch = json['branch'];
    batch = json['batch'];
    year = json['year'];
    dateOfBirth = json['date_of_birth'];
    isInstabook = json['is_instabook'];
    isFaculty = json['is_faculty'];
    isAdmin = json['is_admin'];
    isStudentAdmin = json['is_student_admin'];
    instabookRole = json['instabook_role'];
    facultyRole = json['faculty_role'];
    adminRole = json['admin_role'];
    studentAdminRole = json['student_admin_role'];
    userMark = json['user_mark'];
    starMark = json['star_mark'];
    highPostCount = json['high_post_count'];
    highLstCount = json['high_lst_count'];
    notifSeen = json['notif_seen'];
    notifCount = json['notif_count'];
    notifIds = json['notif_ids'];
    notifSettings = json['notif_settings'];
    token = json['token'];
    platform = json['platform'];
    domain = json['domain'];
    isDetails = json['is_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['is_superuser'] = this.isSuperuser;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password1'] = this.password1;
    data['roll_num'] = this.rollNum;
    data['phn_num'] = this.phnNum;
    data['profile_pic'] = this.profilePic;
    data['file_type'] = this.fileType;
    data['bio'] = this.bio;
    data['skills'] = this.skills;
    data['course'] = this.course;
    data['branch'] = this.branch;
    data['batch'] = this.batch;
    data['year'] = this.year;
    data['date_of_birth'] = this.dateOfBirth;
    data['is_instabook'] = this.isInstabook;
    data['is_faculty'] = this.isFaculty;
    data['is_admin'] = this.isAdmin;
    data['is_student_admin'] = this.isStudentAdmin;
    data['instabook_role'] = this.instabookRole;
    data['faculty_role'] = this.facultyRole;
    data['admin_role'] = this.adminRole;
    data['student_admin_role'] = this.studentAdminRole;
    data['user_mark'] = this.userMark;
    data['star_mark'] = this.starMark;
    data['high_post_count'] = this.highPostCount;
    data['high_lst_count'] = this.highLstCount;
    data['notif_seen'] = this.notifSeen;
    data['notif_count'] = this.notifCount;
    data['notif_ids'] = this.notifIds;
    data['notif_settings'] = this.notifSettings;
    data['token'] = this.token;
    data['platform'] = this.platform;
    data['domain'] = this.domain;
    data['is_details'] = this.isDetails;
    return data;
  }
}

class SmallUsername {
  String? username;
  String? domain;
  String? email;
  String? rollNum;
  String? profilePic;
  String? fileType;
  String? phnNum;
  bool? isStudentAdmin;
  String? userMark;
  int? starMark;

  SmallUsername(
      {this.username,
      this.domain,
      this.email,
      this.rollNum,
      this.profilePic,
      this.phnNum,
      this.fileType,
      this.isStudentAdmin,
      this.userMark,
      this.starMark});

  SmallUsername.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    domain = json['domain'];
    email = json['email'];
    rollNum = json['roll_num'];
    profilePic = json['profile_pic'];
    phnNum = json['phn_num'];
    fileType = json['file_type'];
    isStudentAdmin = json['is_student_admin'];
    userMark = json['user_mark'];
    starMark = json['star_mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['domain'] = this.domain;
    data['email'] = this.email;
    data['roll_num'] = this.rollNum;
    data['profile_pic'] = this.profilePic;
    data['phn_num'] = this.phnNum;
    data['file_type'] = this.fileType;
    data['is_student_admin'] = this.isStudentAdmin;
    data['user_mark'] = this.userMark;
    data['star_mark'] = this.starMark;
    return data;
  }
}

SmallUsername user_min(Username app_user) {
  SmallUsername min_user = SmallUsername();
  min_user.username = app_user.username;
  min_user.domain = app_user.domain;
  min_user.email = app_user.email;
  min_user.rollNum = app_user.rollNum;
  min_user.profilePic = app_user.profilePic;
  min_user.fileType = app_user.fileType;
  min_user.phnNum = app_user.phnNum;
  min_user.isStudentAdmin = app_user.isStudentAdmin;
  return min_user;
}


/*
class snack_bar_display extends StatefulWidget {
  String text;
  snack_bar_display(this.text);

  @override
  State<snack_bar_display> createState() => _snack_bar_displayState();
}

class _snack_bar_displayState extends State<snack_bar_display> {
  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    return Container(); 
  }
} */
