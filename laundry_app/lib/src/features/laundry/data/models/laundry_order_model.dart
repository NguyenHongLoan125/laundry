import '../../domain/entities/laundry_order.dart';

class LaundryOrderModel {
  final String? id;
  final String? address;
  final Map<String, dynamic>? package;
  final String? serviceType;
  final List<Map<String, dynamic>> clothingItems;
  final List<String> detergents;
  final List<String> fabricSofteners;

  LaundryOrderModel({
    this.id,
    this.address,
    this.package,
    this.serviceType,
    required this.clothingItems,
    required this.detergents,
    required this.fabricSofteners,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'package': package,
      'service_type': serviceType,
      'clothing_items': clothingItems,
      'detergents': detergents,
      'fabric_softeners': fabricSofteners,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  factory LaundryOrderModel.fromEntity(LaundryOrder order) {
    final clothingItemsData = <Map<String, dynamic>>[];

    for (var item in order.clothingItems) {
      if (item.isSelected) {
        if (item.isExpanded && item.subItems.isNotEmpty) {
          for (var subItem in item.subItems) {
            if (subItem.quantity > 0) {
              clothingItemsData.add({
                'type': item.name,
                'sub_type': subItem.name,
                'quantity': subItem.quantity,
              });
            }
          }
        } else {
          clothingItemsData.add({
            'type': item.name,
            'quantity': 1,
          });
        }
      }
    }

    return LaundryOrderModel(
      id: order.id,
      address: order.address,
      package: order.package != null
          ? {
        'id': order.package!.id,
        'name': order.package!.name,
        'discount': order.package!.discount,
      }
          : null,
      serviceType: order.service?.type.toString(),
      clothingItems: clothingItemsData,
      detergents: order.detergents
          .where((d) => d.isSelected)
          .map((d) => d.name)
          .toList(),
      fabricSofteners: order.fabricSofteners
          .where((f) => f.isSelected)
          .map((f) => f.name)
          .toList(),
    );
  }
}