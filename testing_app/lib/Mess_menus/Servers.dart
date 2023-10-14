import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';


class mess_menu_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// MESS LIST FUNCTIONS

  Future<List<MESS_LIST>> get_mess_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/mess/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<MESS_LIST> temp = [];
      data.forEach((element) {
        MESS_LIST post = MESS_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<MESS_LIST> temp = [];
      //return temp;
      return temp;
    }
  }
}
