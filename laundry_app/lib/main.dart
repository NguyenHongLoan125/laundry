import 'package:flutter/material.dart';
import 'package:laundry_app/src/app.dart';
import 'package:laundry_app/src/core/di/laundry_injection.dart';
import 'package:laundry_app/src/presentation/pages/laundry_order_page.dart';

void main() {
  // LaundryDependencyInjection.init();
  // runApp(
  //   MaterialApp(
  //     home: LaundryOrderScreen(),
  //   ),
  // );
  runApp(const LaundryApp());
}
