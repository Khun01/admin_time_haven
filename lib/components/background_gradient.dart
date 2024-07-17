import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackgroundGradient extends StatelessWidget {

  final String brand;
  final String name;
  final double price;

  const BackgroundGradient({super.key, required this.brand, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB8860B),
                    Color(0xFFEDBE00),
                    Color(0xFF9E7206),
                    Color(0xFFEDBE00),
                    Color(0XFFC59803)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brand,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF4F4F4)
                        ),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xCCF4F4F4)
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xCCF4F4F4)
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}