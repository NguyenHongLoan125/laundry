import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const String myFont = 'Pacifico';

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    
      selectedItemColor: AppColors.textPrimary, 
      
      unselectedItemColor: AppColors.primary, 
      
      showUnselectedLabels: true,
      
      selectedLabelStyle: const TextStyle(
        fontFamily: myFont,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      
      unselectedLabelStyle: const TextStyle(
        fontFamily: myFont,
        fontSize: 11,
      ),
      
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Dịch Vụ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Đơn giặt',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}