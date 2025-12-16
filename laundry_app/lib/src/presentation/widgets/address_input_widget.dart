import 'package:flutter/material.dart';

class AddressInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const AddressInputWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Địa chỉ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00BFA5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Thêm địa chỉ',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
