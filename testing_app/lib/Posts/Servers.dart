import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';

class post_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

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
      print(e);
      List<POST_LIST> temp = [];
      return Future.value(temp);
    }
  }

  Future<bool> post_post(String description, File file, String image_ratio,
      String all_university, String category, int category_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/post/list1?";
      var url = Uri.parse(finalUrl);
      String base64file = "";
      String fileName = "";
      if (image_ratio != '0') {
        base64file = base64Encode(file.readAsBytesSync());
        fileName = file.path.split("/").last;
      }

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
          'is_all_university': is_all_university,
          'category': category,
          'category_id': category_id
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
}
