import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'package:testing_app/User_profile/Models.dart';

class sac_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// SAC LIST FUNCTIONS
  Future<List<Username>> get_sac_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/sac/list1?$queryString";
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
