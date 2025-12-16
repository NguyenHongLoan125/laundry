import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/profile_action_button.dart';
import 'package:laundry_app/src/presentation/widgets/profile_header.dart';
import 'package:laundry_app/src/presentation/widgets/profile_menu_item.dart';
import 'package:laundry_app/src/router/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundPrimary,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileHeader(name: "Hồng Loan"),

                const SizedBox(height: 25),

                Row(
                  children: [
                    ProfileActionButton(
                      icon: Icons.local_offer_outlined,
                      label: "Kho voucher",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.myVoucher);
                      },
                    ),
                    const SizedBox(width: 15),
                    ProfileActionButton(
                      icon: Icons.star_border,
                      label: "Đánh giá",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.rating);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                ProfileMenuItem(
                  title: "Thông tin liên hệ",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.contactInfo);
                  },
                ),
                ProfileMenuItem(
                  title: "Gói giặt của tôi",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.myPackage);

                  },
                ),
                ProfileMenuItem(
                  title: "Lịch hẹn",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.orderTracking);
                  },
                ),
                ProfileMenuItem(
                  title: "Lịch sử đơn hàng",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.orderDetail);
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
