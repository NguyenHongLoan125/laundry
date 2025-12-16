import 'package:laundry_app/src/features/service/domain/entities/price.dart';

class PriceItemModel extends PriceItem {
  PriceItemModel({
    required super.subname,
    required super.cost,
    super.unit,
  });

  factory PriceItemModel.fromJson(Map<String, dynamic> json) {
    return PriceItemModel(
      subname: json['subname'],
      cost: json['cost'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subname': subname,
      'cost': cost,
      'unit': unit,
    };
  }

  PriceItem toEntity() {
    return PriceItem(
      subname: subname,
      cost: cost,
      unit: unit,
    );
  }
}

class PriceCategoryModel extends PriceCategory {
  PriceCategoryModel({
    required super.name,
    required super.items,
  });

  factory PriceCategoryModel.fromJson(Map<String, dynamic> json) {
    return PriceCategoryModel(
      name: json['name'],
      items: (json['items'] as List)
          .map((e) => PriceItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((e) => (e as PriceItemModel).toJson()).toList(),
    };
  }

  PriceCategory toEntity() {
    return PriceCategory(
      name: name,
      items: items,
    );
  }
}

class PriceModel extends Price {
  PriceModel({
    required super.type,
    required super.category,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      type: json['service'],
      category: (json['types'] as List)
          .map((e) => PriceCategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service': type,
      'types': category.map((e) => (e as PriceCategoryModel).toJson()).toList(),
    };
  }

  Price toEntity() {
    return Price(
      type: type,
      category: category,
    );
  }
}