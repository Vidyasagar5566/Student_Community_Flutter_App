//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:testing_app/uploads/uploads.dart';
import 'dart:convert';
import '/models/models.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class servers {
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

// CREATE USER BY SUPER USER
/*
  Future<bool> create_user(String key, String username, String password) async {
    try {
      var path = Uri.parse("$base_url/register/email_check2");
      var response = await http.post(path,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'key': key,
            'username': username,
            'password': password,
          }));
      var data = jsonDecode(response.body) as Map;
      if (data.containsKey('token')) {
        storage.setItem('token', data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
*/

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

  //var token = 'd49dbf3925dd826c4fb6542a2b44a34cf4834ca1';

// GETTING USER CREDIDENTIALS // DELETE USER
  Future<Username> get_user() async {
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
        'platform': platform
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
      var data = [];
      Username user = Username.fromJson(data[0]);
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

// NOTIFICATIONS

  Future<bool> send_notifications(
      String title, String description, int notiff_sett) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/send_notifications1";
      var url = Uri.parse(finalUrl);
      print("start");
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'notiff_sett': notiff_sett
        }),
      );

      var data = json.decode(response.body) as Map;
      print(data);
      return data['error'];
    } catch (e) {
      print("error");
      return true;
    }
  }

  Future<bool> send_announce_notifications(String title, String description,
      int notiff_sett, String notif_year, String notif_branch) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/send_notifications1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'notiff_sett': notiff_sett,
          'notif_branchs': notif_branch,
          'notif_year': notif_year
        }),
      );

      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

