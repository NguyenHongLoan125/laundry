import 'package:flutter/material.dart';

class SevenPartsLayout extends StatelessWidget {
  final Widget part1;
  final Widget part2;
  final Widget part3;
  final Widget part4;
  final Widget part5;
  final Widget part6;
  final Widget part7;

  const SevenPartsLayout({super.key,
    required this.part1,
    required this.part2,
    required this.part3,
    required this.part4,
    required this.part5,
    required this.part6,
    required this.part7
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            part1,
            const SizedBox(height: 20,),
            part2,
            const SizedBox(height: 20,),
            part3,
            const SizedBox(height: 20,),
            part4,
            const SizedBox(height: 20,),
            part5,
            const SizedBox(height: 20,),
            part6,
            const SizedBox(height: 20,),
            part7,
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
