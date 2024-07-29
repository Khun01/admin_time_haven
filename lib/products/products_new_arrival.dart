import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/favorite_icon.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/shared_preferences.dart';

class ProductsNewArrival extends StatefulWidget {

  final Products products;
  final String image;
  final String name;
  final String description;
  final String price;

  const ProductsNewArrival({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.products,
  });

  @override
  State<ProductsNewArrival> createState() => _ProductsNewArrivalState();
}

class _ProductsNewArrivalState extends State<ProductsNewArrival> {
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
    if(userId == null){
      return const Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(7.5),
              width: 80,
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
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.image,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 7.5, bottom: 7.5, right: 7.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B3B3B),
                          ),
                        ),
                      ),
                      FavoriteIcon(products: widget.products, userId: userId.toString()),
                    ],
                  ),
                  const SizedBox(height: 2.5),
                  SizedBox(
                    width: 160,
                    child: Text(
                      widget.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        color: const Color(0xCC3B3B3B)
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.5),
                  Text(
                    '${widget.price} PHP',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: const Color(0x803B3B3B),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}