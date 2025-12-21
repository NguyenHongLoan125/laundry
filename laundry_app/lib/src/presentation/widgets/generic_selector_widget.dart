import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class SimpleSelectorWidget extends StatelessWidget {
  final List<SelectableItemData> items;
  final Function(String) onToggle;

  const SimpleSelectorWidget({
    Key? key,
    required this.items,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? 8 : 0,
              ),
              child: _SelectableItemCard(
                text: item.name,
                isSelected: item.isSelected,
                onTap: () => onToggle(item.id),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SelectableItemData {
  final String id;
  final String name;
  final bool isSelected;

  SelectableItemData({
    required this.id,
    required this.name,
    required this.isSelected,
  });
}

// Internal selectable item card
class _SelectableItemCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableItemCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 30, right:16, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.petrona(
                fontSize: 15,
                color: isSelected ? const Color(0xFF00BFA5) : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:  AppColors.textPrimary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor:  AppColors.textPrimary,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}