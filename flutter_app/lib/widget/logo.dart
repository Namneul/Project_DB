import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomLogo extends StatelessWidget {
  final String title;

  const CustomLogo(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SvgPicture.asset(
          'assets/logo.svg', // assets 폴더에 로고 이미지 필요
          width: 70,
          height: 70,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}