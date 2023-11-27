import 'dart:io';

import '/User_profile/Models.dart';

class DatingUser {
  int? id;
  String? dummyUserUuid;
  String? dummyName;
  String? dummyProfile;
  String? dummyBio;
  String? dummyDomain;
  int? connections;
  String? domain;
  String? postedDate;
  SmallUsername? username;

  DatingUser(
      {this.id,
      this.dummyUserUuid,
      this.dummyName,
      this.dummyProfile,
      this.dummyBio,
      this.dummyDomain,
      this.connections,
      this.domain,
      this.postedDate,
      this.username});

  DatingUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dummyUserUuid = json['dummyUserUuid'];
    dummyName = json['dummyName'];
    dummyProfile = json['dummyProfile'];
    dummyBio = json['dummyBio'];
    dummyDomain = json['dummyDomain'];
    connections = json['connections'];
    domain = json['domain'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dummyUserUuid'] = this.dummyUserUuid;
    data['dummyName'] = this.dummyName;
    data['dummyProfile'] = this.dummyProfile;
    data['dummyBio'] = this.dummyBio;
    data['dummyDomain'] = this.dummyDomain;
    data['connections'] = this.connections;
    data['domain'] = this.domain;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}
