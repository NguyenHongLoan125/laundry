import 'package:laundry_app/src/features/service/domain/entities/service.dart';

class ServiceModel extends Service {
  ServiceModel({
    required super.name,
    required super.description,
    required super.icon,
    required super.type,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      type: (json['is_main'] ?? false) ? 'main' : 'extra',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'is_main': type == 'main',
    };
  }

  Service toEntity() {
    return Service(
      name: name,
      description: description,
      icon: icon,
      type: type,
    );
  }
}