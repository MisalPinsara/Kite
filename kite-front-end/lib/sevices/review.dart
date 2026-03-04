import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewServices {
  final String baseUrl = "https://vambraced-unappreciably-bebe.ngrok-free.dev";

  Future<List<Review>> getReviews(int eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reviews'),
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Review.fromJson(json))
          .where((review) => review.eventId == eventId)
          .toList();
    }
    return [];
  }

  Future<bool> postReview(Review review) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode(review.toJson()),
    );
    return response.statusCode == 201;
  }
}
