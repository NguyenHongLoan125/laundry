import '../../domain/entities/fabric_softener_item.dart';

class FabricSoftenerModel extends FabricSoftener {
  FabricSoftenerModel({
    required String id,
    required String name,
    bool isSelected = false,
  }) : super(
    id: id,
    name: name,
    isSelected: isSelected,
  );

  factory FabricSoftenerModel.fromJson(Map<String, dynamic> json) {
    return FabricSoftenerModel(
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