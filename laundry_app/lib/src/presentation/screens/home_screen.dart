import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/features/auth/data/models/service_model.dart';
import 'package:laundry_app/src/presentation/controllers/home_controller.dart';
import 'package:laundry_app/src/presentation/layouts/seven_parts_layout.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/appointment_home.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/banner_slider.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/recent_orders.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/type_of_clothes.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/types_of_service.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/washing_package.dart';
import 'package:laundry_app/src/router/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? displayName;
  String? displayAvatar;
  int _currentIndex = 0;
  int currentBannerSlider = 0;
  bool isLoading = true;
  final List<String> images = [
    "lib/src/assets/images/test1.jpg",
    "lib/src/assets/images/test2.jpg",
    "lib/src/assets/images/test3.jpg"
  ];

  final TextEditingController findingController = TextEditingController();
  final controller = HomeController();
  final Appointment appointment = Appointment();
  late final List<OrderModel> order;
  late final List<WashingPackageModel> packages;

  @override
  void initState() {
    super.initState();
    order = _fakeOrders();
    packages = _fakeWashingPackages();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  List<OrderModel> _fakeOrders() {
    return [
      OrderModel(
        id: '#00000001',
        date: DateTime(2025, 11, 3),
        price: 200000,
        status: OrderStatus.cancelled,
      ),
      OrderModel(
        id: '#00000002',
        date: DateTime(2025, 11, 5),
        price: 350000,
        status: OrderStatus.processing,
      ),
      OrderModel(
        id: '#00000003',
        date: DateTime(2025, 11, 9),
        price: 120000,
        status: OrderStatus.completed,
      ),
    ];
  }

  List<WashingPackageModel> _fakeWashingPackages() {
    return [
      WashingPackageModel(
        name: 'Gói 40kg',
        description:
        'Sử dụng dòng máy giặt dân sinh cao cấp. Đồ sau khi giặt xong được sấy khô, diệt khuẩn và gấp gọn. Giặt riêng mỗi khách một máy. Gói giặt sấy chỉ áp dụng với quần áo thông thường, vỏ chăn, ga, gối.',
        note:
        'Gói giặt được tặng miễn phí dịch vụ ủi và miễn phí vận chuyển khi sử dụng gói giặt.',
        price: 699000,
      ),
      WashingPackageModel(
        name: 'Gói 20kg',
        description:
        'Giặt riêng mỗi khách một máy. Sấy khô, diệt khuẩn và gấp gọn sau khi giặt. Áp dụng cho quần áo thông thường.',
        note: 'Tặng miễn phí vận chuyển trong bán kính 3km.',
        price: 399000,
      ),
      WashingPackageModel(
        name: 'Gói 10kg',
        description:
        'Giặt - sấy khô - gấp gọn. Phù hợp nhu cầu giặt hằng tuần.',
        note: 'Không áp dụng cho chăn mền lớn.',
        price: 249000,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundAppBar,
        elevation: 0,
        centerTitle: false,
        title: Text(
          displayName ?? 'Hồng Loan',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Pacifico',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
              displayAvatar != null ? FileImage(File(displayAvatar!)) : null,
              backgroundColor: Colors.white,
              child: displayAvatar == null
                  ? Icon(Icons.person, color: AppColors.primary, size: 22)
                  : null,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: AppColors.text),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined, color: AppColors.text),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SevenPartsLayout(
        part1: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextField(
            controller: findingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Tìm kiếm',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        part2: BannerSlider(
          isLoading: isLoading,
          currentPage: currentBannerSlider,
          imageBanner: images,
          onPageChanged: (index) {
            setState(() {
              currentBannerSlider = index;
            });
          },
        ),
        part3: TypesOfService(
          isLoading: controller.isLoading,
          services: controller.services,
        ),
        part4: TypeOfClothes(
          isLoading: isLoading,
          clothes: controller.clothes,
        ),
        part5: AppointmentHome(
          appointment: appointment,
          seeAll: () {},
        ),
        part6: RecentOrders(
          order: order,
          seeAll: () {},
        ),
        part7: WashingPackage(
          washingPackage: packages,
          seeAll: () {},
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            String routeName;
            switch (index) {
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
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.white,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            _buildNavItem(Icons.home_outlined, "Trang chủ", 0),
            _buildNavItem(Icons.grid_view_outlined, "Dịch vụ", 1),
            _buildNavItem(Icons.receipt_long_outlined, "Đơn giặt", 2),
            _buildNavItem(Icons.calendar_today_outlined, "Lịch hẹn", 3),
            _buildNavItem(Icons.person_outline, "Tài khoản", 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: isSelected
            ? BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }
}