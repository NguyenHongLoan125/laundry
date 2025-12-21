class Detergent {
  final String id;
  final String name;
  bool isSelected;

  Detergent({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
}