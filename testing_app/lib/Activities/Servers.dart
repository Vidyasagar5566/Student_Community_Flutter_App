import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';
import 'package:testing_app/User_profile/Models.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';

class activity_servers {
  LocalStorage storage = LocalStorage("usertoken");

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

  Future<bool> post_event(
      String title,
      String description,
      File file,
      String image_ratio,
      String date,
      String all_university,
      String category,
      String category_id) async {
    try {
      print(category);
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
          'is_all_university': is_all_university,
          'category': category,
          'category_id': category_id
        }),
      );
      var data = json.decode(response.body) as Map;

      print(data);
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

  Future<List<EVENT_LIKES>> get_likes_list(int event_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'event_id': event_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/event/like_list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<EVENT_LIKES> temp = [];
      data.forEach((element) {
        EVENT_LIKES post = EVENT_LIKES.fromJson(element);
        temp.add(post);
      });
      print(temp);
      return temp;
    } catch (e) {
      print(e);
      List<EVENT_LIKES> temp = [];
      return temp;
    }
  }

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
}
