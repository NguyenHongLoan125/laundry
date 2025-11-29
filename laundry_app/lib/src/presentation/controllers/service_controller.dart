import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/service/data/datasources/service_api.dart';
import 'package:laundry_app/src/features/service/data/models/price_model.dart';
import 'package:laundry_app/src/features/service/data/models/service_model.dart';


class ServiceController extends ChangeNotifier {
  final api = ServiceApi();

  List<ServiceModel> mainServices = [];
  List<ServiceModel> extraServices = [];
  List<PriceModel> prices = [];

  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final allServices = await api.fetchServices();
      final allPrices = await api.fetchPrices();

      mainServices = allServices.where((e) => e.type == "main").toList();
      extraServices = allServices.where((e) => e.type == "extra").toList();
      prices = allPrices;
    } catch (e) {
      // Xử lý lỗi API nếu cần
      print("Error loading data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
