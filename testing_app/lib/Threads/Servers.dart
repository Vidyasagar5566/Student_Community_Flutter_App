import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';

class threads_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

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
}
