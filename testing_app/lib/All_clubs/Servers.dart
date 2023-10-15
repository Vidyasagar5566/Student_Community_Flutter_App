import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:io';

class all_clubs_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// CLUBS LIST FUNCTIONS

  Future<List<ALL_CLUBS>> get_clubs_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'domain': domain};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/allclubs?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
      );
      var data = json.decode(response.body) as List;
      List<ALL_CLUBS> temp = [];
      data.forEach((element) {
        ALL_CLUBS post = ALL_CLUBS.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<ALL_CLUBS> temp = [];
      return temp;
    }
  }

  Future<bool> edit_club_list(
    int id,
    File image,
    String title,
    String name,
    String team_members,
    String description,
    String websites,
    String image_type,
  ) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/allclubs";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (image_type == "file") {
        base64file = base64Encode(image.readAsBytesSync());
        fileName = image.path.split("/").last;
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
          'title': title,
          'name': name,
          'team_members': team_members,
          'description': description,
          'websites': websites,
          'image_type': image_type,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> change_club_head(int id, String new_head_email) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/allclubs";
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

// CLUBS_LIKES

  Future<bool> post_club_like(int club_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/club/likes";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'club_id': club_id,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_club_like(int club_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'club_id': club_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/club/likes?$queryString";
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

// CLUB__MEMBS

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