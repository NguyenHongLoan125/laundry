enum LaundryServiceType {
  washing,
  dryCleaning,
  ironing,
  express,
}

class LaundryService {
  final String id;
  final String name;
  final LaundryServiceType type;
  final double basePrice;
  final String description;

  const LaundryService({
    required this.id,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.description,
  });
}