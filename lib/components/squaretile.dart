import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget{
  final String imagePath;
  const SquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 170, 168, 168)),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Image.asset(imagePath, height: 35),
    );
  }
}