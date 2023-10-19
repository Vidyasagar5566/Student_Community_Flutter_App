import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'Models.dart';
import 'dart:convert';

class timings_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

// ACADEMIC LIST FUNCTIONS

  Future<List<ACADEMIC_LIST>> get_academic_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/academic?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });
      var data = json.decode(response.body) as List;
      List<ACADEMIC_LIST> temp = [];
      data.forEach((element) {
        ACADEMIC_LIST post = ACADEMIC_LIST.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<ACADEMIC_LIST> temp = [];
      return temp;
      //return temp;
    }
  }

  Future<bool> post_academic_list(
    int id,
    String domain,
    String academic_name,
    String sun,
    String mon,
    String tues,
    String wed,
    String thu,
    String fri,
    String sat,
  ) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/academic";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'id': id,
            'domain': domain,
            'academic_name': academic_name,
            'sun': sun,
            'mon': mon,
            'tues': tues,
            'wed': wed,
            'thu': thu,
            'fri': fri,
            'sat': sat,
          }));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
      //return temp;
    }
  }
}

    // path('sac', views.SAC_list.as_view(),name = 'SAC_list1'),
    // path('mess', views.MESS_list.as_view(),name = 'ACADEMIC_list1'),
    // path('academic', views.ACADEMIC_list.as_view(),name = 'ACADEMIC_list1'),