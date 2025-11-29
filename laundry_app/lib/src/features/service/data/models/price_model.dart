class PriceItemModel {
  final String subname;
  final int cost;
  final String? unit;

  PriceItemModel({
    required this.subname,
    required this.cost,
    this.unit,
  });

  factory PriceItemModel.fromJson(Map<String, dynamic> json) {
    return PriceItemModel(
      subname: json['subname'],
      cost: json['cost'],
      unit: json['unit'],
    );
  }
}

class PriceCategoryModel {
  final String name;
  final List<PriceItemModel> items;

  PriceCategoryModel({
    required this.name,
    required this.items,
  });

  factory PriceCategoryModel.fromJson(Map<String, dynamic> json) {
    return PriceCategoryModel(
      name: json['name'],
      items: (json['items'] as List)
          .map((e) => PriceItemModel.fromJson(e))
          .toList(),
    );
  }
}

class PriceModel {
  final String type;
  final List<PriceCategoryModel> category;

  PriceModel({
    required this.type,
    required this.category,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      type: json['service'],
      category: (json['types'] as List)
          .map((e) => PriceCategoryModel.fromJson(e))
          .toList(),
    );
  }
}
