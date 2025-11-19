import 'package:flutter/material.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import '../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tiêu đề
          Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            padding:  EdgeInsets.only(left: 10, right: 10, top:80, bottom: 40),
            child: Column(
              children: [
                Stack(
                  children: [
                    // Stroke
                    Text(
                      'Nhập mã xác minh',
                      style: GoogleFonts.pacifico(
                        fontSize: 48,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = AppColors.primary,
                      ),
                    ),
                    // Fill
                    Text(
                      'Nhập mã xác minh',
                      style: GoogleFonts.pacifico(
                        fontSize: 48,
                        color: AppColors.backgroundSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Hãy điền mã xác thực gồm 6 chữ số vừa được gửi đến Email  n*****************@gmail.com",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),



          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),

              decoration: BoxDecoration(
                color: AppColors.backgroundThird,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: AppColors.backgroundThird,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                          style: const TextStyle(fontSize: 20),
                          cursorColor: AppColors.primary,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),


                  // Nút Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  Text(
                        "Tiếp tục",
                        style: GoogleFonts.pacifico(
                          fontSize: 18,
                          color: AppColors.textThird,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),


                ],
              ),
            ),
          ),

        ],
      ),
    );
  }


}
