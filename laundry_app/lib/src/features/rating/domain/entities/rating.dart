class Rating {
  final String? id;
  final int stars;
  final List<String> feedbackTags;
  final String? comment;
  final DateTime? createdAt;

  Rating({
    this.id,
    required this.stars,
    required this.feedbackTags,
    this.comment,
    this.createdAt,
  });

  bool get isValid => stars > 0;
}