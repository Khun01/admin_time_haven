import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_haven/models/products.dart';

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

  // ------------- Add and remove for favorites ------------- //
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