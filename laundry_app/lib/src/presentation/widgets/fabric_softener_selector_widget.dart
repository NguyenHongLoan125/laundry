import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/selectacle_item.dart';
import '../../features/laundry/domain/entities/fabric_softener_item.dart';

class FabricSoftenerSelectorWidget extends StatelessWidget {
  final List<FabricSoftenerItem> fabricSofteners;
  final Function(String) onToggle;

  const FabricSoftenerSelectorWidget({
    Key? key,
    required this.fabricSofteners,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nước xả vải',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00BFA5),
          ),
        ),
        const SizedBox(height: 12),

        Column(
          children: fabricSofteners.asMap().entries.map((entry) {
            final index = entry.key;
            final softener = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < fabricSofteners.length - 1 ? 8 : 0,
              ),
              child: SelectableItem(
                text: softener.name,
                isSelected: softener.isSelected,
                onTap: () => onToggle(softener.id),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
