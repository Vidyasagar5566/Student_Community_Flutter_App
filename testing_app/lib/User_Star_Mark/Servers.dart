import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class user_star_mark_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

  // CREATE USER BY SUPER USER

  Future<bool> updating_user_star_mark(
      String email, String user_mark, int star_mark) async {
    try {
      var path = Uri.parse("$base_url/register/email_check2");
      var response = await http.post(path,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'email': email,
            'user_mark': user_mark,
            'star_mark': star_mark,
          }));
      var data = jsonDecode(response.body) as Map;

      return data['error'];
    } catch (e) {
      print(e);
      return true;
    }
  }
}
