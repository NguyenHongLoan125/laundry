class Service {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String type; // main / extra

  Service({
    this.id = '',
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
  });
}