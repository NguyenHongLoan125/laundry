import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/presentation/widgets/auth_switch_widget.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:laundry_app/src/router/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // Tiêu đề
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 40),
                      child:  HeaderText(
                        title: 'Đăng ký',
                        message: "đăng ký để trải nghiệm những điều tuyệt vời với chúng tôi",
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
                            CustomTextField(
                              controller: nameController,
                              label: 'Tên',
                              icon: Icons.person_rounded,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: emailController,
                              label: 'Email',
                              icon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: phoneController,
                              label: 'Số điện thoại',
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: passwordController,
                              label: 'Mật khẩu',
                              icon: Icons.lock_rounded,
                              obscureText: true,
                            ),
                            const SizedBox(height: 60),

                            PrimaryButton(
                              label: "Tạo tài khoản",
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.auth,
                                  arguments: emailController.text,
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            AuthSwitchWidget(
                              questionText: "Bạn đã có tài khoản?",
                              buttonText: "Đăng nhập",
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.login);
                              },
                            ),
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
