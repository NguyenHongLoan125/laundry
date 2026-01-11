import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/di/auth_dependency_injection.dart';
import 'package:laundry_app/src/core/di/home_dependency_injection.dart';
import 'package:laundry_app/src/core/di/rating_injection.dart';
import 'package:laundry_app/src/core/di/order_injection.dart';
import 'package:laundry_app/src/core/di/service_injection.dart';
import 'package:laundry_app/src/core/di/tracking_injection.dart';
import 'package:laundry_app/src/core/di/voucher_injection.dart';
import 'package:laundry_app/src/core/theme/app_theme.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import 'package:laundry_app/src/presentation/controllers/home_controller.dart';
import 'package:laundry_app/src/presentation/layouts/layout_menu.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import 'package:provider/provider.dart';

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthDI.getAuthController(),
        ),
        //  Đảm bảo HomeController luôn được tạo mới
        ChangeNotifierProvider(
          create: (_) => HomeDI.getHomeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceDI.getServiceController(),
        ),
        ChangeNotifierProvider(
          create: (_) => VoucherInjection.createVoucherControllerWithMock(),
        ),
        ChangeNotifierProvider(
          create: (_) => RatingInjection.createRatingController(
            useMockData: true,
            apiBaseUrl: 'https://api.example.com',
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TrackingInjection.createTrackingControllerWithMock(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderInjection.createOrderControllerWithMock(),
        ),
      ],
      child: Consumer2<AuthController, HomeController>(
        builder: (context, authController, homeController, child) {
          return MaterialApp(
            title: 'Laundry',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: _buildHomeBasedOnAuth(context, authController, homeController),
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }

  ///  Xây dựng home screen dựa trên trạng thái đăng nhập
  Widget _buildHomeBasedOnAuth(
      BuildContext context,
      AuthController authController,
      HomeController homeController,
      ) {
    print(' Building home screen...');
    print('   - isLoading: ${authController.isLoading}');
    print('   - currentUser: ${authController.currentUser?.email}');
    print('   - isLoggedIn: ${authController.isLoggedIn}');
    print('   - homeProfile: ${homeController.profile?.name}');

    //  Nếu đã login → Vào MainApp
    if (authController.isLoggedIn) {
      print(' User is logged in → AppScreenWithBottomNavBar');

      //  Kiểm tra xem HomeController có data chưa
      // Nếu chưa có hoặc email khác với auth user → Reload
      if (homeController.profile == null ||
          homeController.profile?.email != authController.currentUser?.email) {
        print(' HomeController profile mismatch, reloading...');

        // Reload data trong background
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeController.reloadAllData();
        });
      }

      return AppScreenWithBottomNavBar();
    }

    //  Nếu chưa login → Vào LoginScreen
    print(' User not logged in → LoginScreen');
    return Builder(
      builder: (context) {
        final routeBuilder = AppRoutes.routes[AppRoutes.login];
        if (routeBuilder != null) {
          return routeBuilder(context);
        }
        return Scaffold(
          body: Center(
            child: Text('Login screen not found'),
          ),
        );
      },
    );
  }
}