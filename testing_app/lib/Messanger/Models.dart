import 'package:testing_app/User_profile/Models.dart';
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
