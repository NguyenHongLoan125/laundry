import 'clothing_item.dart';
import 'detergent_item.dart';
import 'fabric_softener_item.dart';
import 'laundry_package.dart';
import 'laundry_service.dart';

class LaundryOrder {
  final String? id;
  final String? address;
  final LaundryPackage? package;
  final LaundryService? service;
  final List<ClothingItem> clothingItems;
  final List<DetergentItem> detergents;
  final List<FabricSoftenerItem> fabricSofteners;
  final DateTime? createdAt;

  LaundryOrder({
    this.id,
    this.address,
    this.package,
    this.service,
    this.clothingItems = const [],
    this.detergents = const [],
    this.fabricSofteners = const [],
    this.createdAt,
  });

  LaundryOrder copyWith({
    String? id,
    String? address,
    LaundryPackage? package,
    LaundryService? service,
    List<ClothingItem>? clothingItems,
    List<DetergentItem>? detergents,
    List<FabricSoftenerItem>? fabricSofteners,
    DateTime? createdAt,
  }) {
    return LaundryOrder(
      id: id ?? this.id,
      address: address ?? this.address,
      package: package ?? this.package,
      service: service ?? this.service,
      clothingItems: clothingItems ?? this.clothingItems,
      detergents: detergents ?? this.detergents,
      fabricSofteners: fabricSofteners ?? this.fabricSofteners,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}