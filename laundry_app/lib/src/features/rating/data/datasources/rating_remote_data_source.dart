import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<bool> submitRating(RatingModel rating);
  Future<List<String>> fetchFeedbackOptions();
}

// ✅ CÁCH 1: API THẬT
class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RatingRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<bool> submitRating(RatingModel rating) async {
    final response = await client.post(
      Uri.parse('$baseUrl/ratings/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rating.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to submit rating: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> fetchFeedbackOptions() async {
    final response = await client.get(
      Uri.parse('$baseUrl/ratings/feedback-options'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => e as String).toList();
    } else {
      throw Exception('Failed to fetch feedback options: ${response.statusCode}');
    }
  }
}

// ✅ CÁCH 2: DỮ LIỆU GIẢ (MOCK)
class RatingMockDataSource implements RatingRemoteDataSource {
  @override
  Future<bool> submitRating(RatingModel rating) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simulate successful submission
    print('✅ Mock: Rating submitted successfully');
    print('   Stars: ${rating.stars}');
    print('   Tags: ${rating.feedbackTags.join(", ")}');
    print('   Comment: ${rating.comment ?? "No comment"}');

    return true;
  }

  @override
  Future<List<String>> fetchFeedbackOptions() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      'UI dễ không phản hồi',
      'Quán đổi bị lẻm mâu',
      'Dùng không đúng loại nước giặt / nước xả',
      'Giặt chưa sạch',
      'Tẩy chưa trắng',
    ];
  }
}