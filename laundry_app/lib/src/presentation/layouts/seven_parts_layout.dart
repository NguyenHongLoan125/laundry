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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            part1,
            part2,
            part3,
            part4,
            part5,
            part6,
            part7,
          ],
        ),
      ),
    );
  }
}
