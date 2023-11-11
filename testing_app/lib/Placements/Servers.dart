import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'Models.dart';
import 'dart:io';

class placemeny_servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';

//PLACEMENTS OR SUBJECTS

  Future<List<CAL_SUB_NAMES>> get_sub_place_list(
      String sub_id, String domain, String course) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'sub_id': sub_id,
        'domain': domain,
        'course': course
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_dates_subs/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<CAL_SUB_NAMES> temp = [];
      data.forEach((element) {
        CAL_SUB_NAMES post = CAL_SUB_NAMES.fromJson(element);
        temp.add(post);
      });
      return temp;
    } catch (e) {
      List<CAL_SUB_NAMES> temp = [];
      //return temp;
      return [];
    }
  }

  Future<List<dynamic>> post_cal_sub(
      String sub_name, String sub_id, bool InternCompany) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_dates_subs/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'sub_name': sub_name,
            'sub_id': sub_id,
            "InternCompany": InternCompany
          }));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  Future<bool> edit_cal_sub(String sub_name, String sub_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_dates_subs/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'sub_name': sub_name, 'sub_id': sub_id}));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CALENDER SUB YEARS

  Future<List<CAL_SUB_YEARS>> get_sub_years_list(String sub_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'sub_id': sub_id,
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/cal_sub_years/list1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<CAL_SUB_YEARS> temp = [];
      data.forEach((element) {
        CAL_SUB_YEARS post = CAL_SUB_YEARS.fromJson(element);
        temp.add(post);
      });

      return temp;
    } catch (e) {
      print("error");
      List<CAL_SUB_YEARS> temp = [];
      return temp;
    }
  }

  Future<List<dynamic>> add_cal_sub_year(
      String sub_id, String year_name, bool private) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_sub_years/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {'sub_id': sub_id, 'year_name': year_name, 'private': private}));
      var data = json.decode(response.body) as Map;

      print(data);

      return [data['error'], data['id']];
    } catch (e) {
      print('error');
      return [true, '-1'];
    }
  }

  Future<bool> edit_cal_year(
      String year_name, String year_id, bool private) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/cal_sub_years/list1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'year_name': year_name,
            'year_id': year_id,
            'private': private
          }));
      var data = json.decode(response.body) as Map;

      return data['error'];
    } catch (e) {
      return true;
    }
  }

// CALENDER LIST FUNCTIONS  for files

  Future<List<CAL_SUB_FILES>> get_sub_files_list(String year_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'year_id': year_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/calender_sub_files1?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<CAL_SUB_FILES> temp = [];
      data.forEach((element) {
        CAL_SUB_FILES post = CAL_SUB_FILES.fromJson(element);
        temp.add(post);
      });

      return temp;
    } catch (e) {
      List<CAL_SUB_FILES> temp = [];
      print(temp);
      //return temp;
      return [];
    }
  }

  Future<List<dynamic>> post_cal_sub_files(
      File file, String year_id, String file_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/calender_sub_files1";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            'file': base64file,
            'file_name': fileName,
            'description': "",
            'year_id': year_id,
            "file_type": file_type,
          }));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  Future<bool> delete_sub_files_list(String id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/calender_sub_files1";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'id': id}));
      var data = json.decode(response.body) as Map;

      print(data);
      return data['error'];
    } catch (e) {
      print('error');
      return true;
    }
  }

  Future<List<dynamic>> edit_cal_sub_files(String file_email, int id, File file,
      String year_id, String file_type) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/calender_sub_files1";
      var url = Uri.parse(finalUrl);
      String base64file = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      http.Response response = await http.put(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "file_email": file_email,
            'id': id,
            'file': base64file,
            'file_name': fileName,
            'description': "",
            'year_id': year_id,
            "file_type": file_type,
          }));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  // RATINGS

  Future<List<RATINGS>> get_sub_ratings_list(String sub_id) async {
    try {
      var token = storage.getItem('token');
      Map<String, String> queryParameters = {
        'sub_id': sub_id.toString(),
      };
      String queryString = Uri(queryParameters: queryParameters).query;
      String finalUrl = "$base_url/ratings?$queryString";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.get(url, headers: {
        'Authorization': 'token $token',
        "Content-Type": "application/json",
      });

      var data = json.decode(response.body) as List;
      List<RATINGS> temp = [];
      data.forEach((element) {
        RATINGS post = RATINGS.fromJson(element);
        temp.add(post);
      });

      return temp;
    } catch (e) {
      List<RATINGS> temp = [];
      print(e);
      return temp;
    }
  }

  Future<List<dynamic>> post_sub_rating(
      int rating, String review, String sub_id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/ratings";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.post(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {'rating': rating, 'sub_id': sub_id, 'review': review}));
      var data = json.decode(response.body) as Map;

      return [data['error'], data['id']];
    } catch (e) {
      return [true, -1];
    }
  }

  Future<bool> delete_sub_rating(String id) async {
    try {
      var token = storage.getItem('token');
      String finalUrl = "$base_url/ratings";
      var url = Uri.parse(finalUrl);
      http.Response response = await http.delete(url,
          headers: {
            'Authorization': 'token $token',
            "Content-Type": "application/json",
          },
          body: jsonEncode({'id': id}));
      var data = json.decode(response.body) as Map;

      print(data);
      return data['error'];
    } catch (e) {
      print('error');
      return true;
    }
  }
}
