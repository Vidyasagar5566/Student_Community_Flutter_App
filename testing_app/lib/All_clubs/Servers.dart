import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:io';

class all_clubs_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';


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
}