
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import '../controllers/service_controller.dart';
import 'package:provider/provider.dart';
import '../widgets/service_card.dart';
import '../widgets/service_type_dropdown.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final String myFont = 'Pacifico';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceController>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F9FA),
        body: Consumer<ServiceController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                _buildHeader(controller),
                Expanded(
                  child: controller.isLoading
                      ? _buildLoadingState()
                      : _buildContent(controller),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ServiceController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      Icon(
                        Icons.local_laundry_service,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Dịch vụ',
                        style: TextStyle(
                          fontFamily: myFont,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Khám phá các dịch vụ giặt ủi chuyên nghiệp',
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Wave design
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFFF5F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 20),
          Text(
            'Đang tải dịch vụ...',
            style: TextStyle(
              fontFamily: myFont,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ServiceController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Services Section
          if (controller.mainServices.isNotEmpty) ...[
            _buildSectionTitle(
              'Dịch vụ chính',
              Icons.star,
              controller.mainServices.length,
            ),
            SizedBox(height: 16),
            ...controller.mainServices.map((service) => ServiceCard(service: service)),
            SizedBox(height: 24),
          ],

          // Extra Services Section
          if (controller.extraServices.isNotEmpty) ...[
            _buildSectionTitle(
              'Dịch vụ bổ sung',
              Icons.add_circle_outline,
              controller.extraServices.length,
            ),
            SizedBox(height: 16),
            ...controller.extraServices.map((service) => ServiceCard(service: service)),
            SizedBox(height: 24),
          ],

          // Price Reference Section
          _buildSectionTitle(
            'Bảng giá tham khảo',
            Icons.receipt_long,
            null,
          ),
          SizedBox(height: 8),
          Text(
            'Giá tiền sẽ được phân loại theo từng loại đồ và dịch vụ khác nhau',
            style: TextStyle(
              fontFamily: myFont,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16),

          // Service Selector Dropdown
          if (controller.mainServices.isNotEmpty)
            Column(
              children: [
                ServiceTypeDropdown(
                  selectedValue: controller.selectedServiceName ?? '',
                  options: controller.getServiceNames(),
                  onChanged: (value) async {
                    if (value != null && value.isNotEmpty) {
                      final service = controller.getServiceByName(value);
                      if (service != null && service.id.isNotEmpty) {
                        await controller.selectService(service.id, service.name);
                      }
                    }
                  },
                ),
                SizedBox(height: 16),
              ],
            ),

          // Price Table
          if (controller.selectedPriceData != null &&
              controller.selectedPriceData!.category.isNotEmpty)
            _buildPriceTable(controller)
          else if (!controller.isLoading)
            _buildEmptyPriceWidget(),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, int? count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: myFont,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          if (count != null) ...[
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: myFont,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceTable(ServiceController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.price_check, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  controller.selectedServiceName ?? 'Bảng giá',
                  style: TextStyle(
                    fontFamily: myFont,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.selectedPriceData!.category.map((category) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category name
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontFamily: myFont,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),

                    // Items
                    ...category.items.map((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8, left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.subname,
                                style: TextStyle(
                                  fontFamily: myFont,
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${_formatPrice(item.cost)}đ/${item.unit ?? 'kg'}",
                                style: TextStyle(
                                  fontFamily: myFont,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPriceWidget() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 12),
            Text(
              'Bảng giá đang được cập nhật',
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}