import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/products_card_popular.dart';
import 'package:time_haven/components/profile_image.dart';
import 'package:time_haven/components/search_bar.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/screens/LoginRegisterPage/landing_page.dart';
import 'package:time_haven/services/global.dart';
import 'package:time_haven/services/shared_preferences.dart';
import 'package:time_haven/services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<Products> products;
  bool isLoading = true;
  String? username;

  @override
  void initState(){
    super.initState();
    loadUserData();
    getProducts();
  }

  Future<void> getProducts() async{
    products = await AuthServices.fetchProducts();
    setState(() {
      isLoading = false;
    });
    logger.d(products);
  }

  Future<void> loadUserData() async{
    String? userJson = await SharedPreferencesUtil.getUser();
    if(userJson != null){
      var userMap = jsonDecode(userJson);
      username = userMap['name'];
    }
    setState(() {});
  }

  void loggedOutUser(BuildContext context) async{
    final shouldLogout = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('No')
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if(shouldLogout == true){
      if(context.mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        ); 
        toast(context, 'Logged out successfully');
        await SharedPreferencesUtil.removeToken();
      } 
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ProfileImage(imagePath: 'assets/images/facebook.png'),
              const SizedBox(width: 10),
              Text(
                '$username',
                style: GoogleFonts.nunito(
                  fontSize: 25,
                  fontWeight: FontWeight.w800
                ),
              ),
              const Spacer(),
              const Icon(Icons.notifications, size: 40)
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            SearchBarWidget(
              onSearch: (query){

              } 
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B3B3B)
                  ),
                ),
                Text(
                  'See all',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE2B34B)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            isLoading ? const Center(child: CircularProgressIndicator())
            :Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return ProductsCard(
                    image1: '$baseUrl${products[index].image1}', 
                    brand: products[index].brand, 
                    name: products[index].name, 
                    popularity: products[index].popularity.toString(), 
                    price: products[index].price.toString(), 
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}