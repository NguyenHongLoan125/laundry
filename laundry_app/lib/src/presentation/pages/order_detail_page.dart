import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/order_item_card.dart';
import 'package:laundry_app/src/presentation/widgets/payment_info_card.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_header_card.dart';
import '../widgets/shipping_info_card.dart';
import '../widgets/receiver_info_card.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ctrl = Provider.of<OrderController>(context, listen: false);
        ctrl.loadOrder(widget.orderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorss.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00BCD4)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ưu đãi',
          style: TextStyle(
            color: Color(0xFF00BCD4),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<OrderController>(
          builder: (context, ctrl, child) {
            if (ctrl.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (ctrl.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ctrl.error!,
                      style: const TextStyle(color: AppColorss.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ctrl.loadOrder(widget.orderId),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (ctrl.order == null) {
              return const Center(child: Text('Không tìm thấy đơn hàng'));
            }

            return Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        OrderHeaderCard(order: ctrl.order!),
                        const SizedBox(height: 16),
                        ShippingInfoCard(shipping: ctrl.order!.shipping),
                        const SizedBox(height: 16),
                        ReceiverInfoCard(shipping: ctrl.order!.shipping),
                        const SizedBox(height: 16),
                        OrderItemsCard(
                          items: ctrl.order!.items,
                          total: ctrl.order!.total,
                        ),
                        const SizedBox(height: 16),
                        PaymentInfoCard(payment: ctrl.order!.payment),
                        const SizedBox(height: 16),
                        _buildActionButton(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to rating screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Đánh giá',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColorss.white,
          ),
        ),
      ),
    );
  }
}