import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/auth/data/models/home_model.dart';

class AppointmentHome extends StatelessWidget {
  final Appointment appointment;
  const AppointmentHome({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final appointmentHeight = size.height*0.2;

    return Padding(
        padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch hẹn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  fontSize: size.width*0.06,
                ),
              ),

              InkWell(
                onTap: (){},
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                      color: AppColors.text,
                      fontSize: size.width*0.05,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: size.height*0.02,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              height: appointmentHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          appointment.scheduleTime!=null
                              ? "${appointment.scheduleTime!.hour.toString().padLeft(2, '0')}:${appointment.scheduleTime!.minute.toString().padLeft(2, '0')}"
                              : "16:00",
                          style: TextStyle(
                             fontSize: size.height*0.025,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: size.height*0.001,),
                        Text(
                          appointment.scheduleTime != null
                              ? "${appointment.scheduleTime!.day.toString().padLeft(2, '0')} Th${appointment.scheduleTime!.month}"
                              : "05 Th12",
                          style: TextStyle(
                            fontSize: size.height*0.025,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height*0.01,),
                        Container(
                          alignment: Alignment.center,
                            height: size.height*0.05,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundMain,
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(8),
                              child: Text(
                                  'Đã xác nhận',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary
                                ),
                              ),
                            ),
                        )
                      ],
                    ),

                    //cot ben phai
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mã xác nhận: ${appointment.appointmentId ?? "000000000001"}",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: size.height*0.016,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: size.height*0.001,),
                        Text(
                          appointment.note ?? "Hẹn đưa đồ đến tiệm",
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: size.height*0.012,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: size.height*0.001,),
                        Text(
                          "Shipper sẽ đến vào ${appointment.rememberTime != null
                              ? "${appointment.rememberTime!.hour.toString().padLeft(2, '0')}:${appointment.rememberTime!.minute.toString().padLeft(2, '0')} "
                              "${appointment.rememberTime!.day.toString().padLeft(2, '0')}/${appointment.rememberTime!.month}/${appointment.rememberTime!.year}"
                              : "12:00 03/11/2025"}",
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: size.height*0.012,
                              fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic
                          ),
                        )

                      ],
                    )
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
