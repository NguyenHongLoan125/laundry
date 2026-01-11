import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/service/domain/entities/price.dart';
import 'package:laundry_app/src/features/service/domain/entities/service.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_extra_services_usecase.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_prices_usecase.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_services_usecase.dart';

class ServiceController extends ChangeNotifier {
  final GetServicesUseCase getServicesUseCase;
  final GetExtraServicesUseCase getExtraServicesUseCase;
  final GetPricesUseCase getPricesUseCase;

  ServiceController({
    required this.getServicesUseCase,
    required this.getExtraServicesUseCase,
    required this.getPricesUseCase,
  });

  List<Service> mainServices = [];
  List<Service> extraServices = [];
  List<Price> prices = [];

  String? selectedServiceId;      // ID dịch vụ được chọn
  String? selectedServiceName;    // Tên dịch vụ được chọn (cho dropdown)
  Price? selectedPriceData;       // Dữ liệu giá của dịch vụ được chọn

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Load services (chính và phụ) đồng thời
      final servicesResults = await Future.wait([
        getServicesUseCase.call(),
        getExtraServicesUseCase.call(),
      ]);

      mainServices = servicesResults[0] as List<Service>;
      extraServices = servicesResults[1] as List<Service>;

      // Mặc định chọn dịch vụ đầu tiên trong danh sách chính
      if (mainServices.isNotEmpty) {
        final firstService = mainServices.first;
        selectedServiceId = firstService.id;
        selectedServiceName = firstService.name;

        // Load prices cho dịch vụ đầu tiên
        await _loadPricesForService(firstService.id);
      }

    } catch (e) {
      errorMessage = "Lỗi tải dữ liệu: $e";
      print("Error loading data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method để load prices cho một service cụ thể
  Future<void> _loadPricesForService(String serviceId) async {
    try {
      prices = await getPricesUseCase.call(serviceId);

      // Lấy dữ liệu price cho service này
      if (prices.isNotEmpty) {
        selectedPriceData = prices.firstWhere(
              (price) => price.type == serviceId,
          orElse: () => prices.first,
        );
      }
    } catch (e) {
      print("Error loading prices for service $serviceId: $e");
      // Không set error để không làm crash UI
    }
  }

  // Method để thay đổi dịch vụ được chọn
  Future<void> selectService(String serviceId, String serviceName) async {
    selectedServiceId = serviceId;
    selectedServiceName = serviceName;

    // Load prices cho dịch vụ mới
    await _loadPricesForService(serviceId);

    notifyListeners();
  }

  // Getter để lấy danh sách tên dịch vụ cho dropdown
  List<String> getServiceNames() {
    return mainServices.map((service) => service.name).toList();
  }

  // Getter để lấy service theo tên
  Service? getServiceByName(String name) {
    return mainServices.firstWhere(
          (service) => service.name == name,
      orElse: () => mainServices.isNotEmpty ? mainServices.first : Service(
        id: '',
        name: '',
        description: '',
        icon: '',
        duration: '',
        type: 'main',
      ),
    );
  }
}