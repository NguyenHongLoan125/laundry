import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/pages/contact_info_page.dart';
import 'package:laundry_app/src/presentation/pages/my_laundry_packages_page.dart';
import 'package:laundry_app/src/presentation/pages/order_detail_page.dart';
import 'package:laundry_app/src/presentation/pages/voucher_list_page.dart';
import 'package:laundry_app/src/presentation/screens/otp_verification_screen.dart';
import 'package:laundry_app/src/presentation/screens/create_order_screen.dart';
import 'package:laundry_app/src/presentation/screens/register_screen.dart';
import 'package:laundry_app/src/presentation/screens/service_screen.dart';
import '../presentation/layouts/layout_menu.dart';
import '../presentation/pages/laundry_order_page.dart';
import '../presentation/pages/order_tracking_page.dart';
import '../presentation/pages/service_rating_page.dart';
import '../presentation/screens/order_hisory_screen.dart';
import 'route_names.dart';

import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/profile_screen.dart';

class AppRoutes {
  static const mainApp = RouteNames.mainApp;
  static const auth = RouteNames.auth;
  static const home = RouteNames.home;
  static const profile = RouteNames.profile;
  static const register= RouteNames.register;
  static const login= RouteNames.login;
  static const service = RouteNames.service;
  static const contactInfo = RouteNames.contactInfo;
  static const myPackage = RouteNames.myPackage;
  static const myVoucher = RouteNames.myVoucher;
  static const orderDetail = RouteNames.orderDetail;
  static const orderTracking = RouteNames.orderTracking;
  static const rating = RouteNames.rating;
  static const laundryOrder = RouteNames.laundryOrder;

  static const createOrder = RouteNames.createOrder;

  static final routes = <String, WidgetBuilder>{
    mainApp: (context) => const AppScreenWithBottomNavBar(),

    login: (context) => const LoginScreen(),
    register: (context)=> const RegisterScreen(),
    auth: (context)=> const OTPVerificationScreen(),

    home: (context) => const HomeScreen(),
    service: (context) => const ServiceScreen(),

    profile: (context) => const ProfileScreen(),
    contactInfo: (context) => const ContactInfoScreen(),
    myPackage: (context) =>  const PackagesScreen(),
    myVoucher: (context) =>  const VouchersScreen(),
    orderDetail: (context) =>  const OrderHistoryScreen(),
    orderTracking: (context) =>  const OrderTrackingScreen(orderId: "#00000001",),
    rating: (context) =>  const ServiceRatingScreen(),
    laundryOrder: (context) =>   LaundryOrderScreen(),

    // account: (context) => const AccountScreen(),
    createOrder: (context) => CreateOrderScreen(),
  };
}
