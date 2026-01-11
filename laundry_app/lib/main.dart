import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundry_app/src/app.dart';
import 'package:laundry_app/src/core/di/auth_dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo GetStorage
  await GetStorage.init();

  // 2. QUAN TRỌNG: Load file .env trước
  await dotenv.load(fileName: ".env"); // Hoặc .env.dev, .env.prod

  // 3. Khởi tạo AuthDI
  await AuthDI.init();
  // 4.  THÊM: Restore session nếu có
  print(' Attempting to restore session...');
  await AuthDI.restoreUserSession();
  runApp(const LaundryApp());
}