import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laundry_app/src/app.dart';
import 'package:laundry_app/src/core/di/auth_dependency_injection.dart';
import 'package:laundry_app/src/core/di/laundry_injection.dart';

Future<void> main() async {
  // Đảm bảo Flutter đã khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  // // Khởi tạo tất cả dependencies
  // setupLaundryDependencies();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Auth dependencies
  AuthDI.init();
  // LaundryDI.init(useMockData: false); // Khởi tạo ở đây

  // Chạy app
  runApp(const LaundryApp());
}