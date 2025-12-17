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
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Biến lưu lỗi từ backend
  String? fullNameError;
  String? emailError;
  String? phoneError;
  String? passwordError;

  @override
  void dispose() {
    fullNameController.dispose();
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
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Validate họ tên - GIỐNG BACKEND (min 5, max 50)
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên bắt buộc phải có!';
    }
    if (value.length < 5) {
      return 'Tên phải có ít nhất 5 ký tự!';
    }
    if (value.length > 50) {
      return 'Tên chỉ chứa dài nhất 50 ký tự!';
    }
    return null;
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

  // Validate phone - GIỐNG BACKEND
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại bắt buộc phải có!';
    }
    // Kiểm tra số điện thoại Việt Nam (10-11 số)
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ!';
    }
    return null;
  }

  // Validate password - GIỐNG BACKEND
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu bắt buộc phải có!';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự!';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    // Validate form trước khi gửi
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = context.read<AuthController>();

    final success = await controller.register(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showMessage(controller.successMessage ?? 'Đăng ký thành công', false);

      // Show OTP trong development mode
      if (controller.currentOTP != null) {
        _showMessage('OTP: ${controller.currentOTP}', false);
      }

      // Chuyển sang màn hình OTP
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.auth,
        arguments: emailController.text.trim(),
      );
    } else {
      // Hiển thị lỗi từ backend
      final errorMessage = controller.errorMessage ?? 'Đăng ký thất bại';
      _showMessage(errorMessage, true);

      // Map lỗi vào field tương ứng
      setState(() {
        // Reset tất cả lỗi
        fullNameError = null;
        emailError = null;
        phoneError = null;
        passwordError = null;

        // Phân loại lỗi theo keyword
        final lowerError = errorMessage.toLowerCase();
        if (lowerError.contains('ten') || lowerError.contains('tên') ||
            lowerError.contains('name')) {
          fullNameError = errorMessage;
        } else if (lowerError.contains('email')) {
          emailError = errorMessage;
        } else if (lowerError.contains('phone') ||
            lowerError.contains('điện thoại') ||
            lowerError.contains('dien thoai')) {
          phoneError = errorMessage;
        } else if (lowerError.contains('password') ||
            lowerError.contains('mật khẩu') ||
            lowerError.contains('mat khau')) {
          passwordError = errorMessage;
        }
      });
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
                                  // Full Name Field - VALIDATE REAL-TIME
                                  CustomTextField(
                                    controller: fullNameController,
                                    label: 'Họ và tên',
                                    icon: Icons.person_rounded,
                                    validator: _validateFullName,
                                    errorText: fullNameError,
                                    onChanged: (value) {
                                      if (fullNameError != null) {
                                        setState(() {
                                          fullNameError = null;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Email Field - VALIDATE REAL-TIME
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

                                  // Phone Field - VALIDATE REAL-TIME
                                  CustomTextField(
                                    controller: phoneController,
                                    label: 'Số điện thoại',
                                    icon: Icons.phone_rounded,
                                    keyboardType: TextInputType.phone,
                                    validator: _validatePhone,
                                    errorText: phoneError,
                                    onChanged: (value) {
                                      if (phoneError != null) {
                                        setState(() {
                                          phoneError = null;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Password Field - VALIDATE REAL-TIME
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}