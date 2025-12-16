class PriceItem {
  final String subname;
  final int cost;
  final String? unit;

  PriceItem({
    required this.subname,
    required this.cost,
    this.unit,
  });
}

class PriceCategory {
  final String name;
  final List<PriceItem> items;

  PriceCategory({
    required this.name,
    required this.items,
  });
}

class Price {
  final String type;
  final List<PriceCategory> category;

  Price({
    required this.type,
    required this.category,
  });
}