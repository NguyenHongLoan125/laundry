import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/header_text.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';
import 'package:laundry_app/src/presentation/widgets/text_field.dart';
import 'package:laundry_app/src/router/app_routes.dart';
import '../../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final List<TextEditingController> otpControllers;

  @override
  void initState() {
    super.initState();
    // Khởi tạo 6 controller cho OTP
    otpControllers = List.generate(6, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Giải phóng controller khi widget bị destroy
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String?;

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
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 80, bottom: 40),
                      child: HeaderText(
                        title: 'Nhập mã xác minh',
                        message: "Hãy điền mã xác thực gồm 6 chữ số vừa được gửi đến Email $email",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                  return SizedBox(
                                    width:   48,
                                    height:   48,
                                    child: CustomTextField(
                                      controller: otpControllers[index],
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                          // Tự focus ô tiếp theo khi nhập
                                          if (value.length == 1 && index < 5) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                          // Optional: focus ô trước nếu xoá
                                          if (value.isEmpty && index > 0) {
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                    ),
                                  );
                                }
                              ),
                            ),
                            const SizedBox(height: 40),

                            PrimaryButton(
                              label: "Tạo tài khoản",
                              onPressed: () {
                               // Lấy OTP
                               //  String otp = otpControllers.map((c) => c.text).join();
                               //  print("OTP nhập: $otp");

                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.home);
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
