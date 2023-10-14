import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class servers {
  LocalStorage storage = LocalStorage("usertoken");
  String base_url = 'http://StudentCommunity.pythonanywhere.com';
}
