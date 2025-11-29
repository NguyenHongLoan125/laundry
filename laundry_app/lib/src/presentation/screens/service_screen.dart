import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/features/service/data/models/price_model.dart';
import 'package:laundry_app/src/presentation/controllers/service_controller.dart';
import 'package:laundry_app/src/presentation/widgets/price-item.dart';
import 'package:laundry_app/src/presentation/widgets/service_card.dart';
import 'package:laundry_app/src/presentation/widgets/service_type_dropdown.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final controller = ServiceController();
  String? selectedServiceType;

  @override
  void initState() {
    super.initState();

    // Thêm Future.microtask để tránh rebuild ngay trong initState
    Future.microtask(() async {
      await controller.loadData();

      // Chọn service đầu tiên từ dữ liệu JSON khi load xong
      if (controller.prices.isNotEmpty) {
        setState(() {
          selectedServiceType = controller.prices.first.type;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dịch vụ"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.loadData();
            },
          )
        ],
      ),

      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Loại dịch vụ chính",
                    style: TextStyle(
                      color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 10),

                Column(
                  children: controller.mainServices.map((service) {
                    return ServiceCard(service: service);
                  }).toList(),
                ),
                SizedBox(height: 24),

                Text(
                    "Loại dịch vụ phụ",
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 10),

                Column(
                  children: controller.extraServices.map((service) {
                    return ServiceCard(service: service);
                  }).toList(),
                ),
                SizedBox(height: 24),

                Text(
                    "Bảng giá tham khảo",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    )
                ),
                SizedBox(height: 10),

                Text(
                    "Giá tiền sẽ được phân loại theo từng loại đồ và dịch vụ khác nhau",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    )
                ),

                // Nếu selectedServiceType null thì không hiện bảng giá
                if (selectedServiceType == null)
                  Center(child: Text("Bảng giá hiện không có sẵn"))
                else
                  ServiceTypeDropdown(
                    selectedValue: selectedServiceType,
                    options: controller.prices.map((p) => p.type).toSet().toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedServiceType = value;
                        });
                      }
                    },
                  ),
                SizedBox(height: 16),

                // Bảng giá, chỉ hiển thị khi selectedServiceType != null
                if (selectedServiceType != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundThird,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      children: controller.prices
                          .firstWhere(
                            (p) => p.type == selectedServiceType,
                        orElse: () => PriceModel(type: '', category: []),
                      )
                          .category
                          .map((c) => PriceGroupWidget(group: c))
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
