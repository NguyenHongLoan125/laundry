import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/service/domain/entities/price.dart';
import 'package:laundry_app/src/features/service/domain/entities/service.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_prices_usecase.dart';
import 'package:laundry_app/src/features/service/domain/usecases/get_services_usecase.dart';

class ServiceController extends ChangeNotifier {
  final GetServicesUseCase getServicesUseCase;
  final GetPricesUseCase getPricesUseCase;

  ServiceController({
    required this.getServicesUseCase,
    required this.getPricesUseCase,
  });

  List<Service> mainServices = [];
  List<Service> extraServices = [];
  List<Price> prices = [];

  String? selectedServiceType;
  Price? selectedPriceData;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Load services và prices đồng thời
      final results = await Future.wait([
        getServicesUseCase.call(),
        getPricesUseCase.call(),
      ]);

      final allServices = results[0] as List<Service>;
      final allPrices = results[1] as List<Price>;

      mainServices = allServices.where((e) => e.type == "main").toList();
      extraServices = allServices.where((e) => e.type == "extra").toList();
      prices = allPrices;

      // Set default selected service type
      if (prices.isNotEmpty) {
        selectedServiceType = prices.first.type;
        selectedPriceData = prices.first;
      }
    } catch (e) {
      errorMessage = "Lỗi tải dữ liệu: $e";
      print("Error loading data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedServiceType(String? type) {
    if (type != null) {
      selectedServiceType = type;
      selectedPriceData = prices.firstWhere(
            (price) => price.type == type,
        orElse: () => prices.first,
      );
      notifyListeners();
    }
  }
}