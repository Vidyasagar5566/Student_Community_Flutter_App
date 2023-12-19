import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class menu_bar_servers {
  LocalStorage storage = LocalStorage("usertoken");

// EDIT NOTIFICATION SETTINGS AND NOTIFICATION SEEN ,COUNT

  Future<List<NotificationsFilter>> notif_settings_get() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/edit_notif_settings1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<NotificationsFilter> temp = [];
      data.forEach((element) {
        NotificationsFilter post = NotificationsFilter.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      return [];
    }
  }

  Future<bool> notif_settings_edit(
    bool lstBuy,
    bool posts,
    bool postsAdmin,
    bool events,
    bool threads,
    bool comments,
    bool announcements,
    bool messanger,
  ) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/edit_notif_settings1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'lst_buy': lstBuy,
            'posts': posts,
            'posts_admin': postsAdmin,
            'events': events,
            'threads': threads,
            'comments': comments,
            'announcements': announcements,
            'messanger': messanger,
          }));
      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> notif_seen() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/edit_notif_settings1";
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
