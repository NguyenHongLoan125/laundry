import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../features/laundry/domain/entities/additional_service.dart';
import '../../features/laundry/domain/entities/clothing_item.dart';
import '../../features/laundry/domain/entities/clothing_sub_item.dart';
import '../../features/laundry/domain/entities/detergent_item.dart';
import '../../features/laundry/domain/entities/fabric_softener_item.dart';
import '../../features/laundry/domain/entities/laundry_package.dart';
import '../../features/laundry/domain/entities/laundry_service.dart';
import '../../features/laundry/domain/entities/shipping_method.dart';
import '../../features/laundry/domain/repositories/laundry_repository.dart';

enum PaymentMethod {
  cashOnDelivery,
  bankTransfer,
}

class LaundryOrderController extends ChangeNotifier {
  final LaundryRepository repository;
  final AuthController authController;

  // Trạng thái
  bool isLoading = true;
  bool isSubmitting = false;
  bool usePackage = true;
  bool isLoadingClothingItems = false;

  // Controllers
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Dữ liệu
  List<ClothingItem> clothingItems = [];
  List<LaundryPackage> packages = [];
  List<AdditionalService> additionalServices = [];
  List<ShippingMethod> shippingMethods = [];
  List<Detergent> detergents = [];
  List<FabricSoftener> fabricSofteners = [];
  List<LaundryService> laundryServices = [];

  // Lựa chọn hiện tại
  LaundryPackage? selectedPackage;
  LaundryService? selectedService;
  ShippingMethod? selectedShippingMethod;
  PaymentMethod selectedPaymentMethod = PaymentMethod.cashOnDelivery;
  Map<String, dynamic>? appliedDiscount;

  // Ngày tháng
  DateTime? pickupDate;
  DateTime? deliveryDate;

  // Constructor
  LaundryOrderController({
    required this.repository,
    required this.authController,
  });

  // Getter để lấy userId
  String? get currentUserId => authController.currentUser?.id;

  //  Kiểm tra user đã đăng nhập chưa
  bool get isUserLoggedIn => currentUserId != null;

  // Load tất cả dữ liệu ban đầu
  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Sử dụng userId thực từ authController
      final userId = currentUserId;

      if (userId == null) {
        throw Exception('User chưa đăng nhập. Vui lòng đăng nhập trước.');
      }

      final results = await Future.wait([
        // Bỏ repository.getClothingItems() ở đây, sẽ load sau khi chọn service
        repository.getAvailablePackages(userId),
        repository.getAdditionalServices(),
        repository.getShippingMethods(),
        repository.getDetergents(),
        repository.getFabricSofteners(),
        repository.getLaundryServices(), // Load laundry services trước
      ]);

      // clothingItems = results[0] as List<ClothingItem>;
      packages = results[0] as List<LaundryPackage>;
      additionalServices = results[1] as List<AdditionalService>;
      shippingMethods = results[2] as List<ShippingMethod>;
      detergents = results[3] as List<Detergent>;
      fabricSofteners = results[4] as List<FabricSoftener>;
      laundryServices = results[5] as List<LaundryService>;

      // Chỉ chọn gói đầu tiên NẾU CÓ packages
      if (packages.isNotEmpty) {
        selectedPackage = packages.first;
      } else {
        selectedPackage = null;
        usePackage = false;
      }

      // Mặc định chọn dịch vụ đầu tiên và load clothing items tương ứng
      if (laundryServices.isNotEmpty) {
        selectedService = laundryServices.first;
        // Load clothing items theo service đầu tiên
        await loadClothingItemsForService(selectedService!.id);
      }

      // Mặc định chọn phương thức vận chuyển đầu tiên
      if (shippingMethods.isNotEmpty) {
        selectedShippingMethod = shippingMethods.first;
      }

      // Mặc định chọn nước giặt đầu tiên
      if (detergents.isNotEmpty) {
        detergents[0] = Detergent(
          id: detergents[0].id,
          name: detergents[0].name,
          isSelected: true,
        );
      }

      // Mặc định chọn nước xả vải đầu tiên
      if (fabricSofteners.isNotEmpty) {
        fabricSofteners[0] = FabricSoftener(
          id: fabricSofteners[0].id,
          name: fabricSofteners[0].name,
          isSelected: true,
        );
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Load clothing items theo serviceId
  Future<void> loadClothingItemsForService(String serviceId) async {
    if (serviceId.isEmpty) return;

    isLoadingClothingItems = true;
    notifyListeners();

    try {
      // Gọi repository với serviceId
      clothingItems = await repository.getClothingItems(serviceId);

      // Reset trạng thái selected/expanded cho clothing items mới
      clothingItems = clothingItems.map((item) => ClothingItem(
        id: item.id,
        name: item.name,
        icon: item.icon,
        isSelected: false, // Reset selected
        isExpanded: false, // Reset expanded
        subItems: item.subItems.map((subItem) => ClothingSubItem(
          id: subItem.id,
          name: subItem.name,
          quantity: 0, // Reset quantity
          price: subItem.price,
          serviceId: serviceId, // Đảm bảo serviceId được gán
        )).toList(),
      )).toList();

      isLoadingClothingItems = false;
      notifyListeners();
    } catch (e) {
      isLoadingClothingItems = false;
      notifyListeners();
      rethrow;
    }
  }

  // Khi người dùng chọn dịch vụ
  Future<void> selectService(LaundryService service) async {
    if (service.id == selectedService?.id) return; // Không cần load lại nếu đã chọn

    selectedService = service;

    // Load clothing items mới cho service được chọn
    await loadClothingItemsForService(service.id);

    notifyListeners();
  }

  // Các method quản lý clothing items (cần cập nhật để xử lý serviceId)
  void toggleClothingItem(String itemId) {
    final index = clothingItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      clothingItems[index] = ClothingItem(
        id: clothingItems[index].id,
        name: clothingItems[index].name,
        icon: clothingItems[index].icon,
        isSelected: !clothingItems[index].isSelected,
        isExpanded: clothingItems[index].isExpanded,
        subItems: clothingItems[index].subItems,
      );
      notifyListeners();
    }
  }

