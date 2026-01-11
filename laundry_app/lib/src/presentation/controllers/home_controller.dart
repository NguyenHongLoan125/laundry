import 'package:flutter/material.dart';

import '../../features/home/domain/entities/clothing_item.dart';
import '../../features/home/domain/entities/order.dart';
import '../../features/home/domain/entities/package.dart';
import '../../features/home/domain/entities/serrvice.dart';
import '../../features/home/domain/entities/user_profile.dart';
import '../../features/home/domain/repositories/home_repository.dart'; // Thêm import này
// home_controller.dart
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository repository;

  HomeController({required this.repository}) {
    _initialize();
  }

  bool isLoading = false;
  String errorMessage = '';
  UserProfile? profile;
  List<Service> services = [];
  List<ClothingItem> clothingItems = [];
  List<Order> orders = [];
  List<LaundryPackage> packages = [];
  String? selectedServiceId;

  // Mock appointments
  List<Map<String, dynamic>> appointments = [
    {
      'time': '16:00',
      'date': '05 Th12',
      'orderNumber': '0000000001',
      'status': 'Đã xác nhận',
      'scheduledDate': '12:00 03/11/2025'
    }
  ];

  // Phương thức khởi tạo
  void _initialize() {
    Future.delayed(Duration.zero, () {
      loadAllData();
    });
  }

  Future<void> loadAllData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      print('🚀 Starting to load all data...');
      await Future.wait([
        loadProfile(),
        loadServices(),
        loadOrders(),
        loadPackages(),
      ]);
      print('✅ All data loaded successfully');
    } catch (e) {
      print('❌ Error loading data: $e');
      errorMessage = 'Không thể tải dữ liệu: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProfile() async {
    try {
      print('👤 Loading profile...');
      profile = await repository.getProfile();
      print('✅ Profile loaded: ${profile?.name}');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading profile: $e');
    }
  }

  Future<void> loadServices() async {
    try {
      print('🛠️ Loading services...');
      services = await repository.getServices();
      print('✅ Services loaded: ${services.length} services');

      if (services.isNotEmpty) {
        selectedServiceId = services[0].id;
        await loadClothingItems(services[0].id);
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error loading services: $e');
    }
  }

  Future<void> loadClothingItems(String serviceId) async {
    try {
      print('👕 Loading clothing items for service: $serviceId');
      selectedServiceId = serviceId;
      clothingItems = await repository.getClothingItems(serviceId);
      print('✅ Clothing items loaded: ${clothingItems.length} items');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading clothing items: $e');
    }
  }

  Future<void> loadOrders() async {
    try {
      print('📦 Loading orders...');
      final allOrders = await repository.getOrders();
      print('✅ Orders loaded from repository: ${allOrders.length} orders');
      orders = allOrders;
      print('✅ Orders assigned: ${orders.length} orders');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading orders: $e');
      orders = [];
      notifyListeners();
    }
  }

  Future<void> loadPackages() async {
    try {
      print('📦 Loading packages...');
      packages = await repository.getPackages();
      print('✅ Packages loaded: ${packages.length} packages');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading packages: $e');
    }
  }

  /// ✅ METHOD MỚI: Clear tất cả data
  void clearAllData() {
    print('🗑️ HomeController: Clearing all data...');
    profile = null;
    orders = [];
    services = [];
    packages = [];
    clothingItems = [];
    errorMessage = '';
    selectedServiceId = null;
    print('✅ HomeController: All data cleared');
    notifyListeners();
  }

  /// ✅ METHOD MỚI: Force reload tất cả data
  Future<void> reloadAllData() async {
    print('🔄 HomeController: Reloading all data...');

    clearAllData();

    await loadAllData();

    print('✅ HomeController: All data reloaded');
  }
  void onServiceSelected(String serviceId) {
    loadClothingItems(serviceId);
  }

  Future<void> refresh() async {
    await loadAllData();
  }
}