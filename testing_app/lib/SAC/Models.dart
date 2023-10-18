import 'package:testing_app/User_profile/Models.dart';

class SAC_MEMS {
  int? id;
  String? logo;
  double? imgRatio;
  String? name;
  String? description;
  String? phoneNum;
  String? email;
  String? domain;
  String? dateOfJoin;
  SmallUsername? head;
  int? starMark;

  SAC_MEMS(
      {this.id,
      this.logo,
      this.imgRatio,
      this.name,
      this.description,
      this.phoneNum,
      this.email,
      this.domain,
      this.dateOfJoin,
      this.head,
      this.starMark});

  SAC_MEMS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    imgRatio = json['img_ratio'];
    name = json['role'];
    description = json['description'];
    phoneNum = json['phone_num'];
    email = json['email'];
    domain = json['domain'];
    dateOfJoin = json['date_of_join'];
    head =
        json['head'] != null ? new SmallUsername.fromJson(json['head']) : null;
    starMark = json['star_mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['img_ratio'] = this.imgRatio;
    data['role'] = this.name;
    data['description'] = this.description;
    data['phone_num'] = this.phoneNum;
    data['email'] = this.email;
    data['domain'] = this.domain;
    data['date_of_join'] = this.dateOfJoin;
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    data['star_mark'] = this.starMark;
    return data;
  }
}
