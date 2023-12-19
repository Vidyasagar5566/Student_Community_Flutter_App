import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';
import '/User_profile/Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class sac_servers {
  LocalStorage storage = LocalStorage("usertoken");

// SAC LIST FUNCTIONS
  Future<List<SAC_MEMS>> get_sac_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/sac?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<SAC_MEMS> temp = [];
      data.forEach((element) {
        SAC_MEMS post = SAC_MEMS.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<SAC_MEMS> temp = [];
      return temp;
    }
  }

  Future<bool> create_sac(String email, String role) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/sac";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'email': email, 'role': role}),
      );
      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> edit_sac_mem(
    int id,
    File image,
    String role,
    String email,
    String phone_num,
    String description,
    String image_type,
  ) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/sac";
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
          'role': role,
          'email': email,
          'phone_num': phone_num,
          'description': description,
          'image_type': image_type,
        }),
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> change_sac_head(int id, String new_head_email) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/sac";
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
      String finalUrl = "$base_url/user_messanger?$queryString";
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



    // path('sac', views.SAC_list.as_view(),name = 'SAC_list1'),
    // path('mess', views.MESS_list.as_view(),name = 'ACADEMIC_list1'),
    // path('academic', views.ACADEMIC_list.as_view(),name = 'ACADEMIC_list1'),
