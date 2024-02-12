class Universities {
  int? id;
  String? unvName;
  String? unvLocation;
  String? unvPic;
  int? univPicRatio;
  String? joinedDate;
  String? domain;

  Universities(
      {this.id,
      this.unvName,
      this.unvLocation,
      this.unvPic,
      this.univPicRatio,
      this.joinedDate,
      this.domain});

  Universities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unvName = json['unvName'];
    unvLocation = json['unvLocation'];
    unvPic = json['unvPic'];
    univPicRatio = json['univPicRatio'];
    joinedDate = json['joinedDate'];
    domain = json['domain'];
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
    return data;
  }
}
