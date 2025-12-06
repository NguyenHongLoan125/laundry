import 'package:flutter/material.dart';

class SevenPartsLayout extends StatelessWidget {
  final Widget part1;
  final Widget part2;
  final Widget part3;
  final Widget part4;
  final Widget part5;
  final Widget part6;
  final Widget part7;

  const SevenPartsLayout({
    super.key,
    required this.part1,
    required this.part2,
    required this.part3,
    required this.part4,
    required this.part5,
    required this.part6,
    required this.part7,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacingLarge = size.height * 0.04;
    final spacingMedium = size.height * 0.025;
    final spacingSmall = size.height * 0.015;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            part1,
            SizedBox(height: spacingLarge),

            part2,
            SizedBox(height: spacingMedium),

            part3,
            SizedBox(height: spacingSmall),

            part4,
            SizedBox(height: spacingMedium),

            part5,
            SizedBox(height: spacingMedium),

            part6,
            SizedBox(height: spacingMedium),

            part7,
            SizedBox(height: spacingMedium),
          ],
        ),
      ),
    );
  }
}
