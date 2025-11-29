import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/screens/auth_screen.dart';
import 'package:laundry_app/src/presentation/screens/register_screen.dart';
import 'package:laundry_app/src/presentation/screens/service_screen.dart';
import 'route_names.dart';

import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/account_screen.dart';

class AppRoutes {
  static const auth = RouteNames.auth;
  static const home = RouteNames.home;
  static const account = RouteNames.account;
  static const register= RouteNames.register;
  static const login= RouteNames.login;

  static final routes = <String, WidgetBuilder>{
    login: (context) => const LoginScreen(),
    register: (context)=> const RegisterScreen(),
    auth: (context)=> const AuthScreen(),

    home: (context) => const HomeScreen(),
    // account: (context) => const AccountScreen(),
  };
}
