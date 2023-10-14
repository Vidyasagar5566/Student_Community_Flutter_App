import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';


class menu_bar_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// EDIT NOTIFICATION SETTINGS AND NOTIFICATION SEEN ,COUNT

  Future<bool> edit_notif_settings(
    String index,
    String notif_settings,
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
          body: jsonEncode({'notif_settings': notif_settings, 'index': index}));
      var data = json.decode(response.body) as Map;
      print(data['error']);
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
