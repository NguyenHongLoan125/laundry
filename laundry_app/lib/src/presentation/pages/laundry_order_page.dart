import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/laundry_injection.dart';
import '../../router/route_names.dart';
import '../controllers/laundry_order_controller.dart';
import '../widgets/generic_selector_widget.dart';
import '../widgets/package_selector_widget.dart';
import '../widgets/service_selector_widget.dart';
import '../widgets/clothing_items_widget.dart';
import '../widgets/additional_services_widget.dart';
import '../widgets/shipping_method_widget.dart';
import '../widgets/notes_widget.dart';
import '../widgets/discount_code_widget.dart';
import '../widgets/payment_method_widget.dart';
import '../widgets/price_summary_widget.dart';
import '../widgets/text_field.dart';
import 'address_picker_page.dart';

class LaundryOrderScreen extends StatefulWidget {
  const LaundryOrderScreen({Key? key}) : super(key: key);

  @override
  State<LaundryOrderScreen> createState() => _LaundryOrderScreenState();
}

class _LaundryOrderScreenState extends State<LaundryOrderScreen> {
  LatLng? _currentLatLng;
  late LaundryOrderController _orderController;

  @override
  void initState() {
    super.initState();
    // Tạo controller từ LaundryOrderDI
    _orderController = LaundryOrderDI.getLaundryOrderController();
    // Load data ngay sau khi tạo controller
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await _orderController.loadInitialData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải dữ liệu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _orderController,
      child: Scaffold(
        backgroundColor: AppColors.backgroundMain,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.backgroundMain,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF00BFA5)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Đơn giặt',
            style: TextStyle(
              color: Color(0xFF00BFA5),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<LaundryOrderController>(
          builder: (context, provider, child) {
              // Kiểm tra user đã đăng nhập chưa
            if (!provider.isUserLoggedIn) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Vui lòng đăng nhập để đặt đơn'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('Đăng nhập'),
                    ),
                  ],
                ),
              );
            }

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hiển thị thông tin user
                        // Card(
                        //   child: ListTile(
                        //     leading: Icon(Icons.person, color: Color(0xFF00BFA5)),
                        //     title: Text(provider.authController.currentUser?.fullName ?? ''),
                        //     subtitle: Text('Chúc bạn có một trải nghiệm tuyệt vời'),
                        //   ),
                        // ),
                        // const SizedBox(height: 16),

                        // Địa chỉ
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BeautifulGrabAddressPicker(
                                  initialPosition: _currentLatLng,
                                  initialAddress: provider.addressController.text,
                                ),
                              ),
                            );

                            if (result != null && result is Map<String, dynamic>) {
                              setState(() {
                                provider.addressController.text = result["address"] ?? "";
                                final lat = result["lat"];
                                final lng = result["lng"];
                                if (lat != null && lng != null) {
                                  _currentLatLng = LatLng(lat, lng);
                                }
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller: provider.addressController,
                              label: "Địa chỉ",
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ... các widget khác giữ nguyên ...
                        // Gói giặt
                        _buildSection(
                          'Gói giặt',
                          PackageSelectorWidget(
                            packages: provider.packages,
                            selectedPackage: provider.selectedPackage,
                            usePackage: provider.usePackage,
                            onTogglePackage: provider.togglePackageUsage,
                            onSelectPackage: provider.selectPackage,
                          ),
                        ),

                        // Loại dịch vụ
                        _buildSection(
                          'Loại dịch vụ',
                          ServiceSelectorWidget(
                            services: provider.laundryServices,
                            selectedService: provider.selectedService,
                            onServiceSelected: provider.selectService,
                          ),
                        ),

                        // Dịch vụ đi kèm
                        _buildSection(
                          'Dịch vụ đi kèm',
                          AdditionalServicesWidget(
                            services: provider.additionalServices,
                            onToggle: provider.toggleAdditionalService,
                          ),
                        ),

                        // Loại đồ
                        _buildSection(
                          'Loại đồ',
                          ClothingItemsWidget(
                            items: provider.clothingItems,
                            onToggleItem: provider.toggleClothingItem,
                            onToggleItemExpansion: provider.toggleClothingItemExpansion,
                            onUpdateQuantity: provider.updateSubItemQuantity,
                          ),
                        ),

                        // Nước giặt
                        _buildSection(
                          'Nước giặt',
                          SimpleSelectorWidget(
                            items: provider.detergents
                                .map((d) => SelectableItemData(
                              id: d.id,
                              name: d.name,
                              isSelected: d.isSelected,
                            ))
                                .toList(),
                            onToggle: provider.selectDetergent,
                          ),
                        ),

                        // Nước xả vải
                        _buildSection(
                          'Nước xả vải',
                          SimpleSelectorWidget(
                            items: provider.fabricSofteners
                                .map((f) => SelectableItemData(
                              id: f.id,
                              name: f.name,
                              isSelected: f.isSelected,
                            ))
                                .toList(),
                            onToggle: provider.selectFabricSoftener,
                          ),
                        ),

                        // Phương thức vận chuyển
                        _buildSection(
                          'Phương thức vận chuyển',
                          ShippingMethodWidget(
                            shippingMethods: provider.shippingMethods,
                            selectedMethod: provider.selectedShippingMethod,
                            onSelectMethod: provider.selectShippingMethod,
                            onPickupDateChanged: provider.setPickupDate,
                            onDeliveryDateChanged: provider.setDeliveryDate,
                          ),
                        ),

                        // Ghi chú
                        _buildSection(
                          'Ghi chú',
                          NotesWidget(controller: provider.notesController),
                        ),

                        // Mã giảm giá
                        _buildSection(
                          '',
                          DiscountCodeWidget(
                            appliedDiscount: provider.appliedDiscount,
                            onOpenDiscountPage: () {
                              Navigator.pushNamed(context, RouteNames.myVoucher);
                            },
                          ),
                        ),

                        // Phương thức thanh toán
                        _buildSection(
                          'Phương thức thanh toán',
                          PaymentMethodWidget(
                            selectedMethod: provider.selectedPaymentMethod,
                            onSelectMethod: provider.selectPaymentMethod,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom price summary
                PriceSummaryWidget(
                  totalPrice: provider.calculateTotalPrice(),
                  isSubmitting: provider.isSubmitting,
                  canSubmit: provider.canSubmitOrder(),
                  onSubmit: () => provider.submitOrder(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00BFA5),
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _orderController.dispose();
    super.dispose();
  }
}