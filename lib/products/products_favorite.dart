import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsFavorite extends StatelessWidget {

  final String image;
  final String name;
  final String description;
  final String popularity;
  final String price;

  const ProductsFavorite({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.popularity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    double popularityValue = double.tryParse(popularity) ?? 0;
    return Container(
      padding: const EdgeInsets.all(7.5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0x333B3B3B)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0.0, 10.0),
            blurRadius: 10.0,
            spreadRadius: -6.0
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 120,
            width: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEDBE00),
                  Color(0xFFB8860B),
                  Color(0xFFEDBE00),
                  Color(0xFF9E7206),
                  Color(0XFFC59803),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
            ),
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B3B3B)
                  ),
                ),
                const SizedBox(height: 2.5),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: const Color(0xCC3B3B3B)
                  ),
                ),
                const SizedBox(height: 2.5),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index){
                        if(index < popularityValue.floor()){
                          return const Icon(Icons.star, color: Colors.yellow, size: 12);
                        }
                        return const Icon(Icons.star_outline, color: Colors.yellow, size: 12);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 2.5),
                Text(
                  '$price PHP',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0x803B3B3B)
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}