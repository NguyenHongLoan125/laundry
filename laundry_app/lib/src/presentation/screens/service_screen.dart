
import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import '../../router/route_names.dart';
import '../controllers/service_controller.dart';
import 'package:provider/provider.dart';
import '../widgets/price-item.dart';
import '../widgets/service_card.dart';
import '../widgets/service_type_dropdown.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int _currentIndex =1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceController>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: AppBar(
        title: Text('Dịch vụ', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,

      ),
      body: Consumer<ServiceController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loại dịch vụ chính
                Text(
                  'Loại dịch vụ chính',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),

                // Main Services List
                ...controller.mainServices.map((service) => ServiceCard(service: service)),

                SizedBox(height: 20),

                // Loại dịch vụ phụ
                Text(
                  'Loại dịch vụ phụ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),

                // Extra Services List
                ...controller.extraServices.map((service) => ServiceCard(service: service)),

                SizedBox(height: 20),

                // Bảng giá tham khảo
                Text(
                  'Bảng giá tham khảo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Giá tiền sẽ được phân loại theo từng loại đồ và dịch vụ khác nhau',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16),

                // Service Type Dropdown
                if (controller.prices.isNotEmpty)
                  ServiceTypeDropdown(
                    selectedValue: controller.selectedServiceType,
                    options: controller.prices.map((e) => e.type).toList(),
                    onChanged: (value) {
                      controller.setSelectedServiceType(value);
                    },
                  ),

                SizedBox(height: 16),

                // Price List
                if (controller.selectedPriceData != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundThird,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.selectedPriceData!.category
                          .map((group) => PriceGroupWidget(group: group))
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
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
