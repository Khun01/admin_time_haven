import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';

class SharedPreferencesUtil{
  static Future<void> saveUserData(String user, String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
    await prefs.setString('token', token);
  }
  static Future<String?> getUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }
  static Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<void> removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // static Future<void> saveProduct(Products product) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favoriteProducts = prefs.getStringList('product_products') ?? [];

  //   String productJson = jsonEncode({
  //     'id': product.id.toString(),
  //     'image1': product.image1,
  //     'image2': product.image2,
  //     'image3': product.image3,
  //     'image4': product.image4,
  //     'image5': product.image5,
  //     'brand': product.brand,
  //     'name': product.name,
  //     'popularity': product.popularity,
  //     'price': product.price,
  //     'description': product.description,
  //   });

  //   if(!favoriteProducts.contains(productJson)){
  //     favoriteProducts.add(productJson);
  //     await prefs.setStringList('product_products', favoriteProducts);
  //   }
  // }

  // static Future<List<int>> getProductId() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favoriteProducts = prefs.getStringList('product_products') ?? [];

  //   List<int> productsIds = [];
  //   for(String productJson in favoriteProducts){
  //     try{
  //       final Map<String, dynamic> jsonData = jsonDecode(productJson);
  //       if(jsonData.containsKey('id') && jsonData['id'] is String){
  //         productsIds.add(int.parse(jsonData['id']));
  //       }else{
  //         logger.d('Invalid ID: $productJson');
  //       }
  //     }catch(e){
  //       logger.d('Error decodeing JSON: $e');
  //     }
  //   }
  //   return productsIds;
  // }

  // static Future<void> removeProducts(String productId) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> favoriteProducts = prefs.getStringList('product_products') ?? [];

  //   List<String> updatedProducts = [];

  //   for(String productJson in favoriteProducts){
  //     try{
  //       final dynamic jsonData = jsonDecode(productJson);
  //       if(jsonData is Map<String, dynamic> && jsonData['id'] != productId){
  //         updatedProducts.add(productJson);
  //       }
  //     }catch(e){
  //       logger.d('Error parsing JSON: $e');
  //     }
  //   }
  //   await prefs.setStringList('product_products', updatedProducts);
  // }

  static Future<List<int>> getProductId(String userId) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'favoriteIds_$userId';
    final List<String>? favoriteIds = prefs.getStringList(key);
    return favoriteIds?.map(int.parse).toList() ?? [];
  }

  static Future<void> saveProduct(String userId, Products product) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'favoriteIds_$userId';
    final List<String>? favoriteIds = prefs.getStringList(key);
    final List<String> updatedIds = [...?favoriteIds, product.id.toString()];
    await prefs.setStringList(key, updatedIds);
  }

  static Future<void> removeProducts(String userId, String productId) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'favoriteIds_$userId';
    final List<String>? favoriteIds = prefs.getStringList(key);
    final updatedIds = favoriteIds?.where((id) => id != productId).toList() ?? [];
    await prefs.setStringList(key, updatedIds);
  }
}