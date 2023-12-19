import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class bs_servers {
  LocalStorage storage = LocalStorage("usertoken");

//  LOST AND FOUNDS POST FUNCTIONS

  Future<List<Buy_Sell>> get_lst_list(int num_list, String domain, String tag,
      String category, String email) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'num_list': num_list.toString(),
        'domain': domain,
        "tag": tag,
        "category": category,
        'email': email
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/buy_sell/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<Buy_Sell> temp = [];
      data.forEach((element) {
        Buy_Sell post = Buy_Sell.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<Buy_Sell> temp = [];
      return Future.value(temp);
    }
  }

  Future<bool> post_lst(String title, String description, File file,
      String image_ratio, String tag, String category) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/buy_sell/list1";
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
          'tag': tag,
          'category': category
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
      String finalUrl = "$base_url/buy_sell/list1?$queryString";
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
      String finalUrl = "$base_url/buy_sell/list1?$queryString";
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

  Future<List<BS_CMNT>> get_lst_cmnt_list(int lst_id) async {
    try {
      Map<String, String> queryParameters = {
        'lst_id': lst_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      var token = storage.getItem('token');
      String finalUrl = "$base_url/buy_sell/comment_list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<BS_CMNT> temp = [];
      data.forEach((element) {
        BS_CMNT post = BS_CMNT.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<BS_CMNT> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> post_lst_cmnt(String comment, int lst_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/buy_sell/comment_list1";
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
      String finalUrl = "$base_url/buy_sell/comment_list1?$queryString";
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
