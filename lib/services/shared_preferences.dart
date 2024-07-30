import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil{
  static Future<void> saveUserData(Map<String, dynamic> user, String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user['id'].toString());
    await prefs.setString('name', user['name']);
    await prefs.setString('email', user['email']);
    await prefs.setString('profile', user['profile']?.toString() ?? '');
    await prefs.setString('address', user['address'].toString());
    await prefs.setString('phoneNumber', user['phone_number'].toString());
    await prefs.setString('token', token);
  }
  static Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
  static Future<String?> getUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }
  static Future<String?> getEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
  static Future<String?> getProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile');
  }
  static Future<String?> getAddress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('address');
  }
  static Future<String?> getPhoneNumber() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }
  static Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<void> clearAllData() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ------------- Add and remove for favorites ------------- //
  static Future<List<String>> getProductId(String userId) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'favoriteIds_$userId';
    final List<String>? favoriteIds = prefs.getStringList(key);
    return favoriteIds ?? [];
  }

  static Future<void> saveProduct(String userId, String productId) async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'favoriteIds_$userId';
    final List<String>? favoriteIds = prefs.getStringList(key);
    final List<String> updatedIds = [...?favoriteIds, productId.toString()];
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