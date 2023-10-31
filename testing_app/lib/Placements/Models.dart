import '/User_profile/Models.dart';
import 'dart:io';

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
