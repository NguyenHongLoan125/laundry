import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class AuthSwitchWidget extends StatelessWidget {
  final String questionText;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthSwitchWidget({
    super.key,
    required this.questionText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
