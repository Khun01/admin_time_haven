import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {

  final String imagePath;

  const ProfileImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x803B3B3B)),
        borderRadius: BorderRadius.circular(100)
      ),
      child: Image.asset(imagePath, height: 40),
    );
  }
}