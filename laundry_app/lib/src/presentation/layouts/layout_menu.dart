import 'package:flutter/material.dart';
import '../pages/laundry_order_page.dart';
import '../screens/home_screen.dart';
import '../screens/order_hisory_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/service_screen.dart';
import '../widgets/bottom_nav_bar.dart';


class AppScreenWithBottomNavBar extends StatefulWidget {
  const AppScreenWithBottomNavBar({super.key});

  @override
  State<AppScreenWithBottomNavBar> createState() => _AppScreenWithBottomNavBarState();
}

class _AppScreenWithBottomNavBarState extends State<AppScreenWithBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ServiceScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}