import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/auth/data/models/service_model.dart';

import '../../../core/constants/app_colors.dart';

class KindsOfService extends StatelessWidget {
  final List<ServiceModel> services;

  const KindsOfService({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardHeigt = size.height*0.2;


    return Padding(
        padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Loại dịch vụ',
            style: TextStyle(
              fontSize: size.width * 0.06,
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: size.height*0.02,),
          ListView.separated(
            shrinkWrap: true,
              itemBuilder: (_, __) =>
                  SizedBox(height: (size.width * 0.03).clamp(10.0, 16.0)),
              separatorBuilder: (context, index){
                final service = services[index];

                return Container(
                  height: cardHeigt,
                  width: cardHeigt,
                  decoration: BoxDecoration(
                    border: Border.all(
                      
                    ),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                    
                  ),
                );
              },
              itemCount: services.length,
          )
        ],
      ),
    );
  }
}

class CustomServiceCard extends StatelessWidget {
  final Size size;
  final double height;
  final bool selected;
  const CustomServiceCard({
    super.key,
    required this.size,
    required this.height,
    required this.selected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
          border: Border.all(

          ),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Center(

      ),
    );
  }
}

