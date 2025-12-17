import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../router/app_routes.dart';
import '../controllers/laundry_order_controller.dart';
import '../widgets/address_input_widget.dart';
import '../widgets/package_selector_widget.dart';
import '../widgets/primary_button.dart';
import '../widgets/service_selector_widget.dart';
import '../widgets/clothing_items_widget.dart';
import '../widgets/detergent_selector_widget.dart';
import '../widgets/fabric_softener_selector_widget.dart';

class LaundryOrderScreen extends StatefulWidget {
  @override
  _LaundryOrderScreenState createState() => _LaundryOrderScreenState();
}

class _LaundryOrderScreenState extends State<LaundryOrderScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LaundryOrderProvider>().loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LaundryOrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Đơn giặt"),
        leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(context, AppRoutes.home);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.text,)
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            AddressInputWidget(
              controller: provider.addressController,
            ),

            PackageSelectorWidget(
              packages: provider.packages,
              selectedPackage: provider.selectedPackage,
              usePackage: provider.usePackage,
              onTogglePackage: provider.togglePackageUsage,
            ),

            ServiceSelectorWidget(
              selectedService: provider.selectedService,
              onServiceSelected: provider.selectService,
            ),

            ClothingItemsWidget(
              items: provider.clothingItems,
              onToggleItem: provider.toggleClothingItem,
              onUpdateQuantity: provider.updateSubItemQuantity,
            ),

            DetergentSelectorWidget(
              detergents: provider.detergents,
              onToggle: provider.toggleDetergent,
            ),

            FabricSoftenerSelectorWidget(
              fabricSofteners: provider.fabricSofteners,
              onToggle: provider.toggleFabricSoftener,
            ),

            const SizedBox(height: 20),

            PrimaryButton(
              label: "Tiếp tục",
              isLoading: provider.isSubmitting,
              onPressed: provider.isSubmitting
                  ? null
                  : () => provider.submitOrder(context),
            ),
          ],
        ),
      ),
    );
  }
}
