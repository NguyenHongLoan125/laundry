enum ServiceType { washDry, washIron }

class LaundryService {
  final ServiceType type;
  final String name;
  final String icon;

  LaundryService({
    required this.type,
    required this.name,
    required this.icon,
  });
}