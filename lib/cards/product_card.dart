import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/favorite_icon.dart';
import 'package:time_haven/models/products.dart';
class ProductsCardProduct extends StatefulWidget {

  final Products products;
  final String image;
  final String brand;
  final String name;
  final String popularity;
  final String price;

  const ProductsCardProduct({
    super.key,
    required this.products,
    required this.image,
    required this.brand,
    required this.name,
    required this.popularity,
    required this.price,
  });

  @override
  State<ProductsCardProduct> createState() => _ProductsCardProductState();
}

class _ProductsCardProductState extends State<ProductsCardProduct> {
  @override
  Widget build(BuildContext context) {
    double popularityValue = double.tryParse(widget.popularity) ?? 0;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFF4F4F4),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(7.5),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
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
                ),
                Container(
                  margin: const EdgeInsets.only(left: 7.5, right: 7.5, bottom: 7.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.brand,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3B3B3B)
                            ),
                          ),
                          const Spacer(),
                          FavoriteIcon(
                            product: widget.products, 
                          ),
                        ],
                      ),
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0x803B3B3B)
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index){
                          if(index < popularityValue.floor()){
                            return const Icon(Icons.star, color: Color(0xFFFFD872), size: 12);
                          }
                          return const Icon(Icons.star_outline, color: Color(0xFFFFD872), size: 12);
                        }),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${widget.price} PHP',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0x803B3B3B)
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Image.network(
              widget.image,
              fit: BoxFit.contain,
              height: 120,
            )
          )
        ],
      ),
    );
  }
}