import 'package:flutter/material.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier{
  List<Products> _favoriteProduct = [];

  FavoriteProvider(){
    loadFavorites();
  }

  Future<void> loadFavorites() async{
    final userId = await SharedPreferencesUtil.getUserId();
    if(userId != null){
      _favoriteProduct = await AuthServices.fetchFavorites(userId);
      logger.d('The user Id is $userId');
      notifyListeners();
    }else{
      logger.d('User ID is null, cannot load favorites');
    }
  }

  List<Products> get favoriteProducts => _favoriteProduct;

  void setFavorites(List<Products> products){
    _favoriteProduct = products;
    notifyListeners();
  }

  void addFavorites(Products products){
    if(!_favoriteProduct.contains(products)){
      _favoriteProduct.add(products);
      notifyListeners();
    }
  }

  void removeFavorites(String productId){
    _favoriteProduct.removeWhere((product) => product.id.toString() == productId);
    notifyListeners();
  }
  
  void clearFavorites(){
    _favoriteProduct = [];
    notifyListeners();
  }

  void updateFavorites() async{
    await loadFavorites();
  }

  bool isFavorite(String productId){
    return _favoriteProduct.any((product) => product.id.toString() == productId);
  }
}