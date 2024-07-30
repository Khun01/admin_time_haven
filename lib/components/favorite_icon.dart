import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/favorite_provider.dart';

class FavoriteIcon extends StatefulWidget {
  final Products product;
  final int iconSize;

  const FavoriteIcon({
    super.key,
    required this.product,
    this.iconSize = 16
  });

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    var favoriteProviders = Provider.of<FavoriteProvider>(context);
    bool isFavorite = favoriteProviders.isFavorite(widget.product.id.toString());
    return GestureDetector(
      onTap: () async{
        if(isFavorite){
          await AuthServices.removeFromFavorites(widget.product.id.toString());
          favoriteProviders.removeFavorites(widget.product.id.toString());
        }else{
          await AuthServices.addToFavorites(widget.product.id.toString());
          favoriteProviders.addFavorites(widget.product);
        }
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_outline,
        color: const Color(0xFFE2B34B),
        size: widget.iconSize.toDouble(),
      ),
    );
  }
}