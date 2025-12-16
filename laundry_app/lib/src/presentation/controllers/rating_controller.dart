import 'package:flutter/material.dart';
import '../../features/rating/domain/entities/rating.dart';
import '../../features/rating/domain/usecases/submit_rating_usecase.dart';
import '../../features/rating/domain/usecases/get_feedback_options_usecase.dart';

class RatingController extends ChangeNotifier {
  final SubmitRatingUsecase submitRatingUsecase;
  final GetFeedbackOptionsUsecase getFeedbackOptionsUsecase;

  int selectedStars = 0;
  List<String> selectedFeedbackTags = [];
  TextEditingController commentController = TextEditingController();

  List<String> feedbackOptions = [];
  bool isLoading = false;
  bool isSubmitting = false;
  String? error;
  bool _disposed = false;

  RatingController({
    required this.submitRatingUsecase,
    required this.getFeedbackOptionsUsecase,
  });

  @override
  void dispose() {
    _disposed = true;
    commentController.dispose();
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> loadFeedbackOptions() async {
    try {
      isLoading = true;
      error = null;
      _safeNotify();

      feedbackOptions = await getFeedbackOptionsUsecase();
    } catch (e) {
      error = 'Không thể tải danh sách phản hồi: $e';
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  void selectStar(int stars) {
    selectedStars = stars;
    _safeNotify();
  }

  void toggleFeedbackTag(String tag) {
    if (selectedFeedbackTags.contains(tag)) {
      selectedFeedbackTags.remove(tag);
    } else {
      selectedFeedbackTags.add(tag);
    }
    _safeNotify();
  }

  Future<bool> submitRating() async {
    try {
      isSubmitting = true;
      error = null;
      _safeNotify();

      final rating = Rating(
        stars: selectedStars,
        feedbackTags: selectedFeedbackTags,
        comment: commentController.text.trim().isEmpty
            ? null
            : commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      final success = await submitRatingUsecase(rating);

      if (success) {
        // Reset form after successful submission
        selectedStars = 0;
        selectedFeedbackTags.clear();
        commentController.clear();
      }

      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSubmitting = false;
      _safeNotify();
    }
  }

  void reset() {
    selectedStars = 0;
    selectedFeedbackTags.clear();
    commentController.clear();
    error = null;
    _safeNotify();
  }
}