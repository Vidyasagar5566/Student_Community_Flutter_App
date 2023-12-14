import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';

class app_notif_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'https://StudentCommunity.pythonanywhere.com';

// NOTIFICATIONS

  Future<List<Notifications>> get_notifications_list() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/notifications1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Notifications> temp = [];
      data.forEach((element) {
        Notifications notif = Notifications.fromJson(element);
        temp.add(notif);
      });

      return temp;
    } catch (e) {
      List<Notifications> temp = [];
      return temp;
    }
  }

  Future<bool> post_notification(String title, String description,
      String notif_year, String notif_branchs, String notif_courses) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/notifications1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'title': title,
            'description': description,
            'notif_year': notif_year,
            'notif_branchs': notif_branchs,
            'notif_courses': notif_courses
          }));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete_notification(int notification_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'notification_id': notification_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/notifications1?$queryString";
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
}
