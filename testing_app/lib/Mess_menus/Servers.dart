import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import '../Servers_Fcm_Notif_Domains/servers.dart';

class mess_menu_servers {
  LocalStorage storage = LocalStorage("usertoken");

// MESS LIST FUNCTIONS

  Future<List<MESS_LIST>> get_mess_list(String domain) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'domain': domain,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/mess?$queryString";
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


    // path('sac', views.SAC_list.as_view(),name = 'SAC_list1'),
    // path('mess', views.MESS_list.as_view(),name = 'ACADEMIC_list1'),
    // path('academic', views.ACADEMIC_list.as_view(),name = 'ACADEMIC_list1'),