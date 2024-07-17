import 'package:shared_preferences/shared_preferences.dart';

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
}