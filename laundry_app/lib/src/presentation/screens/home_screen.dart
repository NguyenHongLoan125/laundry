import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/features/auth/data/models/home_model.dart';
import 'package:laundry_app/src/presentation/controllers/home_controller.dart';
import 'package:laundry_app/src/presentation/layouts/seven_parts_layout.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/appointment_home.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/banner_slider.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/recent_orders.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/type_of_clothes.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/types_of_service.dart';
import 'package:laundry_app/src/presentation/pages/home_pages/washing_package.dart';
import 'package:laundry_app/src/router/route_names.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String ?displayName;
  String ? displayAvatar;
  int _currentIndex =0;
  int currentBannerSlider =0;
  bool isLoading = true;
  final List<String> images = [
    "lib/src/assets/images/test1.jpg",
    "lib/src/assets/images/test2.jpg",
    "lib/src/assets/images/test3.jpg"
  ];

  final TextEditingController findingController = TextEditingController();
  final controller = HomeController();
  final Appointment appointment = Appointment();
  late final List<OrderModel> order;
  late final List<WashingPackageModel> packages;

  @override
  void initState() {
    super.initState();
    order = _fakeOrders();
    packages = _fakeWashingPackages();
    //Giả lặp API
    Future.delayed(const Duration(seconds: 3),(){
      setState(() {
        isLoading = false;
      });
    });
  }

  List<OrderModel> _fakeOrders() {
    return [
      OrderModel(
        id: '#00000001',
        date: DateTime(2025, 11, 3),
        price: 200000,
        status: OrderStatus.cancelled,
      ),
      OrderModel(
        id: '#00000002',
        date: DateTime(2025, 11, 5),
        price: 350000,
        status: OrderStatus.processing,
      ),
      OrderModel(
        id: '#00000003',
        date: DateTime(2025, 11, 9),
        price: 120000,
        status: OrderStatus.completed,
      ),
    ];
  }

  List<WashingPackageModel> _fakeWashingPackages() {
    return [
      WashingPackageModel(
        name: 'Gói 40kg',
        description:
        'Sử dụng dòng máy giặt dân sinh cao cấp. Đồ sau khi giặt xong được sấy khô, '
            'diệt khuẩn và gấp gọn. Giặt riêng mỗi khách một máy. '
            'Gói giặt sấy chỉ áp dụng với quần áo thông thường, vỏ chăn, ga, gối.',
        note:
        'Gói giặt được tặng miễn phí dịch vụ ủi và miễn phí vận chuyển khi sử dụng gói giặt.',
        price: 699000,
      ),
      WashingPackageModel(
        name: 'Gói 20kg',
        description:
        'Giặt riêng mỗi khách một máy. Sấy khô, diệt khuẩn và gấp gọn sau khi giặt. '
            'Áp dụng cho quần áo thông thường.',
        note: 'Tặng miễn phí vận chuyển trong bán kính 3km.',
        price: 399000,
      ),
      WashingPackageModel(
        name: 'Gói 10kg',
        description:
        'Giặt - sấy khô - gấp gọn. Phù hợp nhu cầu giặt hằng tuần.',
        note: 'Không áp dụng cho chăn mền lớn.',
        price: 249000,
      ),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          displayName?? 'Hong Loan',
          style: TextStyle(
             color: AppColors.primary,
            fontFamily: 'Pacifico',
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.text)
            ),
            child: CircleAvatar(
              radius: 9,
              backgroundImage: displayAvatar!= null ?
              FileImage(File(displayAvatar!))
              : null,
              backgroundColor: AppColors.backgroundAppBar,
              child: displayAvatar == null ? Icon(Icons.person, color: AppColors.text,):null,
            ),
          ),
        ),

        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications_active_rounded)
          ),
          IconButton(onPressed: (){},
              icon: Icon(Icons.settings)
          )
        ],
      ),

      body: SevenPartsLayout(
        part1: Container(
          child:TextField(
            controller: findingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Tìm kiếm',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none
              )
            ),
          ),
        ),
        part2: Container(
          child: Center(
            child: BannerSlider(
                isLoading: isLoading,
                currentPage: currentBannerSlider,
                imageBanner: images,
                onPageChanged: (index){
                  setState(() {
                    currentBannerSlider = index;
                  });
                }
            ),
          ),
        ),
        part3: Container(
          child: TypesOfService(
              isLoading: controller.isLoading,
              services: controller.services,
          )

        ),
        part4: Container(
          child: TypeOfClothes(
              isLoading: isLoading,
              clothes: controller.clothes,
          ),
        ),
        part5: Container(
          child: AppointmentHome(appointment: appointment),
        ),
        part6: Container(
          child: RecentOrders(order: order,),
        ),
        part7: Container(
          child: WashingPackage(washingPackage: packages),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            String routeName;
            switch (index){
              case 0:
                routeName = RouteNames.home;
                break;
              case 1:
                routeName = RouteNames.account;
                break;
              case 2:
                routeName = RouteNames.account;
                break;
              case 3:
                routeName = RouteNames.account;
                break;
              case 4:
                routeName = RouteNames.account;
                break;
              default:
              routeName = RouteNames.home;
            }
            if (ModalRoute.of(context)?.settings.name != routeName) {
              Navigator.pushReplacementNamed(context, routeName);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.text,
          unselectedItemColor: AppColors.text,
          backgroundColor: AppColors.backgroundAppBar,


          items: [
            _buildNavItem(Icons.home_outlined, "Trang chủ", 0),
            _buildNavItem(Icons.grid_view, "Dịch vụ", 1),
            _buildNavItem(Icons.sticky_note_2_outlined, "Đơn giặt", 2),
            _buildNavItem(Icons.calendar_month_sharp, "Lịch hẹn", 3),
            _buildNavItem(Icons.person_pin, "Tài khoản", 4),

          ]
      ),
    );
  }
  BottomNavigationBarItem _buildNavItem (IconData icon, String label, int index){
    bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
        label: label,
        icon: isSelected
            ? Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.white),
        )
            : Icon(icon, color: AppColors.text),
    );
  }
}


