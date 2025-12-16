import '../../domain/entities/rating.dart';

class RatingModel extends Rating {
  RatingModel({
    String? id,
    required int stars,
    required List<String> feedbackTags,
    String? comment,
    DateTime? createdAt,
  }) : super(
    id: id,
    stars: stars,
    feedbackTags: feedbackTags,
    comment: comment,
    createdAt: createdAt,
  );

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String?,
      stars: json['stars'] as int,
      feedbackTags: (json['feedback_tags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'stars': stars,
    'feedback_tags': feedbackTags,
    'comment': comment,
    'created_at': createdAt?.toIso8601String(),
  };
}