// USER PROFILE LIST POSTS / PROFILE _PIC UPDATE / PROFILE_PIC DELTE

  Future<List<POST_LIST>> get_user_post_list(String username) async {
    try {
      Map<String, String> queryParameters = {
        'username': username,
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

//  LOST AND FOUNDS POST FUNCTIONS

  Future<List<Lost_Found>> get_lst_list(int num_list, String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'num_list': num_list.toString(),
        'domain': domain
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/lost_found/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Lost_Found> temp = [];
      data.forEach((element) {
        Lost_Found post = Lost_Found.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<Lost_Found> temp = [];
      return Future.value(temp);
    }
  }

  Future<bool> post_lst(String title, String description, File file,
      String image_ratio, String tag) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/lost_found/list1";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (image_ratio == '1') {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'file': base64file,
          'file_name': fileName,
          'image_ratio': image_ratio,
          'tag': tag
        }),
      );

      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_lst(int lst_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'lst_id': lst_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/lost_found/list1?$queryString";
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

  Future<bool> hide_lst(int lst_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'lst_id': lst_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/lost_found/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// LOST AND FOUND COMMENT FUNCTIONS

  Future<List<LST_CMNT>> get_lst_cmnt_list(int lst_id) async {
    try {
      Map<String, String> queryParameters = {
        'lst_id': lst_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var token = storage.getItem('token');
      String finalUrl = "$base_url/lost_found/comment_list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<LST_CMNT> temp = [];
      data.forEach((element) {
        LST_CMNT post = LST_CMNT.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<LST_CMNT> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> post_lst_cmnt(String comment, int lst_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/lost_found/comment_list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'comment': comment,
          'lst_id': lst_id.toString(),
        }),
      );
      var data = json.decode(response.body) as Map;
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

  Future<bool> delete_lst_cmnt(int lst_cmnt_id, int lst_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'lst_cmnt_id': lst_cmnt_id.toString(),
        'lst_id': lst_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/lost_found/comment_list1?$queryString";
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

// POST FUNCTIONS

  Future<List<POST_LIST>> get_post_list(String domain, int num_list) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
        'num_list': num_list.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/post/list1?$queryString";
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
      return Future.value(temp);
    }
  }

  Future<bool> post_post(String description, File file, String image_ratio,
      String all_university) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/post/list1?";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      bool is_all_university = false;
      if (all_university == 'All') {
        is_all_university = true;
      }
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'description': description,
          'file': base64file,
          'file_name': fileName,
          'image_ratio': image_ratio,
          'is_all_university': is_all_university
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_post(int post_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'post_id': post_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/post/list1?$queryString";
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

  Future<bool> hide_post(int post_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'post_id': post_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/post/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// POST COMMENTS FUNCTIONS

  Future<List<PST_CMNT>> get_post_cmnt_list(int post_id) async {
    try {
      Map<String, String> queryParameters = {
        'post_id': post_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var token = storage.getItem('token');
      String finalUrl = "$base_url/post/comment_list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<PST_CMNT> temp = [];
      data.forEach((element) {
        PST_CMNT post = PST_CMNT.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<PST_CMNT> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> post_post_cmnt(String comment, int post_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/post/comment_list1?";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'comment': comment,
          'post_id': post_id.toString(),
        }),
      );
      var data = json.decode(response.body) as Map;
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

  Future<bool> delete_post_cmnt(int cmnt_id, int post_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'cmnt_id': cmnt_id.toString(),
        'post_id': post_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/post/comment_list1?$queryString";
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

// POST LIKE FUNCTIONS

  Future<bool> post_post_like(int post_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/post/like_list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'post_id': post_id,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_post_like(int post_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'post_id': post_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/post/like_list1?$queryString";
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

// EVENT FUNCTIONS

  Future<List<EVENT_LIST>> get_event_list(String domain, int num_list) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
        'num_list': num_list.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/event/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
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

  Future<bool> post_event(String title, String description, File file,
      String image_ratio, String date, String all_university) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/event/list1";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      bool is_all_university = false;
      if (all_university == 'All') {
        is_all_university = true;
      }
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'file': base64file,
          'file_name': fileName,
          'image_ratio': image_ratio,
          'event_date': date,
          'is_all_university': is_all_university
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_event(int event_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'event_id': event_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/event/list1?$queryString";
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

// EVENT LIKES

  Future<bool> post_event_like(int event_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/event/like_list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'event_id': event_id,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_event_like(int event_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'event_id': event_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/event/like_list1?$queryString";
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

  // EVENT_UPDATE USING EVENT LIKE LINK

  Future<bool> update_event(int event_id, String update_text) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'event_id': event_id.toString(),
        'event_update': update_text.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/event/like_list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// ALERT LIST FUNCTIONS

  Future<List<ALERT_LIST>> get_alert_list(String domain, int num_list) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
        'num_list': num_list.toString()
      };
      print(num_list);
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/alert/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
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

  Future<bool> post_alert(
      String title,
      String description,
      File file,
      int file_type,
      String allow_years,
      String allow_branchs,
      String all_university) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/alert/list1";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (file_type != 0) {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      bool is_all_university = false;
      if (all_university == 'All') {
        is_all_university = true;
      }
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'title': title,
            'description': description,
            'base64file': base64file,
            'fileName': fileName,
            'file_type': file_type,
            'allow_years': allow_years,
            'allow_branchs': allow_branchs,
            'is_all_university': is_all_university
          }));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete_alert(int alert_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'alert_id': alert_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/alert/list1?$queryString";
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

// ALERT COMMENT FUNCTIONS

  Future<List<ALERT_CMNT>> get_alert_cmnt_list(int alert_id) async {
    try {
      Map<String, String> queryParameters = {
        'alert_id': alert_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var token = storage.getItem('token');
      String finalUrl = "$base_url/alert/comment_list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<ALERT_CMNT> temp = [];
      data.forEach((element) {
        ALERT_CMNT post = ALERT_CMNT.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<ALERT_CMNT> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> post_alert_cmnt(String comment, int alert_id, File file,
      int file_type, String allow_years, String allow_branchs) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/alert/comment_list1";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (file_type != 0) {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'comment': comment,
          'alert_id': alert_id.toString(),
          'base64file': base64file,
          'fileName': fileName,
          'file_type': file_type,
          'allow_years': allow_years,
          'allow_branchs': allow_branchs
        }),
      );

      var data = json.decode(response.body) as Map;
      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  Future<bool> delete_alert_cmnt(int alert_cmnt_id, int alert_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'alert_cmnt_id': alert_cmnt_id.toString(),
        'alert_id': alert_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/alert/comment_list1?$queryString";
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

// CLUBS_OR_SPORTS LIST FUNCTIONS

  Future<List<CLB_SPRT_LIST>> get_club_sprt_list(
      String club_sport, String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'club_sport': club_sport,
        'domain': domain
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/club_sport/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<CLB_SPRT_LIST> temp = [];
      data.forEach((element) {
        CLB_SPRT_LIST post = CLB_SPRT_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<CLB_SPRT_LIST> temp = [];
      return temp;
    }
  }

  Future<bool> edit_club_list(
      File image,
      String title,
      String email,
      String team_members,
      String description,
      String websites,
      String image_type,
      String club_fest) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/club_sport/list1";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (image_type == "file") {
        base64file = base64Encode(image.readAsBytesSync());
        fileName = image.path.split("/").last;
      }

      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'file': base64file,
          'file_name': fileName,
          'title': title,
          'email': email,
          'team_members': team_members,
          'description': description,
          'websites': websites,
          'image_type': image_type,
          'club_fest': club_fest
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CLUBS_OR_SPORTS LIST EDIT FUNCTIONS

  Future<bool> edit_sport_list(
      File image,
      String title,
      String email,
      String team_members,
      String description,
      String websites,
      String sport_ground,
      File image1,
      String image_type,
      String image2_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/club_sport/edit1";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      String base64file1 = "";
      String fileName1 = "";
      if (image_type == "file") {
        base64file = base64Encode(image.readAsBytesSync());
        fileName = image.path.split("/").last;
      }
      if (image2_type == "file") {
        base64file1 = base64Encode(image1.readAsBytesSync());
        fileName1 = image1.path.split("/").last;
      }

      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'file': base64file,
          'file_name': fileName,
          'file1': base64file1,
          'file_name1': fileName1,
          'title': title,
          'email': email,
          'team_members': team_members,
          'description': description,
          'websites': websites,
          'sport_ground': sport_ground,
          'image_type': image_type,
          'image2_type': image2_type
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CLUBS_SPORTS_LIKES

  Future<bool> post_club_sport_like(int club_sport_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/club_sport/like_list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'club_sport_id': club_sport_id,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_club_sport_like(int club_sport_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'club_sport_id': club_sport_id.toString()
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/club_sport/like_list1?$queryString";
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

// CLUB_OR_SPORT_MEMBS

  Future<List<Username>> get_club_sprt_membs(String team_mem) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'team_mem': team_mem,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/club_sport/memb1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Username> temp = [];
      data.forEach((element) {
        Username post = Username.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<Username> temp = [];
      return temp;
    }
  }

// SAC LIST FUNCTIONS
  Future<List<Username>> get_sac_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/sac/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Username> temp = [];
      data.forEach((element) {
        Username post = Username.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<Username> temp = [];
      return temp;
    }
  }

// MESS LIST FUNCTIONS

  Future<List<MESS_LIST>> get_mess_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/mess/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<MESS_LIST> temp = [];
      data.forEach((element) {
        MESS_LIST post = MESS_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<MESS_LIST> temp = [];
      //return temp;
      return temp;
    }
  }

// ACADEMIC LIST FUNCTIONS

  Future<List<ACADEMIC_LIST>> get_academic_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/academic/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<ACADEMIC_LIST> temp = [];
      data.forEach((element) {
        ACADEMIC_LIST post = ACADEMIC_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<ACADEMIC_LIST> temp = [];
      return temp;
      //return temp;
    }
  }

// BRANCHES OF A COURSES.

  Future<List<ALL_BRANCHES>> get_branches_list(
      String domain, String course) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
        'course': course
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/all_branches/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<ALL_BRANCHES> temp = [];
      data.forEach((element) {
        ALL_BRANCHES post = ALL_BRANCHES.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<ALL_BRANCHES> temp = [];
      //return temp;
      return temp;
    }
  }

//PLACEMENTS OR SUBJECTS

  Future<List<CAL_SUB_NAMES>> get_sub_place_list(
      String sub_id, String domain, String course) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'sub_id': sub_id,
        'domain': domain,
        'course': course
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_dates_subs/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<CAL_SUB_NAMES> temp = [];
      data.forEach((element) {
        CAL_SUB_NAMES post = CAL_SUB_NAMES.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<CAL_SUB_NAMES> temp = [];
      //return temp;
      return [];
    }
  }

  Future<List<dynamic>> post_cal_sub(String sub_name, String sub_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_dates_subs/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'sub_name': sub_name, 'sub_id': sub_id}));
      var data = json.decode(response.body) as Map;
      print(data);
      return [data['error'], data['id']];
    } catch (e) {
      print('error');
      return [true, -1];
    }
  }

  Future<bool> edit_cal_sub(String sub_name, String sub_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_dates_subs/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'sub_name': sub_name, 'sub_id': sub_id}));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CALENDER SUB YEARS

  Future<List<CAL_SUB_YEARS>> get_sub_years_list(String sub_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'sub_id': sub_id,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_sub_years/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<CAL_SUB_YEARS> temp = [];
      data.forEach((element) {
        CAL_SUB_YEARS post = CAL_SUB_YEARS.fromJson(element);
        temp.add(post);
      });

      return temp;
    } catch (e) {
      print("error");
      List<CAL_SUB_YEARS> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> add_cal_sub_year(
      String sub_id, String year_name, bool private) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_sub_years/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {'sub_id': sub_id, 'year_name': year_name, 'private': private}));
      var data = json.decode(response.body) as Map;

      print(data);

      return [data['error'], data['id']];
    } catch (e) {
      print('error');
      return [true, '-1'];
    }
  }

  Future<bool> edit_cal_year(
      String year_name, String year_id, bool private) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_sub_years/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'year_name': year_name,
            'year_id': year_id,
            'private': private
          }));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CALENDER LIST FUNCTIONS  for files

  Future<List<CAL_SUB_FILES>> get_sub_files_list(String year_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'year_id': year_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/calender_sub_files1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<CAL_SUB_FILES> temp = [];
      data.forEach((element) {
        CAL_SUB_FILES post = CAL_SUB_FILES.fromJson(element);
        temp.add(post);
      });

      return temp;
    } catch (e) {
      List<CAL_SUB_FILES> temp = [];
      print(temp);
      //return temp;
      return [];
    }
  }

  Future<List<dynamic>> post_cal_sub_files(
      File file, String year_id, String file_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/calender_sub_files1";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'file': base64file,
            'file_name': fileName,
            'description': "",
            'year_id': year_id,
            "file_type": file_type,
          }));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  Future<bool> delete_sub_files_list(String id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/calender_sub_files1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'id': id}));
      var data = json.decode(response.body) as Map;

      print(data);
      return data['error'];
    } catch (e) {
      print('error');
      return true;
    }
  }

  Future<List<dynamic>> edit_cal_sub_files(String file_email, int id, File file,
      String year_id, String file_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/calender_sub_files1";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "file_email": file_email,
            'id': id,
            'file': base64file,
            'file_name': fileName,
            'description': "",
            'year_id': year_id,
            "file_type": file_type,
          }));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  // RATINGS

  Future<List<RATINGS>> get_sub_ratings_list(String sub_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'sub_id': sub_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/ratings?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<RATINGS> temp = [];
      data.forEach((element) {
        RATINGS post = RATINGS.fromJson(element);
        temp.add(post);
      });

      return temp;
    } catch (e) {
      List<RATINGS> temp = [];
      print(temp);
      return temp;
    }
  }

  Future<List<dynamic>> post_sub_rating(int rating, String sub_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/ratings";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'rating': rating,
            'sub_id': sub_id,
          }));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  Future<bool> delete_sub_rating(String id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/ratings";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'id': id}));
      var data = json.decode(response.body) as Map;

      print(data);
      return data['error'];
    } catch (e) {
      print('error');
      return true;
    }
  }

  //  CALENDER EVENTS;

  Future<Map<List<CALENDER_EVENT>, List<EVENT_LIST>>> get_calender_event_list(
      String calender_date) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'calender_date': calender_date.toString()
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

  Future<Map<List<CAL_SUB_NAMES>, List<String>>> get_cal_list(
      String domain) async {
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
      return {[]: temp};
    } catch (e) {
      print("error");
      List<CAL_SUB_NAMES> temp = [];
      //return temp;
      return {temp: []};
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

  Future<bool> get_timetable(int calender_event_id) async {
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

  Future<List<dynamic>> post_time_table(
      int id,
      String cal_event_type,
      String title,
      String description,
      File file,
      String file_type,
      String branch,
      String year,
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
            'event_date': event_date
          }));
      var data = json.decode(response.body) as Map;
      print(data);
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

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

  Future<bool> edit_timetable_subscription(String notif_ids) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'notif_ids': notif_ids,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/edit_notif_settings1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

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
      String notif_year, String notif_branchs) async {
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
            'notif_branchs': notif_branchs
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

  // REPORT AND BLOCKING USERS.

  Future<List<dynamic>> report_upload(
      String description, String report_belongs) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/security1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {'description': description, 'report_belongs': report_belongs}));
      var data = json.decode(response.body) as Map;
      print(data);
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

  Future<bool> report_delete(int report_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'report_id': report_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/security1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as Map;
      print(data['error']);
      return data['error'];
    } catch (e) {
      return true;
    }
  }
}

