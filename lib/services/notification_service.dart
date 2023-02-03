import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todoapp/screens/add_page.dart';

class notificationService {
  final baseurl = 'http://mgmapi.sunin.in/api/';
  final url = 'http://localhost:9152/api/';
  static Future<bool> deleteById(int id) async {
    final url = 'http://mgmapi.sunin.in/api/Notifications/$id';
    final uri = Uri.parse(url);
    final response =
        await http.delete(uri, headers: {'Content-Type': 'application/json'});
    return response.statusCode == 200;
  }

//if put '?' after list it will allow return null;
  static Future<List?> fetchTodos() async {
    final url = 'http://mgmapi.sunin.in/api/Notifications';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json as List;
      return result;
    } else {
      //error
      return null;
    }
  }

  static Future<bool> addTodo(Map body) async {
    final url = 'http://localhost:9152/api/Notifications';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 201;
  }
}
