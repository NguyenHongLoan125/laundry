import 'package:flutter/material.dart';
import '../../features/laundry/domain/entities/clothing_sub_item.dart';
import '../../features/laundry/domain/entities/laundry_order.dart';
import '../../features/laundry/domain/entities/laundry_package.dart';
import '../../features/laundry/domain/entities/laundry_service.dart';
import '../../features/laundry/domain/entities/clothing_item.dart';
import '../../features/laundry/domain/entities/detergent_item.dart';
import '../../features/laundry/domain/entities/fabric_softener_item.dart';
import '../../features/laundry/domain/usecases/get_packages_usecase.dart';
import '../../features/laundry/domain/usecases/get_clothing_types_usecase.dart';
import '../../features/laundry/domain/usecases/get_detergents_usecase.dart';
import '../../features/laundry/domain/usecases/get_fabric_softeners_usecase.dart';
import '../../features/laundry/domain/usecases/submit_order_usecase.dart';
import '../../router/app_routes.dart';

class LaundryOrderProvider extends ChangeNotifier {
  final GetPackagesUseCase getPackagesUseCase;
  final GetClothingTypesUseCase getClothingTypesUseCase;
  final GetDetergentsUseCase getDetergentsUseCase;
  final GetFabricSoftenersUseCase getFabricSoftenersUseCase;
  final SubmitOrderUseCase submitOrderUseCase;

  LaundryOrderProvider({
    required this.getPackagesUseCase,
    required this.getClothingTypesUseCase,
    required this.getDetergentsUseCase,
    required this.getFabricSoftenersUseCase,
    required this.submitOrderUseCase,
  }) {
    // loadInitialData();
  }

  // State
  bool isLoading = false;
  bool isSubmitting = false;

  final addressController = TextEditingController();

  List<LaundryPackage> packages = [];
  LaundryPackage? selectedPackage;
  bool usePackage = true;

  ServiceType selectedService = ServiceType.washDry;

  List<ClothingItem> clothingItems = [];
  List<DetergentItem> detergents = [];
  List<FabricSoftenerItem> fabricSofteners = [];

  // ---------------------------------------------------------
  // Load Data
  // ---------------------------------------------------------
  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([
      loadPackages(),
      loadClothingTypes(),
      loadDetergents(),
      loadFabricSofteners(),
    ]);

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadPackages() async {
    final result = await getPackagesUseCase();
    result.fold(
          (_) {},
          (data) {
        packages = data;
        if (data.isNotEmpty) {
          selectedPackage = data.first.copyWith(isSelected: true);
        }
      },
    );
  }

  Future<void> loadClothingTypes() async {
    final result = await getClothingTypesUseCase();
    result.fold(
          (_) {},
          (data) => clothingItems = data,
    );
  }

  Future<void> loadDetergents() async {
    final result = await getDetergentsUseCase();
    result.fold(
          (_) {},
          (data) {
        detergents = data;
        if (data.isNotEmpty) {
          detergents[0] = data.first.copyWith(isSelected: true);
        }
      },
    );
  }

  Future<void> loadFabricSofteners() async {
    final result = await getFabricSoftenersUseCase();
    result.fold(
          (_) {},
          (data) {
        fabricSofteners = data;
        if (data.isNotEmpty) {
          fabricSofteners[0] = data.first.copyWith(isSelected: true);
        }
      },
    );
  }

  // ---------------------------------------------------------
  // Actions
  // ---------------------------------------------------------
  void togglePackageUsage() {
    usePackage = !usePackage;
    notifyListeners();
  }

  void selectService(ServiceType type) {
    selectedService = type;
    notifyListeners();
  }

  void toggleClothingItem(String itemId) {
    final index = clothingItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    final item = clothingItems[index];

    clothingItems[index] = item.copyWith(
      isSelected: !item.isSelected,
      isExpanded: !item.isSelected ? true : false,
    );

    notifyListeners();
  }

  void updateSubItemQuantity(String itemId, String subItemId, int delta) {
    final i = clothingItems.indexWhere((item) => item.id == itemId);
    if (i == -1) return;

    final item = clothingItems[i];
    final j = item.subItems.indexWhere((sub) => sub.id == subItemId);
    if (j == -1) return;

    final current = item.subItems[j].quantity;
    final updated = (current + delta).clamp(0, 99);

    final updatedSubItems = [...item.subItems];
    updatedSubItems[j] = updatedSubItems[j].copyWith(quantity: updated);

    clothingItems[i] = item.copyWith(subItems: updatedSubItems);

    notifyListeners();
  }

  void toggleDetergent(String id) {
    detergents = detergents
        .map((d) => d.copyWith(isSelected: d.id == id))
        .toList();
    notifyListeners();
  }

  void toggleFabricSoftener(String id) {
    fabricSofteners = fabricSofteners
        .map((f) => f.copyWith(isSelected: f.id == id))
        .toList();
    notifyListeners();
  }

  bool _validateForm() {
    if (addressController.text.isEmpty) return false;
    if (!clothingItems.any((e) => e.isSelected)) return false;
    return true;
  }

  Future<void> submitOrder(BuildContext context) async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Vui lòng nhập đầy đủ")));
      return;
    }

    isSubmitting = true;
    notifyListeners();

    final order = LaundryOrder(
      address: addressController.text,
      package: usePackage ? selectedPackage : null,
      service: LaundryService(
        type: selectedService,
        name: selectedService == ServiceType.washDry ? "Giặt sấy" : "Giặt hấp",
        icon: "",
      ),
      clothingItems: clothingItems,
      detergents: detergents,
      fabricSofteners: fabricSofteners,
      createdAt: DateTime.now(),
    );

    final result = await submitOrderUseCase(order);

    isSubmitting = false;
    notifyListeners();

    result.fold(
          (_) => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Đặt đơn thất bại"))),
          (success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đặt đơn thành công")));
          // Navigator.pop(context);
          Navigator.pushNamed(context, AppRoutes.rating);

        }
      },
    );
  }
}
