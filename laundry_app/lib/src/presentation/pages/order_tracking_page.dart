import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/tracking_controller.dart';
import '../widgets/tracking_tab_content.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ctrl = Provider.of<TrackingController>(context, listen: false);
        ctrl.loadTracking(widget.orderId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorss.background,
      appBar: AppBar(
        backgroundColor: AppColorss.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColorss.primary, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tracking đơn hàng',
          style: TextStyle(
            color: AppColorss.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                height: 1,
              ),
              _buildTabs(),
            ],
          ),
        ),
      ),
      body: Consumer<TrackingController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColorss.primary),
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
                    onPressed: () => ctrl.loadTracking(widget.orderId),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (ctrl.tracking == null) {
            return const Center(child: Text('Không tìm thấy thông tin tracking'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              TrackingTabContent(steps: ctrl.tracking!.pickupTimeline),
              TrackingTabContent(steps: ctrl.tracking!.deliveryTimeline),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColorss.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColorss.primary,
        indicatorWeight: 3,
        labelColor: AppColorss.primary,
        unselectedLabelColor: AppColorss.textGrey,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Chờ đưa đồ'),
          Tab(text: 'Chờ nhận đồ'),
        ],
      ),
    );
  }
}