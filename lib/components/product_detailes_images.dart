import 'package:flutter/material.dart';

class ProductDetailesImages extends StatelessWidget {
  final VoidCallback onTap;
  final String imageurl;
  const ProductDetailesImages({
    super.key,
    required this.imageurl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFAFAFAF),
          borderRadius: BorderRadius.circular(8),                    
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageurl,
            height: 45,
            width: 45,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}