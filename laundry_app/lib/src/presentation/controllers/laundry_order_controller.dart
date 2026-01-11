import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../features/laundry/data/models/delivery_method_model.dart';
import '../../features/laundry/domain/entities/additional_service.dart';
import '../../features/laundry/domain/entities/clothing_item.dart';
import '../../features/laundry/domain/entities/clothing_sub_item.dart';
import '../../features/laundry/domain/entities/detergent_item.dart';
import '../../features/laundry/domain/entities/fabric_softener_item.dart';
import '../../features/laundry/domain/entities/laundry_service.dart';
import '../../features/laundry/domain/repositories/laundry_repository.dart';
import '../widgets/snackbar_helper.dart';

class LaundryOrderController extends ChangeNotifier {
  final LaundryRepository repository;
  final AuthController authController;

  // Trạng thái
  bool isLoading = true;
  bool isSubmitting = false;
  bool isLoadingClothingItems = false;

  // Controllers
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Dữ liệu
  List<ClothingItem> clothingItems = [];
  List<AdditionalService> additionalServices = [];
  List<Detergent> detergents = [];
  List<FabricSoftener> fabricSofteners = [];
  List<LaundryService> laundryServices = [];

  // THÊM MỚI - Delivery Methods
  List<DeliveryMethod> _deliveryMethods = [];
  List<DeliveryMethod> get deliveryMethods => _deliveryMethods;

  DeliveryMethod? get selectedDeliveryMethod {
    try {
      return _deliveryMethods.firstWhere((method) => method.isSelected);
    } catch (e) {
      return null;
    }
  }

  // Lựa chọn hiện tại
  LaundryService? selectedService;

  // Constructor
  LaundryOrderController({
    required this.repository,
    required this.authController,
  });

  // Getter để lấy userId
  String? get currentUserId => authController.currentUser?.id;

  // Kiểm tra user đã đăng nhập chưa
  bool get isUserLoggedIn => currentUserId != null;

