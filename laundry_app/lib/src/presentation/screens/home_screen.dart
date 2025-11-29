import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/presentation/layouts/seven_parts_layout.dart';
import '../../router/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String ?displayName;
  String ? displayAvatar;
  int _currentIndex =0;

  final TextEditingController findingController = TextEditingController();

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

        ),
        part3: Container(),
        part4: Container(),
        part5: Container(),
        part6: Container(),
        part7: Container(),
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


