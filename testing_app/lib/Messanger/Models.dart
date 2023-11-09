import '/User_profile/Models.dart';
import 'dart:io';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastmessage;
  int? lastmessagetype;
  bool? lastmessageseen;
  DateTime? lastmessagetime;
  String? lastmessagesender;
  bool? group = false;
  String? group_creator;
  String? group_name;
  String? group_icon;
  Map<String, dynamic>? participants_seen;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastmessage,
      this.lastmessagetype,
      this.lastmessageseen,
      this.lastmessagetime,
      this.lastmessagesender,
      this.group,
      this.group_creator,
      this.group_name,
      this.group_icon,
      this.participants_seen});

  ChatRoomModel.FromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastmessage = map["lastmessage"];
    lastmessagetype = map['lastmessagetype'];
    lastmessageseen = map['lastmessageseen'];
    lastmessagetime = map['lastmessagetime'].toDate();
    lastmessagesender = map['lastmessagesender'];
    group = map['group'];
    group_creator = map['group_creator'];
    group_name = map['group_name'];
    group_icon = map['group_icon'];
    participants_seen = map['participants_seen'];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastmessage,
      "lastmessagetype": lastmessagetype,
      "lastmessageseen": lastmessageseen,
      "lastmessagetime": lastmessagetime,
      "lastmessagesender": lastmessagesender,
      "group": group,
      "group_creator": group_creator,
      "group_name": group_name,
      "group_icon": group_icon,
      "participants_seen": participants_seen,
    };
  }
}

class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  DateTime? createdon;
  bool? seen;
  String? photo;
  int? type;
  bool? insert = false;
  File? offline_file;
  bool? sent = true;

  MessageModel(
      {this.messageid,
      this.sender,
      this.text,
      this.createdon,
      this.seen,
      this.photo,
      this.type,
      this.insert,
      this.offline_file,
      this.sent});

  MessageModel.FromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    createdon = map["createdon"].toDate();
    seen = map["seen"];
    photo = map["photo"];
    type = map["type"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "createdon": createdon,
      "seen": seen,
      "photo": photo,
      "type": type
    };
  }
}
