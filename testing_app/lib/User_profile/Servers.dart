import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '/Posts/Models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:testing_app/Threads/Models.dart';
import 'package:testing_app/Activities/Models.dart';

class user_profile_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// USER PROFILE LIST POSTS / PROFILE _PIC UPDATE / PROFILE_PIC DELTE

  Future<List<POST_LIST>> get_user_post_list(
      String email, String category, int category_id) async {
    try {
      Map<String, String> queryParameters = {
        'email': email,
        'category': category,
        'category_id': category_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var token = storage.getItem('token');
      String finalUrl = "$base_url/profile/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<POST_LIST> temp = [];
      data.forEach((element) {
        POST_LIST post = POST_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<POST_LIST> temp = [];
      return temp;
    }
  }

  Future<List<ALERT_LIST>> get_user_thread_list(
      String email, String category, int category_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/profile/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'email': email,
            'category': category,
            'category_id': category_id.toString()
          }));
      var data = json.decode(response.body) as List;
      List<ALERT_LIST> temp = [];
      data.forEach((element) {
        ALERT_LIST post = ALERT_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<ALERT_LIST> temp = [];
      return temp;
    }
  }

  Future<List<EVENT_LIST>> get_user_activity_list(
      String email, String category, int category_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/profile/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.patch(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'email': email,
            'category': category,
            'category_id': category_id.toString()
          }));
      var data = json.decode(response.body) as List;
      List<EVENT_LIST> temp = [];
      data.forEach((element) {
        EVENT_LIST post = EVENT_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<EVENT_LIST> temp = [];
      return temp;
    }
  }

  Future<bool> edit_profile2(
      String username, String phone_number, File file, String file_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/profile/list1";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (file_type == "2") {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'username': username,
            'phone_number': phone_number,
            'file': base64file,
            'file_name': fileName,
            'file_type': file_type
          }));
      var data = json.decode(response.body) as Map;
      print(data['error']);
      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_profile_pic() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/profile/list1";
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
