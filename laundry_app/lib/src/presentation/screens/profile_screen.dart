
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../presentation/controllers/home_controller.dart';
import '../../presentation/controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String myFont = 'Pacifico';

  @override
  void initState() {
    super.initState();
    // Load profile từ HomeController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<HomeController>();
      if (controller.profile == null) {
        controller.loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        final profile = controller.profile;
        final isLoading = controller.isLoading && profile == null;
        final hasError = controller.errorMessage.isNotEmpty && profile == null;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Color(0xFFF5F9FA),
            body: isLoading
                ? _buildLoadingState()
                : hasError
                ? _buildErrorState(controller.errorMessage, controller)
                : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(profile, controller),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 20),
                  _buildMenuSection(),
                  const SizedBox(height: 20),
                  _buildSettingsSection(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'Đang tải thông tin...',
                style: TextStyle(
                  fontFamily: myFont,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, HomeController controller) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  'Không thể tải thông tin',
                  style: TextStyle(
                    fontFamily: myFont,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: TextStyle(
                    fontFamily: myFont,
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => controller.loadProfile(),
                  icon: Icon(Icons.refresh),
                  label: Text('Thử lại', style: TextStyle(fontFamily: myFont)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(profile, HomeController controller) {
    final userName = profile?.name ?? 'User';
    final userEmail = profile?.email ?? '';
    final userPhone = profile?.phone ?? '';
    final userAvatar = (profile?.image?.isNotEmpty == true)
        ? profile!.image!
        : 'https://i.pinimg.com/736x/df/e9/f6/dfe9f6d3c7d53a1cecd2f622f7197442.jpg';

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
                children: [
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tài khoản',
                        style: TextStyle(
                          fontFamily: myFont,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.white),
                            onPressed: () => controller.loadProfile(),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings_outlined, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Avatar
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(userAvatar),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _handleEditAvatar,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    userName,
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // User Info Cards
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (userEmail.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.email_outlined, size: 18, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  userEmail,
                                  style: TextStyle(
                                    fontFamily: myFont,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (userEmail.isNotEmpty && userPhone.isNotEmpty)
                          const SizedBox(height: 12),
                        if (userPhone.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.phone_outlined, size: 18, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  userPhone,
                                  style: TextStyle(
                                    fontFamily: myFont,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Wave design at bottom
            Container(
              height: 40,
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: myFont,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: myFont,
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          return Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.local_offer_outlined,
                  label: 'Voucher',
                  count: '5',
                  color: Color(0xFFFF6B9D),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.myVoucher),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.star_outline,
                  label: 'Đánh giá',
                  count: '12',
                  color: Color(0xFFFFC107),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.rating),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Đơn hàng',
                  count: '${controller.orders.length}', // ĐÃ SỬA: '8' -> controller.orders.length
                  color: Color(0xFF4CAF50),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
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
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Thông tin liên hệ',
              subtitle: 'Cập nhật thông tin cá nhân',
              onTap: () => Navigator.pushNamed(context, AppRoutes.contactInfo),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.card_giftcard_outlined,
              title: 'Gói giặt của tôi',
              subtitle: 'Quản lý gói dịch vụ',
              onTap: () => Navigator.pushNamed(context, AppRoutes.myPackage),
            ),


            _buildDivider(),
            _buildMenuItem(
              icon: Icons.history_outlined,
              title: 'Lịch sử đơn hàng',
              subtitle: 'Xem đơn hàng đã đặt',
              onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              subtitle: 'Cài đặt thông báo',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: 'Ngôn ngữ',
              subtitle: 'Tiếng Việt',
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.dark_mode_outlined,
              title: 'Chế độ tối',
              subtitle: 'Bật/tắt chế độ tối',
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Chính sách bảo mật',
              subtitle: 'Điều khoản & điều kiện',
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Trợ giúp & Hỗ trợ',
              subtitle: 'Câu hỏi thường gặp',
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Về ứng dụng',
              subtitle: 'Phiên bản 1.0.0',
              onTap: () {
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[700],
          minimumSize: Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditAvatar() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thay đổi ảnh đại diện',
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('Chụp ảnh', style: TextStyle(fontFamily: myFont)),
              onTap: () {
                Navigator.pop(context);
                // Handle camera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Chọn từ thư viện', style: TextStyle(fontFamily: myFont)),
              onTap: () {
                Navigator.pop(context);
                // Handle gallery
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa ảnh', style: TextStyle(fontFamily: myFont)),
              onTap: () {
                Navigator.pop(context);
                // Handle delete
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ CHỈ SỬA HÀM NÀY - THÊM LOGIC ĐĂNG XUẤT THỰC SỰ
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Xác nhận đăng xuất',
          style: TextStyle(fontFamily: myFont),
        ),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?',
          style: TextStyle(fontFamily: myFont, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(fontFamily: myFont, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Đóng dialog xác nhận
              Navigator.pop(context);

              // ✅ Lấy AuthController
              final authController = Provider.of<AuthController>(
                context,
                listen: false,
              );

              try {
                print('🚪 Starting logout...');

                // ✅ Gọi logout
                await authController.logout();

                print('✅ Logout successful');

                // ✅ Navigate về login và xóa toàn bộ stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                      (route) => false,
                );

                // Hiển thị thông báo sau khi navigate
                Future.delayed(Duration(milliseconds: 300), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Đã đăng xuất thành công',
                        style: TextStyle(fontFamily: myFont),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              } catch (e) {
                print('❌ Logout error: $e');

                // Hiển thị lỗi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Đăng xuất thất bại: $e',
                      style: TextStyle(fontFamily: myFont),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Đăng xuất',
              style: TextStyle(fontFamily: myFont, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.local_laundry_service, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            Text(
              'Laundry App',
              style: TextStyle(fontFamily: myFont),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phiên bản: 1.0.0',
              style: TextStyle(fontFamily: myFont, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Ứng dụng giặt ủi tiện lợi, nhanh chóng và chuyên nghiệp.',
              style: TextStyle(fontFamily: myFont, fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2025 Laundry App. All rights reserved.',
              style: TextStyle(fontFamily: myFont, fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đóng',
              style: TextStyle(fontFamily: myFont, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}