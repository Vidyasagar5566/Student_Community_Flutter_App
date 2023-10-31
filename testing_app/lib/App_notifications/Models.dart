import '/User_profile/Models.dart';

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
