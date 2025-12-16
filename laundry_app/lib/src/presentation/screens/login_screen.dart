import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import 'package:laundry_app/src/presentation/widgets/auth_switch_widget.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/router/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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

  Future<void> _handleLogin() async {
    final controller = context.read<AuthController>();

    final success = await controller.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showMessage(controller.successMessage ?? 'Đăng nhập thành công', false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      _showMessage(controller.errorMessage ?? 'Đăng nhập thất bại', true);
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
                            title: 'Đăng nhập',
                            message: 'đăng nhập để trải nghiệm những điều tuyệt vời với chúng tôi',
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
                                // Email Field
                                CustomTextField(
                                  controller: emailController,
                                  label: 'Email',
                                  icon: Icons.email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                CustomTextField(
                                  controller: passwordController,
                                  label: 'Mật khẩu',
                                  icon: Icons.lock_rounded,
                                  obscureText: true,
                                ),

                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: Navigate to forgot password
                                    },
                                    child: Text(
                                      'Quên mật khẩu?',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // Login Button
                                controller.isLoading
                                    ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                                    : PrimaryButton(
                                  label: "Đăng nhập",
                                  onPressed: _handleLogin,
                                ),

                                const SizedBox(height: 16),

                                // Switch to Register
                                AuthSwitchWidget(
                                  questionText: "Bạn chưa có tài khoản?",
                                  buttonText: "Đăng ký",
                                  onPressed: () {
                                    controller.clearMessages();
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
          );
        },
      ),
    );
  }
}