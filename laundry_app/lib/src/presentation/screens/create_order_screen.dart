import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/layouts/seven_parts_layout.dart';
import 'package:laundry_app/src/presentation/pages/create_order_pages/address.dart';
import 'package:laundry_app/src/presentation/pages/create_order_pages/washing_package.dart';
import 'package:laundry_app/src/presentation/widgets/app_bar.dart';

import '../../features/auth/data/models/service_model.dart';
import '../controllers/create_order_controller.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  late final List<MyWashingPackageModel> packages;
  @override
  void initState() {
    packages = _fakeMyWashingPackages();
    super.initState();
  }

  List<MyWashingPackageModel> _fakeMyWashingPackages() {
    return [
      MyWashingPackageModel(
        name: 'Gói giặt sấy 40kg',
        discount: 0.2,
        expirationDate: DateTime(2025, 12, 5),
      ),
      MyWashingPackageModel(
        name: 'Gói giặt sấy 20kg',
        discount: 0.1,
        expirationDate: DateTime(2025, 12, 20),
      ),
      MyWashingPackageModel(
        name: 'Gói giặt sấy 10kg',
        discount: 0,
        expirationDate: DateTime(2025, 11, 30),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Đơn giặt',
          returnArrow: (){}
      ),

      body: SevenPartsLayout(
        part1: Container(
          child: Address(
            onTap: (){},
          ),
        ),
        part2: Container(
          child: WashingPackage(
               seeAll: (){},
            myWashingPackages: packages,
          ),
        ),
        part3: Container(),
        part4: Container(),
        part5: Container(),
        part6: Container(),
        part7: Container(),
      ),
    );
  }
}
