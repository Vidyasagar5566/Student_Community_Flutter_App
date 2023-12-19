import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import '/User_profile/Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class messanger_servers {
  LocalStorage storage = LocalStorage("usertoken");

// SEARCH USERS LIST ,

  Future<List<SmallUsername>> get_searched_user_list(
      String username_match, String domain, int num_list) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'username_match': username_match,
        'domain': domain,
        'num_list': num_list.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/user_messanger?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<SmallUsername> temp = [];
      data.forEach((element) {
        SmallUsername post = SmallUsername.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<SmallUsername> temp = [];
      return temp;
    }
  }
// USER MESSAGES NOTIFICATION

  Future<bool> user_messages_notif(
      String chattinguser_email, String message) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'chattinguser_email': chattinguser_email,
        'message': message
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/user_messanger?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  // CLUB__MEMBS

  Future<List<SmallUsername>> get_fire_base_uuids_to_backend_users(
      String user_uuids) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'user_uuids': user_uuids,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/user_messanger?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<SmallUsername> temp = [];
      data.forEach((element) {
        SmallUsername post = SmallUsername.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<SmallUsername> temp = [];
      return temp;
    }
  }
}
