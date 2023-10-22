import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:testing_app/All_clubs/Models.dart';
import 'package:testing_app/All_fests/Models.dart';
import 'package:testing_app/All_sports/Models.dart';
import 'package:testing_app/All_sports/Uploads.dart';
import 'package:testing_app/SAC/Models.dart';
import '/Posts/Models.dart';
import 'dart:convert';
import 'dart:io';
import 'package:testing_app/Threads/Models.dart';
import 'package:testing_app/Activities/Models.dart';

class user_profile_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

  // USER PROFILE UPDATE
  Future<bool> edit_profile2(
      String username,
      String phone_number,
      File file,
      String file_type,
      String course,
      String branch,
      int year,
      String bio,
      String batch) async {
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
            'file_type': file_type,
            'course': course,
            'branch': branch,
            'year': year,
            'bio': bio,
            'batch': batch
          }));
      var data = json.decode(response.body) as Map;
      print(data['error']);
      return data['error'];
    } catch (e) {
      return true;
    }
  }

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

  // GET ALL CLUB AND ETC.. BASED ON HIS PROFILE
  Future<Map<List<dynamic>, List<dynamic>>> get_all_type_category_data(
      String category, String head_ids, String member_ids) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/profile/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'category': category,
            'head_ids': head_ids,
            'member_ids': member_ids
          }));
      var data = json.decode(response.body) as List;
      if (category == 'club') {
        List<ALL_CLUBS> heads = [];
        data[0].forEach((element) {
          ALL_CLUBS post = ALL_CLUBS.fromJson(element);
          heads.add(post);
        });
        List<ALL_CLUBS> mems = [];
        data[1].forEach((element) {
          ALL_CLUBS post = ALL_CLUBS.fromJson(element);
          mems.add(post);
        });
        return {heads: mems};
      } else if (category == 'sport') {
        List<ALL_SPORTS> heads = [];
        data[0].forEach((element) {
          ALL_SPORTS post = ALL_SPORTS.fromJson(element);
          heads.add(post);
        });
        List<ALL_SPORTS> mems = [];
        data[1].forEach((element) {
          ALL_SPORTS post = ALL_SPORTS.fromJson(element);
          mems.add(post);
        });
        return {heads: mems};
      } else if (category == 'fest') {
        List<ALL_FESTS> heads = [];
        data[0].forEach((element) {
          ALL_FESTS post = ALL_FESTS.fromJson(element);
          heads.add(post);
        });
        List<ALL_FESTS> mems = [];
        data[1].forEach((element) {
          ALL_FESTS post = ALL_FESTS.fromJson(element);
          mems.add(post);
        });
        return {heads: mems};
      } else if (category == 'sac') {
        List<SAC_MEMS> heads = [];
        data[0].forEach((element) {
          SAC_MEMS post = SAC_MEMS.fromJson(element);
          heads.add(post);
        });
        List<SAC_MEMS> mems = [];
        data[1].forEach((element) {
          SAC_MEMS post = SAC_MEMS.fromJson(element);
          mems.add(post);
        });
        return {heads: mems};
      }
      return {[]: []};
    } catch (e) {
      print(e);
      return {[]: []};
    }
  }
}
