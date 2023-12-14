import 'dart:io';

import '/User_profile/Models.dart';

class DatingUser {
  int? id;
  String? dummyUserUuid;
  String? dummyName;
  String? dummyProfile;
  String? dummyBio;
  String? dummyDomain;
  int? connections_count;
  int? Reactions1_count;
  int? Reactions2_count;
  int? is_reaction;
  String? domain;
  String? postedDate;
  SmallUsername? username;
  int? numChats;
  double? algoValue;

  DatingUser(
      {this.id,
      this.dummyUserUuid,
      this.dummyName,
      this.dummyProfile,
      this.dummyBio,
      this.dummyDomain,
      this.connections_count,
      this.Reactions1_count,
      this.Reactions2_count,
      this.is_reaction,
      this.domain,
      this.postedDate,
      this.username,
      this.numChats,
      this.algoValue});

  DatingUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dummyUserUuid = json['dummyUserUuid'];
    dummyName = json['dummyName'];
    dummyProfile = json['dummyProfile'];
    dummyBio = json['dummyBio'];
    dummyDomain = json['dummyDomain'];
    connections_count = json['connections_count'];
    Reactions1_count = json['Reactions1_count'];
    Reactions2_count = json['Reactions2_count'];
    is_reaction = json['is_reaction'];
    domain = json['domain'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
    numChats = json['numChats'];
    algoValue = json['algoValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dummyUserUuid'] = this.dummyUserUuid;
    data['dummyName'] = this.dummyName;
    data['dummyProfile'] = this.dummyProfile;
    data['dummyBio'] = this.dummyBio;
    data['dummyDomain'] = this.dummyDomain;
    data['connections_count'] = this.connections_count;
    data['Reactions1_count'] = this.Reactions1_count;
    data['Reactions2_count'] = this.Reactions2_count;
    data['is_reaction'] = this.is_reaction;
    data['domain'] = this.domain;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    data['numChats'] = this.numChats;
    data['algoValue'] = this.algoValue;
    return data;
  }
}
