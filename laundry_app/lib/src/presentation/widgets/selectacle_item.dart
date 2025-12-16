import 'package:flutter/material.dart';

class SelectableItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00BFA5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF00BFA5) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF424242),
            ),
          ),
        ),
      ),
    );
  }
}