  void toggleClothingItemExpansion(String itemId) {
    final index = clothingItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      clothingItems[index] = ClothingItem(
        id: clothingItems[index].id,
        name: clothingItems[index].name,
        icon: clothingItems[index].icon,
        isSelected: clothingItems[index].isSelected,
        isExpanded: !clothingItems[index].isExpanded,
        subItems: clothingItems[index].subItems,
      );
      notifyListeners();
    }
  }

  void updateSubItemQuantity(String itemId, String subItemId, int delta) {
    final itemIndex = clothingItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final subItemIndex = clothingItems[itemIndex]
          .subItems
          .indexWhere((subItem) => subItem.id == subItemId);

      if (subItemIndex != -1) {
        final currentQuantity = clothingItems[itemIndex]
            .subItems[subItemIndex]
            .quantity;
        final newQuantity = currentQuantity + delta;

        if (newQuantity >= 0) {
          // Cập nhật subItem
          final updatedSubItems = List<ClothingSubItem>.from(clothingItems[itemIndex].subItems);
          updatedSubItems[subItemIndex] = ClothingSubItem(
            id: updatedSubItems[subItemIndex].id,
            name: updatedSubItems[subItemIndex].name,
            quantity: newQuantity,
            price: updatedSubItems[subItemIndex].price,
            serviceId: updatedSubItems[subItemIndex].serviceId, // Giữ serviceId
          );

          // Cập nhật clothingItem
          clothingItems[itemIndex] = ClothingItem(
            id: clothingItems[itemIndex].id,
            name: clothingItems[itemIndex].name,
            icon: clothingItems[itemIndex].icon,
            isSelected: clothingItems[itemIndex].isSelected,
            isExpanded: clothingItems[itemIndex].isExpanded,
            subItems: updatedSubItems,
          );
          notifyListeners();
        }
      }
    }
  }

  // Quản lý gói giặt
  void togglePackageUsage() {
    usePackage = !usePackage;
    notifyListeners();
  }

  void selectPackage(LaundryPackage package) {
    selectedPackage = package;
    notifyListeners();
  }

  // Quản lý dịch vụ đi kèm
  void toggleAdditionalService(String serviceId) {
    final index = additionalServices.indexWhere((service) => service.id == serviceId);
    if (index != -1) {
      additionalServices[index] = AdditionalService(
        id: additionalServices[index].id,
        name: additionalServices[index].name,
        icon: additionalServices[index].icon,
        isSelected: !additionalServices[index].isSelected,
      );
      notifyListeners();
    }
  }

  // Quản lý nước giặt (chỉ chọn một)
  void selectDetergent(String detergentId) {
    detergents = detergents.map((detergent) {
      return Detergent(
        id: detergent.id,
        name: detergent.name,
        isSelected: detergent.id == detergentId ? !detergent.isSelected : false,
      );
    }).toList();
    notifyListeners();
  }

  // Quản lý nước xả vải (chỉ chọn một)
  void selectFabricSoftener(String softenerId) {
    fabricSofteners = fabricSofteners.map((softener) {
      return FabricSoftener(
        id: softener.id,
        name: softener.name,
        isSelected: softener.id == softenerId ? !softener.isSelected : false,
      );
    }).toList();
    notifyListeners();
  }

  // Quản lý phương thức vận chuyển
  void selectShippingMethod(String methodId) {
    final method = shippingMethods.firstWhere((method) => method.id == methodId);
    selectedShippingMethod = method;
    notifyListeners();
  }

  void setPickupDate(DateTime date) {
    pickupDate = date;
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    deliveryDate = date;
    notifyListeners();
  }

  // Quản lý phương thức thanh toán
  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  // Tính tổng giá
  double calculateTotalPrice() {
    double total = 0;

    // Tính giá clothing items
    for (final item in clothingItems) {
      if (item.isSelected) {
        for (final subItem in item.subItems) {
          if (subItem.quantity > 0) {
            total += subItem.quantity * subItem.price;
          }
        }
      }
    }

    // Áp dụng gói giặt (trừ giá gói)
    if (usePackage && selectedPackage != null) {
      total -= selectedPackage!.price;
      if (total < 0) total = 0;
    }

    // Thêm phí vận chuyển
    if (selectedShippingMethod != null) {
      total += selectedShippingMethod!.discountedPrice;
    }

    return total;
  }

  // Kiểm tra xem có thể submit order không
  bool canSubmitOrder() {
    final address = addressController.text.trim();
    final hasSelectedItems = clothingItems.any((item) =>
    item.isSelected && item.subItems.any((subItem) => subItem.quantity > 0)
    );

    // Kiểm tra có service được chọn không
    final hasSelectedService = selectedService != null;

    return address.isNotEmpty &&
        hasSelectedItems &&
        hasSelectedService &&
        isUserLoggedIn;
  }

  // Gửi đơn hàng
  Future<void> submitOrder(BuildContext context) async {
    if (!canSubmitOrder()) {
      if (!isUserLoggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng đăng nhập để đặt đơn'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng chọn dịch vụ giặt'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập địa chỉ và chọn ít nhất một sản phẩm'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      // Chuẩn bị dữ liệu với userId
      final orderData = _prepareOrderData();
      final orderId = await repository.submitOrder(orderData);

      isSubmitting = false;
      notifyListeners();

      // TODO: Chuyển hướng đến màn hình trang chi tiết
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đặt đơn thành công! Mã đơn: $orderId'),
          backgroundColor: AppColors.textPrimary,
        ),
      );

    } catch (e) {
      isSubmitting = false;
      notifyListeners();

      // Hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đặt đơn thất bại: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, dynamic> _prepareOrderData() {
    // Lấy userId
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('Không thể lấy thông tin người dùng');
    }

    // Kiểm tra đã chọn service
    if (selectedService == null) {
      throw Exception('Vui lòng chọn dịch vụ giặt');
    }

    // Lấy detergent được chọn
    final selectedDetergent = detergents.firstWhere(
            (d) => d.isSelected,
        orElse: () => detergents.isNotEmpty ? detergents.first : Detergent(
          id: 'default',
          name: 'Không chọn',
          isSelected: false,
        )
    );

    // Lấy fabric softener được chọn
    final selectedFabricSoftener = fabricSofteners.firstWhere(
            (f) => f.isSelected,
        orElse: () => fabricSofteners.isNotEmpty ? fabricSofteners.first : FabricSoftener(
          id: 'default',
          name: 'Không chọn',
          isSelected: false,
        )
    );

    return {
      'userId': userId,
      'address': addressController.text,
      'notes': notesController.text,
      'serviceId': selectedService!.id, // Thêm serviceId vào order data
      'package': usePackage && selectedPackage != null
          ? {
        'id': selectedPackage!.id,
        'name': selectedPackage!.name,
        'description': selectedPackage!.description,
        'price': selectedPackage!.price,
        'discountPercent': selectedPackage!.discountPercent,
        'expiryDate': selectedPackage!.expiryDate.toIso8601String(),
        'isActive': selectedPackage!.isActive,
      }
          : null,
      'service': {
        'id': selectedService!.id,
        'name': selectedService!.name,
        'type': selectedService!.type.toString().split('.').last,
        'basePrice': selectedService!.basePrice,
        'description': selectedService!.description,
      },
      'clothingItems': clothingItems
          .where((item) => item.isSelected && item.subItems.any((subItem) => subItem.quantity > 0))
          .map((item) => {
        'id': item.id,
        'name': item.name,
        'icon': item.icon,
        'isSelected': item.isSelected,
        'isExpanded': item.isExpanded,
        'subItems': item.subItems
            .where((subItem) => subItem.quantity > 0)
            .map((subItem) => {
          'id': subItem.id,
          'name': subItem.name,
          'quantity': subItem.quantity,
          'price': subItem.price,
          'serviceId': subItem.serviceId, // Bao gồm serviceId
        })
            .toList(),
      })
          .toList(),
      'additionalServices': additionalServices
          .where((service) => service.isSelected)
          .map((service) => {
        'id': service.id,
        'name': service.name,
        'icon': service.icon,
        'isSelected': service.isSelected,
      })
          .toList(),
      'detergent': {
        'id': selectedDetergent.id,
        'name': selectedDetergent.name,
        'isSelected': selectedDetergent.isSelected,
      },
      'fabricSoftener': {
        'id': selectedFabricSoftener.id,
        'name': selectedFabricSoftener.name,
        'isSelected': selectedFabricSoftener.isSelected,
      },
      'shippingMethod': selectedShippingMethod != null
          ? {
        'id': selectedShippingMethod!.id,
        'name': selectedShippingMethod!.name,
        'description': selectedShippingMethod!.description,
        'originalPrice': selectedShippingMethod!.originalPrice,
        'discountedPrice': selectedShippingMethod!.discountedPrice,
        'voucherInfo': selectedShippingMethod!.voucherInfo,
      }
          : null,
      'paymentMethod': selectedPaymentMethod.toString().split('.').last,
      'pickupDate': pickupDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'totalPrice': calculateTotalPrice(),
      'appliedDiscount': appliedDiscount,
    };
  }

  @override
  void dispose() {
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }
}