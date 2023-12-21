import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import '/Activities/Models.dart';
import 'dart:io';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class calendar_servers {
  LocalStorage storage = LocalStorage("usertoken");

  //  CALENDER EVENTS;

  Future<Map<List<CALENDER_EVENT>, List<EVENT_LIST>>> get_calender_event_list(
      String calender_date, String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'calender_date': calender_date.toString(),
        'domain': domain
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_events/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      var event_data = data[0];
      var calender_data = data[1];
      List<EVENT_LIST> temp = [];
      event_data.forEach((element) {
        EVENT_LIST post = EVENT_LIST.fromJson(element);
        temp.add(post);
      });
      List<CALENDER_EVENT> temp1 = [];
      calender_data.forEach((element) {
        CALENDER_EVENT post = CALENDER_EVENT.fromJson(element);
        temp1.add(post);
      });
      return {temp1: temp};
    } catch (e) {
      print("error");
      return {[]: []};
    }
  }

  Future<List<String>> get_cal_dates(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'domain': domain};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_events/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.patch(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<String> temp = [];
      data.forEach((element) {
        temp.add(element);
      });

      return temp;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> post_calender_event(
      String cal_event_type,
      String title,
      String description,
      File file,
      String file_type,
      String branch,
      String year,
      String course,
      String all_university,
      String event_date) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_events/list1";
      String base64file = "";
      String fileName = "";
      if (file_type != "0") {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      bool is_all_university = true;
      if (all_university != "All") {
        is_all_university = false;
      }
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'cal_event_type': cal_event_type,
            'title': title,
            'description': description,
            'file': base64file,
            'file_name': fileName,
            'file_type': file_type,
            'branch': branch,
            'year': year,
            'course': course,
            'all_universities': is_all_university,
            'event_date': event_date
          }));
      var data = json.decode(response.body) as Map;
      print(data);
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

  Future<bool> delete_calender_event(int calender_event_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'calender_event_id': calender_event_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_events/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<List<dynamic>> edit_calender_event(
      int id,
      String cal_event_type,
      String title,
      String description,
      File file,
      String file_type,
      String branch,
      String year,
      String course,
      String event_date) async {
    try {
      print(event_date);
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_events/list1";
      String base64file = "";
      String fileName = "";
      if (file_type != "0") {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'id': id,
            'cal_event_type': cal_event_type,
            'title': title,
            'description': description,
            'file': base64file,
            'file_name': fileName,
            'file_type': file_type,
            'branch': branch,
            'year': year,
            'course': course,
            'event_date': event_date
          }));
      var data = json.decode(response.body) as Map;
      print(data);
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

// TIME TABLE THINGS

//   Future<bool> get_timetable(int calender_event_id) async {
//     try {
//       var token = storage.getItem('token');
//       Map<String, String> queryParameters = {
//         'calender_event_id': calender_event_id.toString()
//       };
//       String queryString = Uri(queryParameters: queryParameters).query;
//       String finalUrl = "$base_url/cal_events/list1?$queryString";
//       var url = Uri.parse(finalUrl);
//       http.Response response = await http.delete(url, headers: {
//         'Authorization': 'token $token',
//         "Content-Type": "application/json",
//       });
//       var data = json.decode(response.body) as Map;

//       return data['error'];
//     } catch (e) {
//       return true;
//     }
//   }

//   Future<List<dynamic>> post_time_table(
//       int id,
//       String cal_event_type,
//       String title,
//       String description,
//       File file,
//       String file_type,
//       String branch,
//       String year,
//       String event_date) async {
//     try {
//       print(event_date);
//       var token = storage.getItem('token');
//       String finalUrl = "$base_url/cal_events/list1";
//       String base64file = "";
//       String fileName = "";
//       if (file_type != "0") {
//         base64file = base64Encode(file.readAsBytesSync());
//         fileName = file.path.split("/").last;
//       }
//       var url = Uri.parse(finalUrl);
//       http.Response response = await http.put(url,
//           headers: {
//             'Authorization': 'token $token',
//             "Content-Type": "application/json",
//           },
//           body: jsonEncode({
//             'id': id,
//             'cal_event_type': cal_event_type,
//             'title': title,
//             'description': description,
//             'file': base64file,
//             'file_name': fileName,
//             'file_type': file_type,
//             'branch': branch,
//             'year': year,
//             'event_date': event_date
//           }));
//       var data = json.decode(response.body) as Map;
//       print(data);
//       return [data['error'], data['id']];
//     } catch (e) {
//       return [true, 0];
//     }
//   }

// //subscription to subjects

//   Future<bool> edit_timetable_subscription(String notif_ids) async {
//     try {
//       var token = storage.getItem('token');
//       Map<String, String> queryParameters = {
//         'notif_ids': notif_ids,
//       };
//       String queryString = Uri(queryParameters: queryParameters).query;
//       String finalUrl = "$base_url/edit_notif_settings1?$queryString";
//       var url = Uri.parse(finalUrl);
//       http.Response response = await http.get(url, headers: {
//         'Authorization': 'token $token',
//         "Content-Type": "application/json",
//       });
//       var data = json.decode(response.body) as Map;

//       return data['error'];
//     } catch (e) {
//       return true;
//     }
//   }
}
