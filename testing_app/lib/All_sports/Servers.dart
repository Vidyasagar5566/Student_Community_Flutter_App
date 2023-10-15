import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';

class all_sports_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// CLUBS_OR_SPORTS LIST FUNCTIONS

  Future<List<ALL_SPORTS>> get_sport_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'domain': domain};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/allsports?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<ALL_SPORTS> temp = [];
      data.forEach((element) {
        ALL_SPORTS post = ALL_SPORTS.fromJson(element);
        temp.add(post);
      });
      print(temp);
      return temp;
    } catch (e) {
      print(e);
      List<ALL_SPORTS> temp = [];
      return temp;
    }
  }

  Future<bool> edit_sport_list(
      int id,
      File image,
      String title,
      String name,
      String team_members,
      String description,
      String websites,
      String sport_ground,
      File image1,
      String image_type,
      String image2_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/allsports";
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

      http.Response response = await http.put(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'id': id,
          'file': base64file,
          'file_name': fileName,
          'file1': base64file1,
          'file_name1': fileName1,
          'title': title,
          'name': name,
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

  Future<bool> change_sport_head(int id, String new_head_email) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/allsports";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'id': id, 'new_head_email': new_head_email}),
      );
      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CLUBS_SPORTS_LIKES

  Future<bool> post_sport_like(int sport_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/sport/likes";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'sport_id': sport_id,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_sport_like(int sport_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'sport_id': sport_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/sport/likes?$queryString";
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

  Future<List<Username>> get_club_sprt_fest_membs(String team_mem) async {
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
}






// #CLUBS/SPORTS/FESTS
//     path('allclubs', views.ALLCLUBS_list.as_view(),name = 'ALLCLUBS_list'),
//     path('club/likes', views.CLUB_like_list.as_view(),name = 'CLUB_like_list'),
//     path('allsports', views.ALLSPORTS_list.as_view(),name = 'ALLSPORTS_list'),
//     path('sport/likes', views.SPORT_like_list.as_view(),name = 'SPORT_like_list'),
//     path('allfests', views.ALLFESTS_list.as_view(),name = 'ALLFESTS_list'),
//     path('fest/likes', views.FEST_like_list.as_view(),name = 'FEST_like_list'),

//     path('club_sport_fest/mems', views.CLUB_SPORT_FEST_MEMB.as_view(),name = 'CLUB_SPORT_FEST_MEMB'),