var course_list = ['B.Tech', 'M.Tech', 'PG', 'Phd', 'MBA'];

var domains = {
  'All': 'All',
  '@nitt.edu': 'Nit Trichy',
  '@nitk.edu.in': 'Nit Surathkal',
  '@nitrkl.ac.in': 'Nit Rourkela',
  '@nitw.ac.in': ' Nit Warangal',
  '@nitc.ac.in': 'Nit Calicut',
  '@vnit.ac.in': 'Nit Nagpur',
  '@nitdgp.ac.in': 'Nit Durgapur',
  '@nits.ac.in': 'Nit Silchar',
  '@mnit.ac.in': 'Nit Jaipur',
  '@mnnit.ac.in': 'Nit Allahabad',
  '@nitkkr.ac.in': 'Nit Kurukshetra',
  '@nitj.ac.in': ' Nit Jalandhar',
  '@svnit.ac.in': ' Nit Surat',
  '@nitm.ac.in': 'Nit Meghalaya',
  '@nitp.ac.in': 'Nit Patna',
  '@nitrr.ac.in': 'Nit Raipur',
  '@nitsri.ac.in': 'Nit Srinagar',
  '@manit.ac.in': 'Nit Bhopal',
  '@nita.ac.in': 'Nit Agarthala',
  '@nitgoa.ac.in': 'Nit Goa',
  '@nitjsr.ac.in': 'Nit Jamshedpur',
  '@nitmanipur.ac.in': 'Nit Manipur',
  '@nith.ac.in': 'Nit Hamper',
  '@nituk.ac.in': ' Nit Uttarakhand',
  '@nitpy.ac.in': 'Nit Puducherry',
  '@nitap.ac.in': 'Nit ArunaChalPradesh',
  '@nitsikkim.ac.in': 'Nit Sikkim',
  '@nitdelhi.ac.in': 'Nit Delhi',
  '@nitmz.ac.in': 'Nit Mizoram',
  '@nitnagaland.ac.in': 'Nit Nagaland',
  '@nitandhra.ac.in': 'Nit AndhraPradesh',
//IITS
  '@iitm.ac.in': 'IIT Madras',
  '@iitd.ac.in': 'IIT Delhi',
  '@iitb.ac.in': 'IIT Bombay',
  '@iitk.ac.in': 'IIT Kanpur',
  '@iitr.ac.in': 'IITR Rookee',
  '@iitkgp.ac.in': 'IIT Kharagpur',
  '@iitg.ac.in': 'IIT Guwahati',
  '@iith.ac.in': 'IIT Hyderabad',
  '@iitbhu.ac.in': 'IIT BHU',
  '@iitism.ac.in': 'IIT ISM Dhanbad',
  '@iiti.ac.in': 'IIT Indore',
  '@iitrpr.ac.in': 'IIT Rupar',
  '@iitmandi.ac.in': 'IIT Mandi',
  '@iitgn.ac.in': 'IIT Gandhinagar',
  '@iitj.ac.in': 'IIT Jodhpur',
  '@iitp.ac.in': 'IIT Patna',
  '@iitbbs.ac.in': 'IIT Bhubaneswar',
  '@iittp.ac.in': 'IIT Tirupati',
  '@iitpkd.ac.in': 'IIT Palakkad',
  '@iitjammu.ac.in': 'IIT Jammu',
  '@iitdh.ac.in': 'IIT Dharwad',
  '@iitbhilai.ac.in': 'IIT Bhilai',
};

