import 'package:laundry_app/src/features/service/domain/entities/service.dart';

class ServiceModel extends Service {
  ServiceModel({
    String id = '',
    required String name,
    required String description,
    required String icon,
    required String type,
  }) : super(
    id: id,
    name: name,
    description: description,
    icon: icon,
    type: type,
  );

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      type: (json['is_main'] ?? false) ? 'main' : 'extra',
    );
  }

  factory ServiceModel.fromApiJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '', // Lấy _id từ API
      name: json['service_name'] ?? '',
      description: _generateDescription(json),
      icon: _getIcon(json['service_name'] ?? ''),
      type: _determineServiceType(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'is_main': type == 'main',
    };
  }

  Service toEntity() {
    return Service(
      id: id,
      name: name,
      description: description,
      icon: icon,
      type: type,
    );
  }

  static String _generateDescription(Map<String, dynamic> json) {
    final List<String> details = [];

    if (json['service_weight'] != null) {
      details.add('Trọng lượng: ${json['service_weight']}kg');
    }

    if (json['service_duration'] != null && json['service_duration'].isNotEmpty) {
      details.add('Thời gian: ${json['service_duration']}');
    }

    if (json['service_capacity'] != null) {
      details.add('Số lượng: ${json['service_capacity']}');
    }

    if (json['discount'] != null && json['discount'] > 0) {
      details.add('Giảm giá: ${json['discount']}%');
    }

    return details.isNotEmpty ? details.join(' • ') : 'Dịch vụ chất lượng cao';
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