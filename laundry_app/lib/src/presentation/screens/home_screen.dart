import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/pages/laundry_order_page.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../features/home/domain/entities/clothing_item.dart';
import '../../features/home/domain/entities/order.dart';
import '../../features/home/domain/entities/package.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final String myFont = 'Pacifico';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FA),
      body: SafeArea(
        child: Consumer<HomeController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildSearchBar(),
                  _buildServices(context),
                  _buildClothingTypes(context),
                  _buildNearbyOrders(context),
                  _buildPackages(context),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFE0F7FA),
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.profile?.name ?? '',
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.search,
          hintStyle: TextStyle(fontFamily: myFont, color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }


  Widget _buildServices(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppStrings.services,
            style: TextStyle(
              fontFamily: myFont,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildServiceCard(
                  icon: Icons.local_laundry_service_outlined,
                  label: AppStrings.washService,
                  isSelected: controller.services.isNotEmpty &&
                      controller.selectedServiceId == controller.services[0].id,
                  onTap: () {
                    if (controller.services.isNotEmpty) {
                      controller.onServiceSelected(controller.services[0].id);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceCard(
                  icon: Icons.iron_outlined,
                  label: AppStrings.ironService,
                  isSelected: controller.services.length > 1 &&
                      controller.selectedServiceId == controller.services[1].id,
                  onTap: () {
                    if (controller.services.length > 1) {
                      controller.onServiceSelected(controller.services[1].id);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: myFont,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClothingTypes(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppStrings.clothingTypes,
            style: TextStyle(
              fontFamily: myFont,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(
          height: 93,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.clothingItems.length,
            itemBuilder: (context, index) {
              final item = controller.clothingItems[index];
              return _buildClothingTypeItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClothingTypeItem(ClothingItem item) {
    IconData icon;
    switch (item.type.toLowerCase()) {
      case 'quần áo':
        icon = Icons.checkroom;
        break;
      case 'rèm cửa':
        icon = Icons.curtains;
        break;
      case 'giày':
        icon = Icons.shopping_bag;
        break;
      case 'gấu bông':
        icon = Icons.cruelty_free;
        break;
      case 'đặt biệt':
        icon = Icons.category;
        break;
      default:
        icon = Icons.local_laundry_service;
    }

    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            item.type, // Hiển thị type thay vì name
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: myFont, fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
  Widget _buildNearbyOrders(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.recentOrders,
                style: TextStyle(
                  fontFamily: myFont,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '(${controller.orders.length})',
                style: TextStyle(
                  fontFamily: myFont,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        _buildOrdersList(controller),
      ],
    );
  }


  Widget _buildOrdersList(HomeController controller) {
    print('🔍 Building orders UI - Count: ${controller.orders.length}');

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.orders.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE0E0E0)),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Chưa có đơn giặt nào',
                style: TextStyle(
                  fontFamily: myFont,
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.orders.length + 1, // +1 cho "Tạo đơn"
        itemBuilder: (context, index) {
          // Item đầu tiên: TẠO ĐƠN
          if (index == 0) {
            return _buildCreateOrderButton(context);
          }

          final order = controller.orders[index - 1];
          return _buildOrderCard(order);
        },
      ),
    );

  }
  Widget _buildCreateOrderButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LaundryOrderScreen()),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              'Tạo đơn',
              style: TextStyle(
                fontFamily: myFont,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'đã xong':
        return AppColors.primary;
      case 'đang xử lý':
        return AppColors.textPrimary;
      case 'đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOrderCard(Order order) {
    // Tính tổng số lượng items
    int totalItems = 0;
    for (var item in order.items) {
      totalItems += item.quantity;
    }

    // Lấy màu theo trạng thái (giả sử order có trường status, nếu không thì dùng màu mặc định)
    String orderStatus = order.status ?? 'đang xử lý';
    Color statusColor = _getStatusColor(orderStatus);

    // Lấy tên items để hiển thị
    String itemsText = order.items.isNotEmpty
        ? order.items.map((e) => '${e.type}${e.subType.isNotEmpty ? " (${e.subType})" : ""}').join(', ')
        : 'Không có sản phẩm';

    if (itemsText.length > 30) {
      itemsText = '${itemsText.substring(0, 30)}...';
    }

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha:0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(alpha:0.1),
                ),
                child: Icon(
                  Icons.local_laundry_service,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.service,
                      style: TextStyle(
                        fontFamily: myFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        orderStatus,
                        style: TextStyle(
                          fontFamily: myFont,
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFF5F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$totalItems sản phẩm • ${order.package.isNotEmpty ? order.package : 'Không có gói'}',
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.payment == 'cashOnDelivery' ? 'COD' : 'Chuyển khoản',
                  style: TextStyle(
                    fontFamily: myFont,
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${order.total.toStringAsFixed(0)}đ',
                style: TextStyle(
                  fontFamily: myFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildPackages(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            AppStrings.laundryPackages,
            style: TextStyle(
              fontFamily: myFont,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.packages.length,
          itemBuilder: (context, index) {
            final package = controller.packages[index];
            return _buildPackageCard(package);
          },
        ),
      ],
    );
  }

  Widget _buildPackageCard(LaundryPackage package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.card_giftcard,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  package.name,
                  style: TextStyle(
                    fontFamily: myFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              package.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.primary.withOpacity(0.6)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Miễn phí ủi và vận chuyển',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giá gói',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${package.price.toStringAsFixed(0)}đ',
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.buyNow,
                  style: TextStyle(
                    fontFamily: myFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}