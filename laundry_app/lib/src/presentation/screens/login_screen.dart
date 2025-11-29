import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/auth_switch_widget.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import '../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tiêu đề
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 40),
                      child: HeaderText(
                        title: 'Đăng nhập',
                        message: "đăng nhập để trải nghiệm những điều tuyệt vời với chúng tôi",
                      ),
                    ),

                    // Form & Button
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundThird,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Email
                            CustomTextField(
                              controller: emailController,
                              label: 'Email',
                              icon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            // Password
                            CustomTextField(
                              controller: passwordController,
                              label: 'Mật khẩu',
                              icon: Icons.lock_rounded,
                              obscureText: true,
                            ),
                            const SizedBox(height: 60),

                            // Nút Login
                            PrimaryButton(
                              label: "Đăng nhập",
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, AppRoutes.home);
                              },
                            ),
                            const SizedBox(height: 16),

                            AuthSwitchWidget(
                              questionText: "Bạn chưa có tài khoản?",
                              buttonText: "Đăng ký",
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.register);
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
