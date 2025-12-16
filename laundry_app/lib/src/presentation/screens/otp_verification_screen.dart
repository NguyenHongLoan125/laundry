import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/auth_controller.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/router/app_routes.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late final List<TextEditingController> otpControllers;
  late final List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
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

  String _getOTP() {
    return otpControllers.map((c) => c.text).join();
  }

  Future<void> _handleVerifyOTP(String email) async {
    final controller = context.read<AuthController>();
    final otp = _getOTP();

    if (otp.length != 6) {
      _showMessage('Vui lòng nhập đủ 6 chữ số', true);
      return;
    }

    final success = await controller.verifyOTP(email, otp);

    if (!mounted) return;

    if (success) {
      _showMessage(controller.successMessage ?? 'Xác thực thành công', false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      _showMessage(controller.errorMessage ?? 'Xác thực thất bại', true);
    }
  }

  Future<void> _handleResendOTP(String email) async {
    final controller = context.read<AuthController>();

    final success = await controller.resendOTP(email);

    if (!mounted) return;

    if (success) {
      _showMessage(controller.successMessage ?? 'Đã gửi lại mã OTP', false);
    } else {
      _showMessage(controller.errorMessage ?? 'Gửi lại OTP thất bại', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String? ?? '';

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
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 80,
                              bottom: 40,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: HeaderText(
                                title: 'Nhập mã xác minh',
                                message: 'Hãy điền mã xác thực gồm 6 chữ số vừa được gửi đến Email $email',
                              ),
                            ),
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
                                // OTP Input Fields
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(6, (index) {
                                    return SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: CustomTextField(
                                        controller: otpControllers[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          if (value.length == 1 && index < 5) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                          if (value.isEmpty && index > 0) {
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),

                                const SizedBox(height: 20),

                                // Resend OTP Button
                                TextButton(
                                  onPressed: () => _handleResendOTP(email),
                                  child: Text(
                                    'Gửi lại mã OTP? Còn 60 giây',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // Verify Button
                                controller.isLoading
                                    ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                                    : PrimaryButton(
                                  label: "Tiếp tục",
                                  onPressed: () => _handleVerifyOTP(email),
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