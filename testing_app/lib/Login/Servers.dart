import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '/User_profile/Models.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class login_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

  // CHECK EMAIL OR CREATE EMAIL ACCOUNT FOR NEW USERS

  Future<List<dynamic>> register_email_check(String email) async {
    try {
      Map<String, String> queryParameters = {'email': email};
      String queryString = Uri(queryParameters: queryParameters).query;
      var url = Uri.parse("$base_url/register/email_check2?$queryString");

      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;
      print(data['password']);
      return [data['error'], data['password']];
    } catch (e) {
      return [true, ''];
    }
  }

// LOGIN FUNCTION
  Future<bool> loginNow(String username, String password) async {
    try {
//      if (username == "VidyaSagar") {
//        return true;
      //     }
      var path = Uri.parse("$base_url/login2");
      var response = await http.post(path,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'username': username,
            'password': password,
          }));
      var data = jsonDecode(response.body) as Map;
      if (data.containsKey('token')) {
        storage.setItem('token', data['token']);
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

// GETTING USER CREDIDENTIALS // DELETE USER
  Future<Username> get_user(String email) async {
    try {
      await Firebase.initializeApp();
      String? FCM_token = await FirebaseMessaging.instance.getToken();
      print(FCM_token);
      String platform = "";
      if (Platform.isAndroid) {
        platform = "android";
      } else {
        platform = "ios";
      }

      Map<String, String> queryParameters = {
        'token': FCM_token!,
        'platform': platform,
        'email': email
      };
      String queryString = Uri(queryParameters: queryParameters).query;

      var token = storage.getItem('token');
      var url = Uri.parse("$base_url/get_user2?$queryString");
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body);
      Username user = Username.fromJson(data);
      return user;
    } catch (e) {
      Username user = Username();
      return user;
    }
  }

  Future<bool> delete_profile() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/get_user2";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;
      print(data['error']);
      return data['error'];
    } catch (e) {
      print("error");
      return true;
    }
  }
}
