import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:laundry_app/src/core/di/auth_dependency_injection.dart';
import 'package:laundry_app/src/core/di/rating_injection.dart';
import 'package:laundry_app/src/core/theme/app_theme.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import 'package:provider/provider.dart';

import 'core/di/laundry_injection.dart';
import 'core/di/order_injection.dart';
import 'core/di/service_injection.dart';
import 'core/di/tracking_injection.dart';
import 'core/di/voucher_injection.dart';

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => AuthDI.getAuthController(),),
        ChangeNotifierProvider(create: (_) => ServiceDI.getServiceController(),),
        ChangeNotifierProvider(create: (_) => VoucherInjection.createVoucherControllerWithMock(),),
        // ChangeNotifierProvider(create: (_) => VoucherInjection.createVoucherControllerWithAPI('https://your-api-url.com',),),
        ChangeNotifierProvider(create: (_) => RatingInjection.createRatingController(useMockData: true,apiBaseUrl: 'https://api.example.com',),),
        ChangeNotifierProvider(create: (_) => TrackingInjection.createTrackingControllerWithMock(),),
        // ChangeNotifierProvider(create: (_) => TrackingInjection.createTrackingControllerWithAPI('https://your-api-url.com',),),
        ChangeNotifierProvider(create: (_) => OrderInjection.createOrderControllerWithMock(),),
        // ChangeNotifierProvider(create: (_) => OrderInjection.createOrderControllerWithAPI('https://your-api-url.com',),),
        ChangeNotifierProvider(create: (_) =>  LaundryDI.getProvider(),),


    ],
      child: MaterialApp(
        title: 'Laundry',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        // initialRoute: AppRoutes.auth,
        initialRoute: AppRoutes.register,
        routes: AppRoutes.routes,
      ),
    );
  }
}