var domains1 = {
  'All': 'All',
  'Nit Trichy': '@nitt.edu',
  'Nit Surathkal': '@nitk.edu.in',
  'Nit Rourkela': '@nitrkl.ac.in',
  'Nit Warangal': '@nitw.ac.in',
  'Nit Calicut': '@nitc.ac.in',
  'Nit Nagpur': '@vnit.ac.in',
  'Nit Durgapur': '@nitdgp.ac.in',
  'Nit Silchar': '@nits.ac.in',
  'Nit Jaipur': '@mnit.ac.in',
  'Nit Allahabad': '@mnnit.ac.in',
  'Nit Kurukshetra': '@nitkkr.ac.in',
  'Nit Jalandhar': '@nitj.ac.in',
  'Nit Surat': '@svnit.ac.in',
  'Nit Meghalaya': '@nitm.ac.in',
  'Nit Patna': '@nitp.ac.in',
  'Nit Raipur': '@nitrr.ac.in',
  'Nit Srinagar': '@nitsri.ac.in',
  'Nit Bhopal': '@manit.ac.in',
  'Nit Agarthala': '@nita.ac.in',
  'Nit Goa': '@nitgoa.ac.in',
  'Nit Jamshedpur': '@nitjsr.ac.in',
  'Nit Manipur': '@nitmanipur.ac.in',
  'Nit Hamper': '@nith.ac.in',
  'Nit Uttarakhand': '@nituk.ac.in',
  'Nit Puducherry': '@nitpy.ac.in',
  'Nit ArunaChalPradesh': '@nitap.ac.in',
  'Nit Sikkim': '@nitsikkim.ac.in',
  'Nit Delhi': '@nitdelhi.ac.in',
  'Nit Mizoram': '@nitmz.ac.in',
  'Nit Nagaland': '@nitnagaland.ac.in',
  'Nit AndhraPradesh': '@nitandhra.ac.in',

//IITS

  'IIT Madras': '@iitm.ac.in',
  'IIT Delhi': '@iitd.ac.in',
  'IIT Bombay': '@iitb.ac.in',
  'IIT Kanpur': '@iitk.ac.in',
  'IITR Rookee': '@iitr.ac.in',
  'IIT Kharagpur': '@iitkgp.ac.in',
  'IIT Guwahati': '@iitg.ac.in',
  'IIT Hyderabad': '@iith.ac.in',
  'IIT BHU': '@iitbhu.ac.in',
  'IIT ISM Dhanbad': '@iitism.ac.in',
  'IIT Indore': '@iiti.ac.in',
  'IIT Rupar': '@iitrpr.ac.in',
  'IIT Mandi': '@iitmandi.ac.in',
  'IIT Gandhinagar': '@iitgn.ac.in',
  'IIT Jodhpur': '@iitj.ac.in',
  'IIT Patna': '@iitp.ac.in',
  'IIT Bhubaneswar': '@iitbbs.ac.in',
  'IIT Tirupati': '@iittp.ac.in',
  'IIT Palakkad': '@iitpkd.ac.in',
  'IIT Jammu': '@iitjammu.ac.in',
  'IIT Dharwad': '@iitdh.ac.in',
  'IIT Bhilai': '@iitbhilai.ac.in'
};

