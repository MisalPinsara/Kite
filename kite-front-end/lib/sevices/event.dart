import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/events.dart';

class EventServices {
  final String baseUrl = "https://vambraced-unappreciably-bebe.ngrok-free.dev";

  Future<List<Event>> getAllEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    }
    return [];
  }

  Future<Event?> getEvent(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$id'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Event.fromJson(data);
    }
    return null;
  }

  Future<bool> updateEvent(Event event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/${event.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode(event.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<List<Event>> getMyEvents(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/myEvents/$userId'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> joinEvent(int userId, int eventId, String registeredMail) async {
    final response = await http.post(
      Uri.parse('$baseUrl/myEvents'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode({"UserId": userId, "EventId": eventId, "registeredMail": registeredMail}),
    );
    return response.statusCode == 201;
  }

  Future<bool> leaveEvent(int userId, int eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/myEvents/$userId/$eventId'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> updateRegisteredMail(int userId, int eventId, String newMail) async {
    final response = await http.put(
      Uri.parse('$baseUrl/myEvents/$userId/$eventId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode({"registeredMail": newMail}),
    );
    return response.statusCode == 200;
  }
}
