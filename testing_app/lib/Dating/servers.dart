import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '/User_profile/Models.dart';
import 'dart:convert';
import 'models.dart';
import 'dart:io';

class dating_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'https://StudentCommunity.pythonanywhere.com';

//  Dating FUNCTIONS

  Future<List<DatingUser>> get_dating_user_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {'domain': domain};
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/datingUser?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<DatingUser> temp = [];
      data.forEach((element) {
        DatingUser post = DatingUser.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<DatingUser> temp = [];
      return Future.value(temp);
    }
  }

  Future<bool> post_dating_user(
      String dummyName, String dummyBio, File file, String dummyDomain) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/datingUser";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'dummyName': dummyName,
          'dummyBio': dummyBio,
          'file': base64file,
          'file_name': fileName,
          'dummyDomain': dummyDomain,
        }),
      );

      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

  //EDIT

  Future<bool> inc_dating_user_chat(String dating_user_email) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/datingUser";
      var url = Uri.parse(finalUrl);

      http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'dating_user_email': dating_user_email}),
      );

      var data = json.decode(response.body) as Map;
      return data['error'];
    } catch (e) {
      return true;
    }
  }

  Future<bool> delete_dating_user() async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/datingUser";
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

  // DatingProfiles
  Future<List<DatingUser>> get_uuids_to_dating_user_profiles(
      String user_uuids) async {
    try {
      var token = storage.getItem('token');

      String finalUrl = "$base_url/datingUser";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'datedUuids': user_uuids,
          }));
      var data = json.decode(response.body) as List;
      List<DatingUser> temp = [];
      data.forEach((element) {
        DatingUser post = DatingUser.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<DatingUser> temp = [];
      return temp;
    }
  }

  // USER MESSAGES NOTIFICATION

  Future<bool> user_messages_notif(
      String chattinguser_email, String message) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'chattinguser_email': chattinguser_email,
        'message': message,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/user_messanger?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.patch(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
      );
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// DATING USER REACTIONS

  Future<bool> dating_user_post_reaction(
      String dating_user_email, int Reaction) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/datingUserReaction";
      var url = Uri.parse(finalUrl);

      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'token $token',
          "Content-Type": "application/json",
        },
        body: jsonEncode(
            {'dating_user_email': dating_user_email, 'Reaction': Reaction}),
      );

      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }
}
