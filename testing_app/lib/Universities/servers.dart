import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '../Servers_Fcm_Notif_Domains/servers.dart';
import 'Models.dart';

class universityServers {
  LocalStorage storage = LocalStorage("usertoken");

// GETTING UNIVERSITIES LIST
  Future<List<Universities>> getUniversities() async {
    try {
      var path = Uri.parse("$base_url/login2_token");
      var response = await http.get(
        path,
        headers: {
          "Content-Type": "application/json",
        },
      );
      var data = jsonDecode(response.body) as List;
      List<Universities> temp = [];
      data.forEach((element) {
        Universities post = Universities.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      return [];
    }
  }
}
