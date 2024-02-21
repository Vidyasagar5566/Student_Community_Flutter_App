class Universities {
  int? id;
  String? unvName;
  String? unvLocation;
  String? unvPic;
  int? univPicRatio;
  String? joinedDate;
  String? domain;
  double? Rating;
  int? totalRatings;
  String? about;
  String? courses;
  String? fees;
  String? placements;
  String? hostels;

  Universities({
    this.id,
    this.unvName,
    this.unvLocation,
    this.unvPic,
    this.univPicRatio,
    this.joinedDate,
    this.domain,
    this.Rating,
    this.totalRatings,
    this.about,
    this.courses,
    this.fees,
    this.placements,
    this.hostels,
  });

  Universities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unvName = json['unvName'];
    unvLocation = json['unvLocation'];
    unvPic = json['unvPic'];
    univPicRatio = json['univPicRatio'];
    joinedDate = json['joinedDate'];
    domain = json['domain'];
    Rating = json["Rating"];
    totalRatings = json["totalRatings"];
    about = json["about"];
    courses = json["courses"];
    fees = json["fees"];
    placements = json["placements"];
    hostels = json["hostels"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unvName'] = this.unvName;
    data['unvLocation'] = this.unvLocation;
    data['unvPic'] = this.unvPic;
    data['univPicRatio'] = this.univPicRatio;
    data['joinedDate'] = this.joinedDate;
    data['domain'] = this.domain;
    data["Rating"] = this.Rating;
    data["totalRatings"] = this.totalRatings;
    data["about"] = this.about;
    data["courses"] = this.courses;
    data["fees"] = this.fees;
    data["placements"] = this.placements;
    data["hostels"] = this.hostels;
    return data;
  }
}
