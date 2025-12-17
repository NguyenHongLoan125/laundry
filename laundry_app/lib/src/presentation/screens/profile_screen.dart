import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/profile_action_button.dart';
import 'package:laundry_app/src/presentation/widgets/profile_header.dart';
import 'package:laundry_app/src/presentation/widgets/profile_menu_item.dart';
import 'package:laundry_app/src/router/app_routes.dart';

import '../../core/constants/app_colors.dart';
import '../../router/route_names.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex =4;
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

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            String routeName;
            switch (index){
              case 0:
                routeName = RouteNames.home;
                break;
              case 1:
                routeName = RouteNames.service;
                break;
              case 2:
                routeName = RouteNames.laundryOrder;
                break;
              case 3:
                routeName = RouteNames.profile;
                break;
              case 4:
                routeName = RouteNames.profile;
                break;
              default:
                routeName = RouteNames.home;
            }
            if (ModalRoute.of(context)?.settings.name != routeName) {
              Navigator.pushReplacementNamed(context, routeName);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.text,
          unselectedItemColor: AppColors.text,
          backgroundColor: AppColors.backgroundAppBar,


          items: [
            _buildNavItem(Icons.home_outlined, "Trang chủ", 0),
            _buildNavItem(Icons.grid_view, "Dịch vụ", 1),
            _buildNavItem(Icons.sticky_note_2_outlined, "Đơn giặt", 2),
            _buildNavItem(Icons.calendar_month_sharp, "Lịch hẹn", 3),
            _buildNavItem(Icons.person_pin, "Tài khoản", 4),

          ]
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem (IconData icon, String label, int index){
    bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      label: label,
      icon: isSelected
          ? Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.white),
      )
          : Icon(icon, color: AppColors.text),
    );
  }
}
