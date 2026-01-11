import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../features/home/domain/entities/package.dart';
import '../controllers/home_controller.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  final String myFont = 'Pacifico';

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
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<HomeController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (controller.packages.isEmpty) {
                    return _buildEmptyState();
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoBanner(),
                        const SizedBox(height: 20),
                        ...controller.packages.map((package) => _buildPackageCard(context, package)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gói giặt ủi',
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Chọn gói phù hợp với nhu cầu của bạn',
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 14,
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_offer,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ưu đãi đặc biệt',
                  style: TextStyle(
                    fontFamily: myFont,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tất cả gói đều miễn phí ủi và vận chuyển',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa có gói nào',
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hiện tại chưa có gói giặt ủi nào',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, LaundryPackage package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header with icon and name
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primary.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name,
                        style: TextStyle(
                          fontFamily: myFont,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Gói tiết kiệm',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          package.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Benefits
                _buildBenefitItem(Icons.local_laundry_service, 'Giặt sạch chuyên nghiệp'),
                const SizedBox(height: 10),
                _buildBenefitItem(Icons.iron, 'Miễn phí dịch vụ ủi'),
                const SizedBox(height: 10),
                _buildBenefitItem(Icons.local_shipping, 'Miễn phí vận chuyển'),
                const SizedBox(height: 10),
                _buildBenefitItem(Icons.access_time, 'Giao nhận nhanh chóng'),

                const SizedBox(height: 20),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),

                const SizedBox(height: 20),

                // Price and Buy button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giá gói',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${package.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontFamily: myFont,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4, left: 2),
                                child: Text(
                                  'đ',
                                  style: TextStyle(
                                    fontFamily: myFont,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showBuyPackageDialog(context, package);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Mua ngay',
                            style: TextStyle(
                              fontFamily: myFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          size: 18,
          color: Colors.green,
        ),
      ],
    );
  }

  void _showBuyPackageDialog(BuildContext context, LaundryPackage package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Xác nhận mua gói',
                style: TextStyle(
                  fontFamily: myFont,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có chắc chắn muốn mua gói "${package.name}"?',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng thanh toán:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${package.price.toStringAsFixed(0)}đ',
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Hủy',
              style: TextStyle(
                fontFamily: myFont,
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processPurchase(context, package);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Xác nhận',
              style: TextStyle(
                fontFamily: myFont,
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processPurchase(BuildContext context, LaundryPackage package) {
    // TODO: Implement purchase logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Đã mua gói "${package.name}" thành công!',
                style: TextStyle(fontFamily: myFont),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}