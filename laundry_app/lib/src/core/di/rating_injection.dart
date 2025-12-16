import 'package:http/http.dart' as http;
import '../../features/rating/data/datasources/rating_remote_data_source.dart';
import '../../features/rating/data/repositories/rating_repository_impl.dart';
import '../../features/rating/domain/usecases/submit_rating_usecase.dart';
import '../../features/rating/domain/usecases/get_feedback_options_usecase.dart';
import '../../presentation/controllers/rating_controller.dart';

class RatingInjection {
  // ✅ CÁCH 1: Dùng API thật
  static RatingController createRatingControllerWithAPI(String baseUrl) {
    final dataSource = RatingRemoteDataSourceImpl(
      client: http.Client(),
      baseUrl: baseUrl,
    );
    final repository = RatingRepositoryImpl(remoteDataSource: dataSource);
    final submitRating = SubmitRatingUsecase(repository);
    final getFeedbackOptions = GetFeedbackOptionsUsecase(repository);

    return RatingController(
      submitRatingUsecase: submitRating,
      getFeedbackOptionsUsecase: getFeedbackOptions,
    );
  }

  // ✅ CÁCH 2: Dùng mock data
  static RatingController createRatingControllerWithMock() {
    final dataSource = RatingMockDataSource();
    final repository = RatingRepositoryImpl(remoteDataSource: dataSource);
    final submitRating = SubmitRatingUsecase(repository);
    final getFeedbackOptions = GetFeedbackOptionsUsecase(repository);

    return RatingController(
      submitRatingUsecase: submitRating,
      getFeedbackOptionsUsecase: getFeedbackOptions,
    );
  }

  // ✅ Universal method
  static RatingController createRatingController({
    bool useMockData = true,
    String? apiBaseUrl,
  }) {
    if (useMockData) {
      return createRatingControllerWithMock();
    } else {
      if (apiBaseUrl == null) {
        throw ArgumentError('API base URL is required when useMockData is false');
      }
      return createRatingControllerWithAPI(apiBaseUrl);
    }
  }
}
