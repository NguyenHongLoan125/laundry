import 'package:flutter/material.dart';
import '../../features/laundry/domain/entities/shipping_method.dart';

class ShippingMethodWidget extends StatelessWidget {
  final List<ShippingMethod> shippingMethods;
  final ShippingMethod? selectedMethod;
  final Function(String) onSelectMethod;
  final Function(DateTime) onPickupDateChanged;
  final Function(DateTime) onDeliveryDateChanged;

  const ShippingMethodWidget({
    Key? key,
    required this.shippingMethods,
    required this.selectedMethod,
    required this.onSelectMethod,
    required this.onPickupDateChanged,
    required this.onDeliveryDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...shippingMethods.map((method) => _buildMethodCard(context, method)),
      ],
    );
  }

  Widget _buildMethodCard(BuildContext context, ShippingMethod method) {
    final isSelected = selectedMethod?.id == method.id;

    return InkWell(
      onTap: () => onSelectMethod(method.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFF00BFA5) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Color(0xFFE0F7F4) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isSelected)
                  Icon(Icons.check_circle, color: Color(0xFF00BFA5), size: 20),
                if (isSelected) const SizedBox(width: 8),
                Text(
                  method.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5),
                  ),
                ),
                Spacer(),
                if (method.originalPrice > 0)
                  Text(
                    '${method.originalPrice.toStringAsFixed(0)}đ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  'Miễn phí',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5),
                  ),
                ),
              ],
            ),
            if (method.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                method.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
            if (method.voucherInfo != null) ...[
              const SizedBox(height: 8),
              Text(
                method.voucherInfo!,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],


          ],
        ),
      ),
    );
  }

  Widget _buildDatePickers(BuildContext context) {
    return Column(
      children: [
        _buildDateField(
          context,
          label: 'Ngày đưa đồ:',
          onTap: () => _selectDate(context, true),
        ),
        const SizedBox(height: 8),
        _buildDateField(
          context,
          label: 'Ngày hẹn giao:',
          onTap: () => _selectDate(context, false),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, {required String label, required VoidCallback onTap}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ngày/tháng/năm',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isPickupDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF00BFA5),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isPickupDate) {
        onPickupDateChanged(picked);
      } else {
        onDeliveryDateChanged(picked);
      }
    }
  }
}