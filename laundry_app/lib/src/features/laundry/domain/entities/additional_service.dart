class AdditionalService {
  final String id;
  final String name;
  final String icon;
  bool isSelected;

  AdditionalService({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });
}