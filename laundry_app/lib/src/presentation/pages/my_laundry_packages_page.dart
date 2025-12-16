import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/laundry_package_item.dart';
import 'package:laundry_app/src/presentation/widgets/remaining_card.dart';

class MyLaundryPackagesPage extends StatelessWidget {
  const MyLaundryPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            /// Số kg còn lại
            RemainingCard(
              weight: "35kg",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            const Text(
              "Các loại gói giặt",
              style: TextStyle(
                color: Color(0xFF38A169),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            /// Danh sách gói giặt (dùng dữ liệu động)
            Expanded(
              child: ListView(
                children: const [
                  LaundryPackageItem(
                    name: "Gói 35kg",
                    price: "599.000đ",
                  ),
                  LaundryPackageItem(
                    name: "Gói 35kg",
                    price: "599.000đ",
                  ),
                  LaundryPackageItem(
                    name: "Gói 35kg",
                    price: "599.000đ",
                  ),
                  LaundryPackageItem(
                    name: "Gói 35kg",
                    price: "599.000đ",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