  // THÊM MỚI - Khởi tạo delivery methods
  void _initializeDeliveryMethods() {
    _deliveryMethods = [
      DeliveryMethod(
        id: 'pickup',
        name: 'Shipper đến lấy',
        description: 'Shipper sẽ đến tận nơi lấy và giao đồ',
        price: 20000, // 20,000đ phí vận chuyển
        icon: 'delivery_dining',
        isSelected: true, // Mặc định chọn
      ),
      DeliveryMethod(
        id: 'dropoff',
        name: 'Tự đến tiệm',
        description: 'Bạn tự mang đồ đến và nhận tại cửa hàng',
        price: 0, // Miễn phí
        icon: 'store',
        isSelected: false,
      ),
    ];
  }

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
        repository.getAdditionalServices(),
        repository.getDetergents(),
        repository.getFabricSofteners(),
        repository.getLaundryServices(),
      ]);

      additionalServices = results[0] as List<AdditionalService>;
      detergents = results[1] as List<Detergent>;
      fabricSofteners = results[2] as List<FabricSoftener>;
      laundryServices = results[3] as List<LaundryService>;

      // THÊM MỚI - Khởi tạo delivery methods
      _initializeDeliveryMethods();

      // Mặc định chọn dịch vụ đầu tiên và load clothing items tương ứng
      if (laundryServices.isNotEmpty) {
        selectedService = laundryServices.first;
        // Load clothing items theo service đầu tiên
        await loadClothingItemsForService(selectedService!.id);
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
        isSelected: false,
        isExpanded: false,
        subItems: item.subItems.map((subItem) => ClothingSubItem(
          id: subItem.id,
          name: subItem.name,
          quantity: 0,
          price: subItem.price,
          serviceId: serviceId,
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
    if (service.id == selectedService?.id) return;

    selectedService = service;

    // Load clothing items mới cho service được chọn
    await loadClothingItemsForService(service.id);

    notifyListeners();
  }

  // THÊM MỚI - Chọn delivery method
  void selectDeliveryMethod(String methodId) {
    for (var method in _deliveryMethods) {
      method.isSelected = method.id == methodId;
    }
    notifyListeners();
  }

  // Các method quản lý clothing items
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
            serviceId: updatedSubItems[subItemIndex].serviceId,
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

  // Quản lý additional services
  void toggleAdditionalService(String serviceId) {
    final index = additionalServices.indexWhere((s) => s.id == serviceId);
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

  // Quản lý detergent
  void selectDetergent(String detergentId) {
    for (int i = 0; i < detergents.length; i++) {
      detergents[i] = Detergent(
        id: detergents[i].id,
        name: detergents[i].name,
        isSelected: detergents[i].id == detergentId,
      );
    }
    notifyListeners();
  }

  // Quản lý fabric softener
  void selectFabricSoftener(String softenerId) {
    for (int i = 0; i < fabricSofteners.length; i++) {
      fabricSofteners[i] = FabricSoftener(
        id: fabricSofteners[i].id,
        name: fabricSofteners[i].name,
        isSelected: fabricSofteners[i].id == softenerId,
      );
    }
    notifyListeners();
  }

  // CHỈ TÍNH PHÍ VẬN CHUYỂN
  // Tiền giặt sẽ được cân ký và tính lại tại tiệm
  double calculateTotalPrice() {
    double total = 0;

    // Chỉ tính phí vận chuyển
    if (selectedDeliveryMethod != null) {
      total += selectedDeliveryMethod!.price;
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

    // THÊM MỚI - Kiểm tra có delivery method được chọn
    final hasSelectedDeliveryMethod = selectedDeliveryMethod != null;

    return address.isNotEmpty &&
        hasSelectedItems &&
        hasSelectedService &&
        hasSelectedDeliveryMethod &&
        isUserLoggedIn;
  }

  // Gửi đơn hàng
  Future<void> submitOrder(BuildContext context) async {
    if (!canSubmitOrder()) {
      if (!isUserLoggedIn) {
        SnackBarHelper.showError(context, 'Vui lòng đăng nhập để đặt đơn');
        return;
      }

      if (selectedService == null) {
        SnackBarHelper.showWarning(context, 'Vui lòng chọn dịch vụ giặt');
        return;
      }

      if (selectedDeliveryMethod == null) {
        SnackBarHelper.showWarning(context, 'Vui lòng chọn phương thức vận chuyển');
        return;
      }

      SnackBarHelper.showWarning(context, 'Vui lòng nhập địa chỉ và chọn ít nhất một sản phẩm');
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

      if (context.mounted) {
        // Hiển thị thông báo thành công
        SnackBarHelper.showSuccess(context, 'Đơn hàng của bạn đã được đặt thành công!');

        // Chuyển về trang chủ sau 1 giây
        Future.delayed(Duration(seconds: 1), () {
          if (context.mounted) {
            // Pop về trang trước (trang chủ)
            Navigator.of(context).pop();
            // Hoặc dùng pushReplacementNamed nếu bạn có route name
            // Navigator.of(context).pushReplacementNamed('/home');
          }
        });
      }
    } catch (e) {
      isSubmitting = false;
      notifyListeners();

      // Hiển thị lỗi
      SnackBarHelper.showError(context, 'Đặt đơn thất bại. Vui lòng thử lại!');
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
      'serviceId': selectedService!.id,
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
          'serviceId': subItem.serviceId,
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
      // THÊM MỚI - Thông tin delivery method
      'deliveryMethod': {
        'id': selectedDeliveryMethod?.id,
        'name': selectedDeliveryMethod?.name,
        'price': selectedDeliveryMethod?.price ?? 0,
      },
      'deliveryFee': selectedDeliveryMethod?.price ?? 0,
      'paymentMethod': 'cashOnDelivery', // COD - tiệm sẽ cân ký và tính tiền
      'totalPrice': calculateTotalPrice(), // Chỉ là phí ship
      'note': 'Tiệm sẽ cân ký và tính tiền khi nhận đồ',
      // THÊM STATUS
      'status': 'pending', // Trạng thái chờ duyệt
      'statusText': 'Chờ duyệt',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  void dispose() {
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }
}