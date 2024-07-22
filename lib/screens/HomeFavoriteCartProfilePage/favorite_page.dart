import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/profile_image.dart';
import 'package:time_haven/components/search_bar.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/products/products_favorite.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/global.dart';
import 'package:time_haven/services/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  final PageController pageController = PageController();
  int activePage = 0;

  late List<Products> products = [];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    loadUserData();
    getProducts();
  }

  String? username;

  Future<void> getProducts() async{
    products = await AuthServices.fetchFavorites();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadUserData() async{
    String? userJson = await SharedPreferencesUtil.getUser();
    if(userJson != null){
      var userMap = jsonDecode(userJson);
      username = userMap['name'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ProfileImage(imagePath: 'assets/images/facebook.png'),
                const SizedBox(width: 25),
                Text(
                  '$username',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B3B3B)
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.notifications, size: 35),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SearchBarWidget(
              onSearch: (query){
                    
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Favorites',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B3B3B)
              ),
            ),
            Expanded(
              child: isLoading ? const Center(child: CircularProgressIndicator()) : 
              products.isEmpty ? 
              Center(
                child: Text(
                  "You currently don't have favorites",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3B3B3B)
                  ),
                )
              ) :
              ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return ProductsFavorite(
                    image: '$baseUrl${products[index].image1}', 
                    name: products[index].name,
                    description: products[index].description,
                    popularity: products[index].popularity.toString(), 
                    price: products[index].price.toString()
                  );
                },
              ), 
            )
          ],
        ),
      )
    );
  }
}