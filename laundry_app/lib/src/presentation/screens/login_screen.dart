import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import 'package:laundry_app/src/presentation/widgets/auth_switch_widget.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/router/app_routes.dart';

import '../controllers/home_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Biến để hiển thị lỗi từ backend
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, bool isError) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Validate email - GIỐNG BACKEND
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email bắt buộc phải có!';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email sai định dạng!';
    }
    return null;
  }

  // Validate password - GIỐNG BACKEND
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu bắt buộc phải có!';
    }
    return null;
  }

// Chỉ cần sửa hàm _handleLogin() trong login_screen.dart

  Future<void> _handleLogin() async {
    print('🔵 === BẮT ĐẦU LOGIN ===');

    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    final controller = context.read<AuthController>();

    try {
      final success = await controller.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        print('✅ Login thành công');

        // ✅ QUAN TRỌNG: Reset và reload HomeController
        final homeController = Provider.of<HomeController>(
          context,
          listen: false,
        );

        print('🔄 Resetting HomeController...');
        homeController.clearAllData();

        // Đợi một chút để đảm bảo data đã được clear
        await Future.delayed(Duration(milliseconds: 300));

        if (!mounted) return;

        // Navigate đến main screen
        Navigator.pushReplacementNamed(context, AppRoutes.mainApp);

        // Sau khi navigate, reload data mới
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('🔄 Reloading HomeController data...');
          homeController.reloadAllData();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng nhập thành công'),
              backgroundColor: Colors.green,
            ),
          );
        });
      } else {
        print('❌ Login failed');
        final errorMessage = controller.errorMessage ?? 'Đăng nhập thất bại';
        _showMessage(errorMessage, true);

        setState(() {
          final lowerError = errorMessage.toLowerCase();
          if (lowerError.contains('email')) {
            emailError = errorMessage;
            passwordError = null;
          } else if (lowerError.contains('mật khẩu') ||
              lowerError.contains('mat khau') ||
              lowerError.contains('password')) {
            passwordError = errorMessage;
            emailError = null;
          } else {
            emailError = null;
            passwordError = null;
          }
        });
      }
    } catch (e, stackTrace) {
      print('❌ Exception during login: $e');
      print('📚 Stack trace: $stackTrace');

      if (mounted) {
        _showMessage('Lỗi không xác định: $e', true);
      }
    }

    print('🔵 === KẾT THÚC LOGIN ===');
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
                    child: Form(
                      key: _formKey,
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
                              message: 'Đăng nhập để trải nghiệm những điều tuyệt vời với chúng tôi',
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
                                    validator: _validateEmail,
                                    errorText: emailError,
                                    onChanged: (value) {
                                      if (emailError != null) {
                                        setState(() {
                                          emailError = null;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Password Field
                                  CustomTextField(
                                    controller: passwordController,
                                    label: 'Mật khẩu',
                                    icon: Icons.lock_rounded,
                                    obscureText: true,
                                    validator: _validatePassword,
                                    errorText: passwordError,
                                    onChanged: (value) {
                                      if (passwordError != null) {
                                        setState(() {
                                          passwordError = null;
                                        });
                                      }
                                    },
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}