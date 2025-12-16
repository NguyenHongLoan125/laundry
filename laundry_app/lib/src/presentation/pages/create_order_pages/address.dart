import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Address extends StatelessWidget {
  final VoidCallback ? onTap;
  const Address({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final addressButton = size.height*0.045;

    
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Địa chỉ',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.05
            ),
          ),

          SizedBox(height: size.height*0.02,),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: addressButton,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width:1,
                  color: AppColors.textPrimary
                )
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width*0.02,
                    vertical: size.width*0.02
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Thêm địa chỉ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: size.height*0.018
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
