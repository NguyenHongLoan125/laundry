import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/laundry_injection.dart';
import '../controllers/laundry_order_controller.dart';
import '../widgets/delivery_method_widget.dart';
import '../widgets/generic_selector_widget.dart';
import '../widgets/service_selector_widget.dart';
import '../widgets/clothing_items_widget.dart';
import '../widgets/additional_services_widget.dart';
import '../widgets/notes_widget.dart';
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
  final String myFont = 'Pacifico';

  @override
  void initState() {
    super.initState();
    _orderController = LaundryOrderDI.getLaundryOrderController();
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
          title: Text(
            'Đơn giặt',
            style: TextStyle(
              fontFamily: myFont,
              color: Color(0xFF00BFA5),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<LaundryOrderController>(
          builder: (context, provider, child) {
            if (!provider.isUserLoggedIn) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Vui lòng đăng nhập để đặt đơn', style: TextStyle(fontFamily: myFont)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('Đăng nhập', style: TextStyle(fontFamily: myFont)),
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

                        // Loại dịch vụ
                        _buildSection(
                          'Loại dịch vụ',
                          ServiceSelectorWidget(
                            services: provider.laundryServices,
                            selectedService: provider.selectedService,
                            onServiceSelected: provider.selectService,
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

                        // Dịch vụ đi kèm
                        _buildSection(
                          'Dịch vụ đi kèm',
                          AdditionalServicesWidget(
                            services: provider.additionalServices,
                            onToggle: provider.toggleAdditionalService,
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

                        // PHƯƠNG THỨC VẬN CHUYỂN - ĐẶT Ở ĐÂY
                        _buildSection(
                          'Phương thức vận chuyển',
                          DeliveryMethodWidget(
                            methods: provider.deliveryMethods,
                            onMethodSelected: provider.selectDeliveryMethod,
                            myFont: myFont,
                          ),
                        ),

                        // Ghi chú
                        _buildSection(
                          'Ghi chú',
                          NotesWidget(controller: provider.notesController),
                        ),

                        // Thông tin thanh toán COD
                        _buildSection(
                          'Phương thức thanh toán',
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF00BFA5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  color: Color(0xFF00BFA5),
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thanh toán khi nhận hàng (COD)',
                                        style: TextStyle(
                                          fontFamily: myFont,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF00BFA5),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Thanh toán bằng tiền mặt khi nhận đồ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF00BFA5),
                                  size: 24,
                                ),
                              ],
                            ),
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
              style: TextStyle(
                fontFamily: myFont,
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