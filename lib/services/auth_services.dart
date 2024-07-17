import 'dart:convert';

import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/global.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:time_haven/services/shared_preferences.dart';

var logger = Logger();

class AuthServices{
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
      productList.add(Products.fromJson(item));
    }

    return productList;
  }
}