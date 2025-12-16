import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import 'package:laundry_app/src/presentation/widgets/auth_switch_widget.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/router/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRegister() async {
    final controller = context.read<AuthController>();

    final success = await controller.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showMessage(controller.successMessage ?? 'Đăng ký thành công', false);

      // Navigate to OTP screen
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.auth,
        arguments: emailController.text.trim(),
      );
    } else {
      _showMessage(controller.errorMessage ?? 'Đăng ký thất bại', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundMain,
      body: Consumer<AuthController>(
        builder: (context, controller, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 80,
                            bottom: 40,
                          ),
                          child: HeaderText(
                            title: 'Đăng ký',
                            message: 'Tạo tài khoản để trải nghiệm những điều tuyệt vời với chúng tôi',
                          ),
                        ),

                        // Form Container
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 40,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundThird,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Name Field
                                CustomTextField(
                                  controller: nameController,
                                  label: 'Tên',
                                  icon: Icons.person_rounded,
                                ),
                                const SizedBox(height: 16),

                                // Email Field
                                CustomTextField(
                                  controller: emailController,
                                  label: 'Email',
                                  icon: Icons.email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                // Phone Field
                                CustomTextField(
                                  controller: phoneController,
                                  label: 'Số điện thoại',
                                  icon: Icons.phone_rounded,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                CustomTextField(
                                  controller: passwordController,
                                  label: 'Mật khẩu',
                                  icon: Icons.lock_rounded,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 60),

                                // Register Button
                                controller.isLoading
                                    ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                                    : PrimaryButton(
                                  label: "Tạo tài khoản",
                                  onPressed: _handleRegister,
                                ),

                                const SizedBox(height: 20),

                                // Switch to Login
                                AuthSwitchWidget(
                                  questionText: "Bạn đã có tài khoản?",
                                  buttonText: "Đăng nhập",
                                  onPressed: () {
                                    controller.clearMessages();
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
          );
        },
      ),
    );
  }
}