List<String> domains_list2 = [
  'All',
  '@nitt.edu',
  '@nitk.edu.in',
  '@nitrkl.ac.in',
  '@nitw.ac.in',
  '@nitc.ac.in',
  '@vnit.ac.in',
  '@nitdgp.ac.in',
  '@nits.ac.in',
  '@mnit.ac.in',
  '@mnnit.ac.in',
  '@nitkkr.ac.in',
  '@nitj.ac.in',
  '@svnit.ac.in',
  '@nitm.ac.in',
  '@nitp.ac.in',
  '@nitrr.ac.in',
  '@nitsri.ac.in',
  '@manit.ac.in',
  '@nita.ac.in',
  '@nitgoa.ac.in',
  '@nitjsr.ac.in',
  '@nitmanipur.ac.in',
  '@nith.ac.in',
  '@nituk.ac.in',
  '@nitpy.ac.in',
  '@nitap.ac.in',
  '@nitsikkim.ac.in',
  '@nitdelhi.ac.in',
  '@nitmz.ac.in',
  '@nitnagaland.ac.in',
  '@nitandhra.ac.in',

//IITS

  '@iitm.ac.in',
  '@iitd.ac.in',
  '@iitb.ac.in',
  '@iitk.ac.in',
  '@iitr.ac.in',
  '@iitkgp.ac.in',
  '@iitg.ac.in',
  '@iith.ac.in',
  '@iitbhu.ac.in',
  '@iitism.ac.in',
  '@iiti.ac.in',
  '@iitrpr.ac.in',
  '@iitmandi.ac.in',
  '@iitgn.ac.in',
  '@iitj.ac.in',
  '@iitp.ac.in',
  '@iitbbs.ac.in',
  '@iittp.ac.in',
  '@iitpkd.ac.in',
  '@iitjammu.ac.in',
  '@iitdh.ac.in',
  '@iitbhilai.ac.in',
];

