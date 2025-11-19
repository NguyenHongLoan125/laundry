import 'package:flutter/material.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import '../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
            padding:  EdgeInsets.only(left: 20, right: 20, top:80, bottom: 40),
            child: Column(
              children: [
                Stack(
                  children: [
                    // Stroke
                    Text(
                      'Đăng ký',
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
                      'Đăng ký ',
                      style: GoogleFonts.pacifico(
                        fontSize: 48,
                        color: AppColors.backgroundSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "đăng ký để trải nghiệm những điều tuyệt vời với chúng tôi",
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
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      labelText: 'Tên',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(
                        Icons.person_rounded,
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary, width: 1.5),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    cursorColor: AppColors.primary,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary, width: 1.5),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    cursorColor: AppColors.primary,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary, width: 1.5),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    cursorColor: AppColors.primary,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      labelText: 'Mật khẩu',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(
                        Icons.lock_open_outlined,
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.textPrimary, width: 1.5),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    cursorColor: AppColors.primary,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 60),

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
                        "Tạo tài khoản",
                        style: GoogleFonts.pacifico(
                            fontSize: 18,
                          color: AppColors.textThird,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          " Bạn đã có tài khoản? ",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }


}
