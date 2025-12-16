import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class SubmitRatingUsecase {
  final RatingRepository repository;

  SubmitRatingUsecase(this.repository);

  Future<bool> call(Rating rating) async {
    if (!rating.isValid) {
      throw Exception('Vui lòng chọn số sao để đánh giá');
    }
    return await repository.submitRating(rating);
  }
}