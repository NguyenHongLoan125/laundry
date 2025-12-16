import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/voucher_controller.dart';
import '../widgets/voucher_card.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({Key? key}) : super(key: key);

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ctrl = Provider.of<VoucherController>(context, listen: false);
        ctrl.loadMyVouchers();
      }
    });

    _tabController.addListener(() {
      if (_tabController.index == 1 && mounted) {
        final ctrl = Provider.of<VoucherController>(context, listen: false);
        if (ctrl.availableVouchers.isEmpty && !ctrl.isLoading) {
          ctrl.loadAvailableVouchers();
        }
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
          icon: const Icon(Icons.arrow_back, color: AppColorss.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ưu đãi',
          style: TextStyle(
            color: AppColorss.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              Container(color: Colors.grey[200], height: 1),
              _buildTabs(),
            ],
          ),
        ),
      ),
      body: Consumer<VoucherController>(
        builder: (context, ctrl, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildMyVouchersTab(ctrl),
              _buildAvailableVouchersTab(ctrl),
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
          Tab(text: 'Mã ưu đãi'),
          Tab(text: 'Sử dụng'),
        ],
      ),
    );
  }

  Widget _buildMyVouchersTab(VoucherController ctrl) {
    if (ctrl.isLoading && ctrl.myVouchers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColorss.primary),
      );
    }

    if (ctrl.error != null && ctrl.myVouchers.isEmpty) {
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
              onPressed: ctrl.loadMyVouchers,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (ctrl.myVouchers.isEmpty) {
      return const Center(
        child: Text('Bạn chưa có mã ưu đãi nào'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Tất cả ưu đãi (${ctrl.myVouchers.length})',
            style: const TextStyle(
              fontSize: 14,
              color: AppColorss.textGrey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: ctrl.myVouchers.length,
            itemBuilder: (context, index) {
              return VoucherCard(voucher: ctrl.myVouchers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableVouchersTab(VoucherController ctrl) {
    if (ctrl.isLoading && ctrl.availableVouchers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColorss.primary),
      );
    }

    if (ctrl.error != null && ctrl.availableVouchers.isEmpty) {
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
              onPressed: ctrl.loadAvailableVouchers,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (ctrl.availableVouchers.isEmpty) {
      return const Center(
        child: Text('Không có ưu đãi khả dụng'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ctrl.availableVouchers.length,
      itemBuilder: (context, index) {
        return VoucherCard(voucher: ctrl.availableVouchers[index]);
      },
    );
  }
}