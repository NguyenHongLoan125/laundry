import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/pages/address_picker_page.dart';
import 'package:laundry_app/src/presentation/widgets/app_bar.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:latlong2/latlong.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  LatLng? currentLatLng; //  Lưu vị trí đã chọn

  String? ward;
  String? district;
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF2FB),
      appBar: CustomAppBar(
        title: "Thông tin liên hệ",
        returnArrow: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 35,
                  child: Image.asset(
                    "lib/src/assets/images/Group 2211.png",
                    width: 150,
                    height: 200,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              CustomTextField(
                controller: nameController,
                label: "Họ và tên",
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: phoneController,
                label: "Số điện thoại",
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: emailController,
                label: "Email",
              ),
              const SizedBox(height: 16),

          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BeautifulGrabAddressPicker(
                    initialPosition: currentLatLng,          //  truyền lại vị trí đã chọn
                    initialAddress: addressController.text,  //  truyền lại địa chỉ đã chọn
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  addressController.text = result["address"];
                  currentLatLng = LatLng(result["lat"], result["lng"]);
                });
              }
            },
            child: AbsorbPointer(
              child: CustomTextField(
                controller: addressController,
                label: "Địa chỉ",
              ),
            ),
          ),

          const SizedBox(height: 40),
              PrimaryButton(
                label: "Lưu thông tin",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
