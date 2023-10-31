import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import '/User_profile/Models.dart';
import 'dart:io';

class messanger_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// MESSANGER

  Future<List<Messanger>> get_messages_list() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/messanger1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Messanger> temp = [];

      data.forEach((element1) {
        Messanger message = Messanger.fromJson(element1);
        temp.add(message);
      });

      return temp;
    } catch (e) {
      List<Messanger> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> post_message(String email, String message_body,
      File file, String message_file_type, String message_replyto) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/messanger1";
      String base64file = "";
      String fileName = "";
      if (message_file_type != "0") {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'email': email,
            'message_body': message_body,
            'file': base64file,
            'file_name': fileName,
            'messag_file_type': message_file_type,
            'message_replyto': message_replyto
          }));
      var data = json.decode(response.body) as Map;
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

  Future<bool> delete_message(int message_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'message_id': message_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/messanger1?$queryString";
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
      String finalUrl = "$base_url/user_messanger1?$queryString";
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
// USER TO USER MESSAGES

  Future<List<Messager>> user_user_messages(
      String chattinguser_email, int num_list) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'chattinguser_email': chattinguser_email,
        'num_list': num_list.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/user_messanger1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Messager> temp = [];
      data.forEach((element) {
        Messager post = Messager.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      print(e);
      List<Messager> temp = [];
      return temp;
    }
  }

  // CLUB__MEMBS

  Future<List<SmallUsername>> get_fire_base_emails_to_backend_users(
      String team_mem) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'team_mem': team_mem,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/club_sport_fest/mems?$queryString";
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
}
