import '../entities/rating.dart';
abstract class RatingRepository {
  Future<bool> submitRating(Rating rating);
  Future<List<String>> getFeedbackOptions();
}