List<String> domains_list = [
  'All',
  'Nit Trichy',
  'Nit Surathkal',
  'Nit Rourkela',
  'Nit Warangal',
  'Nit Calicut',
  'Nit Nagpur',
  'Nit Durgapur',
  'Nit Silchar',
  'Nit Jaipur',
  'Nit Allahabad',
  'Nit Kurukshetra',
  'Nit Jalandhar',
  'Nit Surat',
  'Nit Meghalaya',
  'Nit Patna',
  'Nit Raipur',
  'Nit Srinagar',
  'Nit Bhopal',
  'Nit Agarthala',
  'Nit Goa',
  'Nit Jamshedpur',
  'Nit Manipur',
  'Nit Hamper',
  'Nit Uttarakhand',
  'Nit Puducherry',
  'Nit ArunaChalPradesh',
  'Nit Sikkim',
  'Nit Delhi',
  'Nit Mizoram',
  'Nit Nagaland',
  'Nit AndhraPradesh',

//IITS

  'IIT Madras',
  'IIT Delhi',
  'IIT Bombay',
  'IIT Kanpur',
  'IITR Rookee',
  'IIT Kharagpur',
  'IIT Guwahati',
  'IIT Hyderabad',
  'IIT BHU',
  'IIT ISM Dhanbad',
  'IIT Indore',
  'IIT Rupar',
  'IIT Mandi',
  'IIT Gandhinagar',
  'IIT Jodhpur',
  'IIT Patna',
  'IIT Bhubaneswar',
  'IIT Tirupati',
  'IIT Palakkad',
  'IIT Jammu',
  'IIT Dharwad',
  'IIT Bhilai',
];


