import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:io';

class messanger_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// MESSANGER

  Future<List<List<Messanger>>> get_messages_list(
      String exist_messages_list) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'exist_messages_list': exist_messages_list.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/messanger1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<List<Messanger>> temp = [];
      data.forEach((element) {
        List<Messanger> temp1 = [];
        element.forEach((element1) {
          Messanger notif = Messanger.fromJson(element1);
          temp1.add(notif);
        });
        temp.add(temp1);
      });
      return temp;
    } catch (e) {
      List<List<Messanger>> temp = [];
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

  Future<List<Messanger>> user_user_messages(String chattinguser_email,
      String ind_message_lenth, bool last_msg_seen) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'chattinguser_email': chattinguser_email,
        'ind_message_lenth': ind_message_lenth,
        'last_msg_seen': last_msg_seen.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/user_messanger1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Messanger> temp = [];
      data.forEach((element) {
        Messanger post = Messanger.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<Messanger> temp = [];
      return temp;
    }
  }
}
