import 'package:flutter/material.dart';
import '../../features/laundry/domain/entities/clothing_item.dart';
import '../../features/laundry/domain/entities/clothing_sub_item.dart';

class ClothingItemsWidget extends StatelessWidget {
  final List<ClothingItem> items;
  final Function(String) onToggleItem;
  final Function(String, String, int) onUpdateQuantity;

  const ClothingItemsWidget({
    Key? key,
    required this.items,
    required this.onToggleItem,
    required this.onUpdateQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại đồ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00BFA5),
          ),
        ),
        const SizedBox(height: 12),

        Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ClothingItemCard(
                item: item,
                onToggle: () => onToggleItem(item.id),
                onUpdateQuantity: (subItemId, delta) =>
                    onUpdateQuantity(item.id, subItemId, delta),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ClothingItemCard extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onToggle;
  final Function(String, int) onUpdateQuantity;

  const _ClothingItemCard({
    required this.item,
    required this.onToggle,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isSelected ? const Color(0xFF00BFA5) : const Color(0xFFE0E0E0),
          width: item.isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7F4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        item.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Radio button
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: item.isSelected
                            ? const Color(0xFF00BFA5)
                            : const Color(0xFFBDBDBD),
                        width: 2,
                      ),
                      color: item.isSelected
                          ? const Color(0xFF00BFA5)
                          : Colors.transparent,
                    ),
                    child: item.isSelected
                        ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ],
              ),
            ),
          ),
          // Expandable sub-items
          if (item.isExpanded && item.subItems.isNotEmpty)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
              child: Column(
                children: item.subItems.map((subItem) {
                  return _SubItemRow(
                    subItem: subItem,
                    onUpdateQuantity: (delta) =>
                        onUpdateQuantity(subItem.id, delta),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _SubItemRow extends StatelessWidget {
  final ClothingSubItem subItem;
  final Function(int) onUpdateQuantity;

  const _SubItemRow({
    required this.subItem,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subItem.name,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF616161),
              ),
            ),
          ),
          // Decrease button
          IconButton(
            onPressed: subItem.quantity > 0
                ? () => onUpdateQuantity(-1)
                : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: const Color(0xFF00BFA5),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
          // Quantity
          Container(
            width: 32,
            alignment: Alignment.center,
            child: Text(
              subItem.quantity.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Increase button
          IconButton(
            onPressed: () => onUpdateQuantity(1),
            icon: const Icon(Icons.add_circle_outline),
            color: const Color(0xFF00BFA5),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}