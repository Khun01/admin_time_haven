import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/favorite_icon.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/shared_preferences.dart';

class ProductsFavorite extends StatefulWidget {

  final Products product;
  final String image;
  final String name;
  final String description;
  final String popularity;
  final String price;

  const ProductsFavorite({
    super.key,
    required this.product,
    required this.image,
    required this.name,
    required this.description,
    required this.popularity,
    required this.price,
  });

  @override
  State<ProductsFavorite> createState() => _ProductsFavoriteState();
}

class _ProductsFavoriteState extends State<ProductsFavorite> {

  int? userId;

  @override
  void initState(){
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async{
    String? userJson = await SharedPreferencesUtil.getUser();
    try{
      if(userJson != null){
        var userMap = jsonDecode(userJson);
        setState(() {
          userId = userMap['id'];
        });
        logger.d('User is this: $userId');
      }
    }catch(e){
      logger.e('Failed to load user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double popularityValue = double.tryParse(widget.popularity) ?? 0;
    if(userId == null){
      return const Center(child: CircularProgressIndicator());
    }
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
              widget.image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3B3B3B)
                        ),
                      ),
                    ),
                    FavoriteIcon(products: widget.product, iconSize: 20, userId: userId.toString()),
                  ],
                ),
                const SizedBox(height: 2.5),
                Text(
                  widget.description,
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
                  '${widget.price} PHP',
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