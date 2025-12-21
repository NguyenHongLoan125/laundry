import '../../domain/entities/detergent_item.dart';

class DetergentModel extends Detergent {
  DetergentModel({
    required String id,
    required String name,
    bool isSelected = false,
  }) : super(
    id: id,
    name: name,
    isSelected: isSelected,
  );

  factory DetergentModel.fromJson(Map<String, dynamic> json) {
    return DetergentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isSelected': isSelected,
  };
}