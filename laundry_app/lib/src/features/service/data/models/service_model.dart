class ServiceModel {
  final String name;
  final String description;
  final String icon;
  final String type; // main / extra

  ServiceModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      type: (json['is_main'] ?? false) ? 'main' : 'extra',
    );
  }

}
