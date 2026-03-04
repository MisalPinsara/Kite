import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserServices {
  final String baseUrl = "https://vambraced-unappreciably-bebe.ngrok-free.dev";

  Future<User?> getUser(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/login/$username'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }

    if (response.statusCode == 404) {
      return null;
    }
    return null;
  }

  Future<bool> postUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode(user.toJson()),
    );
    return (response.statusCode == 201);
  }

  Future<bool> putUser(User user) async {
  if (user.id == null) {
    print("User ID is null!");
    return false;
  }
    final int? userId = user.id;
    final response = await http.put(
      Uri.parse('$baseUrl/users/update/$userId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode(user.toJson()),
    );

    return (response.statusCode == 200);
  }

  Future<bool> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/delete/$userId'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );
    return response.statusCode == 200;
  }
}
