// import 'package:laundry_app/src/features/service/domain/entities/service.dart';
//
// class ServiceModel extends Service {
//   ServiceModel({
//     String id = '',
//     required String name,
//     required String description,
//     required String icon,
//     String? duration,
//     required String type,
//   }) : super(
//     id: id,
//     name: name,
//     description: description,
//     icon: icon,
//     duration: duration,
//     type: type,
//   );
//
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       icon: json['icon'] ?? '',
//       duration: json['duration'],
//       type: (json['is_main'] ?? false) ? 'main' : 'extra',
//     );
//   }
//
//   factory ServiceModel.fromApiJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['_id'] ?? '',
//       name: json['service_name'] ?? '',
//       description: json['description'] ?? 'Dịch vụ giặt ủi chất lượng cao',  // Lấy trực tiếp từ API
//       icon: _getIcon(json['service_name'] ?? ''),
//       duration: json['service_duration'],
//       type: _determineServiceType(json),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'icon': icon,
//       'duration': duration,
//       'is_main': type == 'main',
//     };
//   }
//
//   Service toEntity() {
//     return Service(
//       id: id,
//       name: name,
//       description: description,
//       icon: icon,
//       duration: duration,
//       type: type,
//     );
//   }
//
//   static String _getIcon(String serviceName) {
//     final iconMap = {
//       'Giặt sấy': 'lib/src/assets/images/washing_machine.png',
//       'Giặt hấp': 'lib/src/assets/images/steam.png',
//       'Ủi quần áo': 'lib/src/assets/images/iron.png',
//       'Tẩy quần áo': 'lib/src/assets/images/bleach.png',
//       'Vá quần áo': 'lib/src/assets/images/sewing.png',
//       'Giặt thường': 'lib/src/assets/images/laundry.png',
//       'Giặt là': 'lib/src/assets/images/laundry_iron.png',
//       'Giặt khô': 'lib/src/assets/images/dry_cleaning.png',
//       'Giặt nệm': 'lib/src/assets/images/mattress.png',
//       'Giặt giày': 'lib/src/assets/images/shoes.png',
//     };
//
//     for (var key in iconMap.keys) {
//       if (serviceName.toLowerCase().contains(key.toLowerCase().replaceAll(' ', ''))) {
//         return iconMap[key]!;
//       }
//     }
//
//     return 'lib/src/assets/images/laundry.png';
//   }
//
//   static String _determineServiceType(Map<String, dynamic> json) {
//     final tags = json['service_tags'] ?? [];
//
//     if (tags is List) {
//       if (tags.contains('hot')) {
//         return 'main';
//       }
//     }
//
//     return 'extra';
//   }
// }
import 'package:laundry_app/src/features/service/domain/entities/service.dart';

class ServiceModel extends Service {
  ServiceModel({
    String id = '',
    required String name,
    required String description,
    required String icon,
    String? duration,
    required String type,
  }) : super(
    id: id,
    name: name,
    description: description,
    icon: icon,
    duration: duration,
    type: type,
  );

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      duration: json['duration'],
      type: (json['is_main'] ?? false) ? 'main' : 'extra',
    );
  }

  factory ServiceModel.fromApiJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      name: json['service_name'] ?? '',
      description: json['description'] ?? 'Dịch vụ giặt ủi chất lượng cao',  // Lấy trực tiếp từ API
      icon: _getIcon(json['service_name'] ?? ''),
      duration: json['service_duration'],
      type: _determineServiceType(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'duration': duration,
      'is_main': type == 'main',
    };
  }

  Service toEntity() {
    return Service(
      id: id,
      name: name,
      description: description,
      icon: icon,
      duration: duration,
      type: type,
    );
  }

  static String _getIcon(String serviceName) {
    final iconMap = {
      'Giặt sấy': 'lib/src/assets/images/washing_machine.png',
      'Giặt hấp': 'lib/src/assets/images/steam.png',
      'Ủi quần áo': 'lib/src/assets/images/iron.png',
      'Tẩy quần áo': 'lib/src/assets/images/bleach.png',
      'Vá quần áo': 'lib/src/assets/images/sewing.png',
      'Giặt thường': 'lib/src/assets/images/laundry.png',
      'Giặt là': 'lib/src/assets/images/laundry_iron.png',
      'Giặt khô': 'lib/src/assets/images/dry_cleaning.png',
      'Giặt nệm': 'lib/src/assets/images/mattress.png',
      'Giặt giày': 'lib/src/assets/images/shoes.png',
    };

    for (var key in iconMap.keys) {
      if (serviceName.toLowerCase().contains(key.toLowerCase().replaceAll(' ', ''))) {
        return iconMap[key]!;
      }
    }

    return 'lib/src/assets/images/laundry.png';
  }

  static String _determineServiceType(Map<String, dynamic> json) {
    final tags = json['service_tags'] ?? [];

    if (tags is List) {
      if (tags.contains('hot')) {
        return 'main';
      }
    }

    return 'extra';
  }
}