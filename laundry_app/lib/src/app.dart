import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/theme/app_theme.dart';
import 'package:laundry_app/src/router/app_routes.dart';



class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // initialRoute: AppRoutes.auth,
      initialRoute: AppRoutes.auth,
      routes: AppRoutes.routes,
    );
  }
}
