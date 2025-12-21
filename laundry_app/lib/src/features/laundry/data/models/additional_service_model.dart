import '../../domain/entities/additional_service.dart';

class AdditionalServiceModel extends AdditionalService {
  AdditionalServiceModel({
    required String id,
    required String name,
    required String icon,
    bool isSelected = false,
  }) : super(
    id: id,
    name: name,
    icon: icon,
    isSelected: isSelected,
  );

  factory AdditionalServiceModel.fromJson(Map<String, dynamic> json) {
    return AdditionalServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'isSelected': isSelected,
  };
}