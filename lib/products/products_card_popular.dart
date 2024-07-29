import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsCardPopular extends StatelessWidget {

  final String image1;
  final String brand;
  final String name;
  final String popularity;
  final String price;

  const ProductsCardPopular({
    super.key,
    required this.image1,
    required this.brand,
    required this.name,
    required this.popularity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    double popularityValue = double.tryParse(popularity) ?? 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      width: MediaQuery.of(context).size.width,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0.0, 10.0),
            blurRadius: 10.0,
            spreadRadius: -6.0
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF4F4F4)
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xCCF4F4F4)
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index){
                            if(index < popularityValue.floor()){
                              return const Icon(Icons.star, color: Colors.yellow, size: 15);
                            }
                            return const Icon(Icons.star_outline, color: Colors.yellow, size: 15);
                          }),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '($popularity)',
                          style: GoogleFonts.nunito(
                            color: const Color(0xCCF4F4F4),
                            fontWeight: FontWeight.w700,
                            fontSize: 10
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$price PHP',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xCCF4F4F4)
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(10),
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image1),
                    fit: BoxFit.contain,
                  )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}