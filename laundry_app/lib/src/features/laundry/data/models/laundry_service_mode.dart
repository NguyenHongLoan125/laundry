import '../../domain/entities/laundry_service.dart';

class LaundryServiceModel extends LaundryService {
  const LaundryServiceModel({
    required String id,
    required String name,
    required LaundryServiceType type,
    required double basePrice,
    required String description,
  }) : super(
    id: id,
    name: name,
    type: type,
    basePrice: basePrice,
    description: description,
  );

  factory LaundryServiceModel.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    LaundryServiceType type;

    switch (typeString) {
      case 'washing':
        type = LaundryServiceType.washing;
        break;
      case 'dryCleaning':
        type = LaundryServiceType.dryCleaning;
        break;
      case 'ironing':
        type = LaundryServiceType.ironing;
        break;
      case 'express':
        type = LaundryServiceType.express;
        break;
      default:
        type = LaundryServiceType.washing;
    }

    return LaundryServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: type,
      basePrice: (json['basePrice'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toString().split('.').last,
    'basePrice': basePrice,
    'description': description,
  };
}