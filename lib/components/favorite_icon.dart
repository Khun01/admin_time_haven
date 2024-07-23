import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/shared_preferences.dart';

class FavoriteIcon extends StatefulWidget {

  final Products products;
  final int iconSize;
  final String? userId;

  const FavoriteIcon({
    super.key,
    required this.products,
    this.iconSize = 14,
    required this.userId,
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorite = false;

  @override
  void initState(){
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async{
    if (widget.userId == null || widget.userId!.isEmpty) {
      logger.d('User ID is null, cannot check favorite status');
      return;
    }
    try {
      List<int> favoriteIds = await SharedPreferencesUtil.getProductId(widget.userId!);
      setState(() {
        isFavorite = favoriteIds.contains(int.parse(widget.products.id.toString()));
      });
      logger.d('User ${widget.userId} - Product ${widget.products.id} isFavorite: $isFavorite');
    }catch(e){
      logger.d('Error cehcking if favorite: $e');
    }
  }

  Future<void> toggleFavorites() async{
    if(isFavorite){
      bool result = await AuthServices.removeFromFavorites(widget.products.id.toString());
      if(result){
        await SharedPreferencesUtil.removeProducts(widget.userId!, widget.products.id.toString());
        setState(() {
          isFavorite = false;
        });
      }else{
        logger.d('Failed to remove from favorites');
      }
    }else{
      bool result = await AuthServices.addToFavorites(widget.products.id.toString());
      if(result){
        await SharedPreferencesUtil.saveProduct(widget.userId!, widget.products);
        setState(() {
          isFavorite = true;
        });
      }else{
        logger.d('Failed to add products to favorites');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleFavorites,
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_outline,
        color: const Color(0xFFE2B34B),
        size: widget.iconSize.toDouble(),
      ),
    );
  }
}