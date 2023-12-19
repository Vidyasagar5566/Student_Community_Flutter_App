import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class report_servers {
  LocalStorage storage = LocalStorage("usertoken");

  Future<List<dynamic>> report_upload(
      String description, String report_belongs) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/security1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {'description': description, 'report_belongs': report_belongs}));
      var data = json.decode(response.body) as Map;
      return [data['error'], data['id']];
    } catch (e) {
      return [true, 0];
    }
  }

  Future<bool> report_delete(int report_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'report_id': report_id.toString()};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/security1?$queryString";
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
