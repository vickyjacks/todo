import 'package:flutter/material.dart';

double screenHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}

class HeightGap extends StatelessWidget {
  const HeightGap({super.key, required this.gap});
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.sizeOf(context).height * gap);
  }
}

class WidthGap extends StatelessWidget {
  const WidthGap({super.key, required this.gap});
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.sizeOf(context).width * gap);
  }
}