//    path('', views.testing.as_view(),name = 'login'),
//    path('login', obtain_auth_token),
//    path('register', views.Register.as_view(),name = 'Register'),
//    path('get_user', views.GET_user.as_view(),name = 'GET_user'),
//    path('lost_found/list', views.LST_list.as_view(),name = 'LST_list'),
//    path('lost_found/comment_list', views.LST_Comment_list.as_view(),name = 'LST_Comment_list'),
//    path('post/list', views.POST_list.as_view(),name = 'POST_list'),
//    path('post/comment_list', views.PST_CMNT_list.as_view(),name = 'PST_CMNT_list'),
//    path('post/like_list', views.POST_LIKE_list.as_view(),name = 'POST_LIKE_list'),
//    path('event/list', views.EVENT_list.as_view(),name = 'EVENT_list'),
//    path('event/like_list', views.EVENT_LIKE_list.as_view(),name = 'EVENT_LIKE_list'),
//    path('alert/list', views.ALERT_list.as_view(),name = 'ALERT_list'),
//    path('alert/comment_list', views.ALERT_CMNT_list.as_view(),name = 'ALERT_comment_list'),
//    path('club_sport/list', views.CLUB_SPORT_list.as_view(),name = 'CLUB_SPORT_list'),
//    path('club_sport/edit', views.CLUB_SPORT_edit.as_view(),name = 'CLUB_SPORT_edit'),
//    path('club_sport/like_list', views.CLUB_SPORT_like_list.as_view(),name = 'CLUB_SPORT_like_list'),
//    path('club_sport/memb', views.CLUB_SPORT_MEMB.as_view(),name = 'CLUB_SPORT'),
//    path('profile/list', views.PEOFILE_list.as_view(),name = 'PEOFILE_list'),
//    path('sac/list', views.SAC_list.as_view(),name = 'SAC_list'),
//    path('mess/list', views.MESS_list.as_view(),name = 'ACADEMIC_list'),
//    path('academic/list', views.ACADEMIC_list.as_view(),name = 'ACADEMIC_list'),
//    path('notifications', views.Notifications.as_view(),name = 'Notifications'),
//    path('edit_notif_settings', views.EDIT_notif_settings.as_view(),name = 'EDIT_notif_settings'),
// MESSANGER
//    path('messanger1', views.Messanger.as_view(),name = 'Messanger1'),
//    path('user_messanger1', views.USER_Messanger.as_view(),name = 'user_messanger1'),
//CALENDER_EVENT
//    path('all_branches/list1', views.ALL_BRANCHES.as_view(),name = 'ALL_BRANCHES'),
//    path('cal_dates_subs/list1', views.CALENDER_DATE_SUBS.as_view(),name = 'CALENDER_DATE_SUBS'),   #include subjects
//    path('cal_sub_years/list1', views.CALENDER_SUB_YEARS.as_view(),name = 'CALENDER_SUB_YEARS'),
//    path('calender_sub_files1', views.CALENDER_SUB_FILES.as_view(),name = 'CALENDER_SUB_FILES'),
//    path('cal_events/list1', views.CALENDER_EVENTS_list.as_view(),name = 'CALENDER_EVENTS_list'),
//    path('ratings', views.RATINGS.as_view(),name = 'RATINGS'),

//   path('security1', views.SECURITY.as_view(),name = 'SECURITY1'),
