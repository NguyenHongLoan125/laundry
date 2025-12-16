import '../repositories/rating_repository.dart';

class GetFeedbackOptionsUsecase {
  final RatingRepository repository;

  GetFeedbackOptionsUsecase(this.repository);

  Future<List<String>> call() async {
    return await repository.getFeedbackOptions();
  }
}