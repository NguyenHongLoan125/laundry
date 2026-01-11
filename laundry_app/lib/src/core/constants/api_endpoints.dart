import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../config/app_config.dart';

class ApiEndpoints {
  static  String baseUrl = AppConfig.baseUrl;
  static  String services = '$baseUrl/service/listServices';
  static String clothingItems = '$baseUrl/clothingItem/listClothingItems';
  static String orders = '$baseUrl/order/list';
  static String packages = '$baseUrl/laundry-packages';
  static String profile = '$baseUrl/authentication/profile';
}