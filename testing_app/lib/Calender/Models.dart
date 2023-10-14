import 'package:testing_app/User_profile/Models.dart';

class CALENDER_EVENT {
  int? id;
  String? calEventType;
  String? title;
  String? description;
  String? calenderDateFile;
  String? fileType;
  String? branch;
  String? year;
  String? eventDate;
  String? postedDate;
  SmallUsername? username;
  bool? insertMessage = false;
  bool? messageSent = true;

  CALENDER_EVENT(
      {this.id,
      this.calEventType,
      this.title,
      this.description,
      this.calenderDateFile,
      this.fileType,
      this.branch,
      this.year,
      this.eventDate,
      this.postedDate,
      this.username,
      this.insertMessage,
      this.messageSent});

  CALENDER_EVENT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    calEventType = json['cal_event_type'];
    title = json['title'];
    description = json['description'];
    calenderDateFile = json['calender_date_file'];
    fileType = json['file_type'];
    branch = json['branch'];
    year = json['year'];
    eventDate = json['event_date'];
    postedDate = json['posted_date'];
    username = json['username'] != null
        ? new SmallUsername.fromJson(json['username'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cal_event_type'] = this.calEventType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['calender_date_file'] = this.calenderDateFile;
    data['file_type'] = this.fileType;
    data['branch'] = this.branch;
    data['year'] = this.year;
    data['event_date'] = this.eventDate;
    data['posted_date'] = this.postedDate;
    if (this.username != null) {
      data['username'] = this.username!.toJson();
    }
    return data;
  }
}

class TIMETABLE_LIST {
  int? id;
  String? branch;
  String? sun;
  String? mon;
  String? tue;
  String? wed;
  String? thu;
  String? fri;
  String? sat;

  TIMETABLE_LIST(
      {this.id,
      this.branch,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat});

  TIMETABLE_LIST.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branch = json['branch_name'];
    sun = json['sun'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_name'] = this.branch;
    data['sun'] = this.sun;
    data['mon'] = this.mon;
    data['tue'] = this.tue;
    data['wed'] = this.wed;
    data['thu'] = this.thu;
    data['fri'] = this.fri;
    data['sat'] = this.sat;
    return data;
  }
}
