import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class register_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'https://StudentCommunity.pythonanywhere.com';

  // CREATE USER BY SUPER USER

  Future<bool> updating_required_user_details(String email, String username,
      String course, int year, String branch) async {
    try {
      var path = Uri.parse("$base_url/register/email_check2");
      var response = await http.post(path,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'email': email,
            'username': username,
            'course': course,
            'year': year,
            'branch': branch
          }));
      var data = jsonDecode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }
}
