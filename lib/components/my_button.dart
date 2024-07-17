import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget{

  final Function()? onTap;
  final String buttonText;

  const MyButton({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
          color: const Color(0xFF3B3B3B),
          borderRadius: BorderRadius.circular(12.0)
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.nunito(
              color: const Color(0xFFF4F4F4),
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}