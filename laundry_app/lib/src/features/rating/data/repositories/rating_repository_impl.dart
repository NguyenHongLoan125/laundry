import '../../domain/entities/rating.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_data_source.dart';
import '../models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> submitRating(Rating rating) async {
    final model = RatingModel(
      id: rating.id,
      stars: rating.stars,
      feedbackTags: rating.feedbackTags,
      comment: rating.comment,
      createdAt: rating.createdAt,
    );
    return await remoteDataSource.submitRating(model);
  }

  @override
  Future<List<String>> getFeedbackOptions() async {
    return await remoteDataSource.fetchFeedbackOptions();
  }
}