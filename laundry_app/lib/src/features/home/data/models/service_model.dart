// import '../../domain/entities/serrvice.dart';
//
// class ServiceModel extends Service {
//   ServiceModel({
//     required super.id,
//     required super.name,
//     super.description,
//   });
//
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'],
//     );
//   }
// }

import '../../domain/entities/serrvice.dart';

class ServiceModel extends Service {
  ServiceModel({
    required super.id,
    required super.name,
    super.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['service_name'] ?? json['name'] ?? '', // Sửa: API trả về "service_name"
      description: json['description'],
    );
  }
}