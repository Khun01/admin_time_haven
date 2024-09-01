import 'dart:convert';

import 'package:time_haven/models/products.dart';
import 'package:time_haven/models/comment.dart';
import 'package:time_haven/services/global.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:time_haven/services/shared_preferences.dart';

var logger = Logger();

class AuthServices{

  // ---------For Register, login and logout API----------//
  static Future<http.Response> register(String name, String email, String password) async{
    Map data = {
      'name': name,
      'email': email,
      'password': password,
    };
    var body = jsonEncode(data);
    var url = Uri.parse('$baseUrl/api/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    logger.d(response.body);
    return response;
  }

  static Future<http.Response> login(String email, String password) async{
    Map data = {
      'email': email,
      'password': password,
    };
    var body = jsonEncode(data);
    var url = Uri.parse('$baseUrl/api/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    logger.d(response.body);
    return response;
  }

  static Future<http.Response> logout(String token) async{
    Map data = {
      'token': token
    };
    var body = jsonEncode(data);
    var url = Uri.parse('$baseUrl/api/logout');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body
    );
    logger.d(response.body);
    return response;
  }


  // ---------For Products API----------//
  static Future<List<Products>> fetchProducts() async{
    String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/products');
    final response = await http.get(
      url, 
      headers: {
        ...headers,
        'Authorization': 'Bearer $token'
      }
    );
    List<dynamic> data = jsonDecode(response.body);
    List<Products> productList = [];

    for(var item in data){
      Products products = Products.fromJson(item);
      productList.add(products);
    }

    return productList;
  }

  // ---------For Favorites API----------//
  static Future<List<Products>> fetchFavorites(String userId) async{
    String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/favorites');
    final response = await http.get(
      url, 
      headers: {
        ...headers,
        'Authorization': 'Bearer $token'
      }
    );
    if(response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      if(responseBody is Map<String, dynamic> && responseBody.containsKey('message')){
        logger.d(responseBody['message']);
        return [];
      }else if(responseBody is List){
        List<Products> favoriteList =[];
        for(var item in responseBody){
          favoriteList.add(Products.fromJson(item));
        }
        return favoriteList;
      }else{
        logger.d('Unexpected format');
        return [];
      }
    }else{
      logger.d('Failed to fetch favorites: ${response.reasonPhrase}');
      return [];
    }
  }

  static Future<bool> addToFavorites(String productId) async{
    String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/favorites/$productId');
    final response = await http.post(
      url, 
      headers: {
        ...headers,
        'Authorization': 'Bearer $token'
      },
    );
    if(response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      if(responseBody is Map<String, dynamic> && responseBody.containsKey('message')){
         logger.d(responseBody['message']);
        return true;
      } else{
        logger.d('Unexpected error format');
        return false;
      }
    }else{
      logger.d('Failed to add to favorites: ${response.reasonPhrase}');
      return false;
    }
  }

  static Future<bool> removeFromFavorites(String productId) async{
    String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/favorites/$productId');
    final response = await http.delete(
      url, 
      headers: {
        ...headers,
        'Authorization': 'Bearer $token'
      },
    );
    if(response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      if(responseBody is Map<String, dynamic> && responseBody.containsKey('message')){
         logger.d(responseBody['message']);
        return true;
      } else{
        logger.d('Unexpected error format');
        return false;
      }
    }else{
      logger.d('Failed to remove from favorites: ${response.reasonPhrase}');
      return false;
    }
  }

  // ---------For Search API----------//
  static Future<List<Products>> searchProducts(String query) async {
    String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/products/search?query=$query');
    final response = await http.get(
      url,
      headers: {
        ...headers,
        'Authorization': 'Bearer $token'
      }
    );
    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Products.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load products');
    }
  }

  // ---------For Comments API----------//
  static Future<List<Comment>> fetchComments(int productId) async{
    String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/comments/$productId');
    final response = await http.get(
      url,
      headers:{
        ...headers,
        'Authorization': 'Bearer $token'
      }
    );
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      List<Comment> comment = jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
      logger.d('nakooo Fetched Comments: $comment');
      return comment;
    }else{
      throw Exception('Failed to load comments');
    }
  }

  static Future<void> storeComment(int productId, String comments) async{
     String? token = await SharedPreferencesUtil.getToken();
    var url = Uri.parse('$baseUrl/api/comments');
    final response = await http.post(
      url,
      headers:{
        ...headers,
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'product_id': productId,
        'comment_text': comments
      }),
    );
    if(response.statusCode == 200){
      logger.d('Comment Added: ${response.body}');
    }else{
      logger.d('Failed to add the comment: ${response.statusCode}, ${response.body}');
    }
  }
}