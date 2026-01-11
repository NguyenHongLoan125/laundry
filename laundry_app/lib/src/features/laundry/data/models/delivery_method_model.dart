// Model cho phương thức vận chuyển
class DeliveryMethod {
  final String id;
  final String name;
  final String description;
  final double price; // Phí vận chuyển (0 nếu tự đến tiệm)
  final String icon;
  bool isSelected;

  DeliveryMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    this.isSelected = false,
  });

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryMethod(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      icon: json['icon'] ?? 'delivery_dining',
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'icon': icon,
      'isSelected': isSelected,
    };
  }

  DeliveryMethod copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? icon,
    bool? isSelected,
  }) {
    return DeliveryMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}