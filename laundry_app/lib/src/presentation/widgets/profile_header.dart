import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:AppColors.backgroundThird,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: Image.asset("lib/src/assets/images/Group 2211.png"),
          ),
          const SizedBox(width: 26),
          Text(
            name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
