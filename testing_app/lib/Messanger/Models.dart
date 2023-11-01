import '/User_profile/Models.dart';
import 'dart:io';

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

class Messager {
  int? id;
  String? messageBody;
  String? messageFile;
  String? messagFileType;
  String? messageBodyFile;
  String? messageReplyto;
  bool? messageSeen;
  String? messageDate;
  String? messageSender;
  String? messageReceiver;
  File? file;
  bool? insertMessage = false;
  bool? messageSent = true;
  int? index;

  Messager(
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

  Messager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageBody = json['message_body'];
    messageFile = json['message_file'];
    messagFileType = json['messag_file_type'];
    messageBodyFile = json['message_body_file'];
    messageReplyto = json['message_replyto'];
    messageSeen = json['message_seen'];
    messageDate = json['message_date'];
    messageSender = json['message_sender'];
    messageReceiver = json['message_receiver'];
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
    data['message_sender'] = this.messageSender;
    data['message_receiver'] = this.messageReceiver;
    return data;
  }
}

class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? lastmessage;

  ChatRoomModel({this.chatroomid,this.participants,this.lastmessage});

  ChatRoomModel.FromMap(Map<String,dynamic> map)
  {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastmessage = map["lastmessage"];
  }

  Map<String,dynamic> toMap(){
    return{
      "chatroomid":chatroomid,
      "participants":participants,
      "lastmessage":lastmessage
    };
  }
}

class MessageModel{
  String? messageid;
  String? sender;
  String? text;
  DateTime? createdon;
  bool? seen;
  String? photo;
  int? type;

  MessageModel({this.messageid,this.sender,this.text,this.createdon,this.seen,this.photo,this.type});

  MessageModel.FromMap(Map<String,dynamic> map)
  {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    createdon = map["createdon"].toDate();
    seen = map["seen"];
    photo = map["photo"];
    type = map["type"];
  }

  Map<String,dynamic> toMap(){
    return{
      "messageid":messageid,
      "sender":sender,
      "text":text,
      "createdon":createdon,
      "seen":seen,
      "photo":photo,
      "type":type
    };
  }
}
