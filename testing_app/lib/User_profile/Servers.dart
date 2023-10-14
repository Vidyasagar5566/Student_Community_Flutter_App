import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '/Posts/Models.dart';
import 'dart:convert';
import 'dart:io';

class user_profile_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

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
}
