import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class HeaderText extends StatelessWidget {
  final String title;
  final String message;

  const HeaderText({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title outline text
        Stack(
          children: [
            Text(
              title,
              style: GoogleFonts.pacifico(
                fontSize: 48,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = AppColors.primary,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.pacifico(
                fontSize: 48,
                color: AppColors.backgroundSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Sub message
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.pacifico(
            fontSize: 15,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
