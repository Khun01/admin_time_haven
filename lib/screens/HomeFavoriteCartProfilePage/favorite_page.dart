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

  late List<Products> products = [];
  late List<Products> filteredProducts = [];
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

  void searchProducts(String query) async{
    setState(() {
      isLoading = true;
    });
    try{
     if(query.isEmpty){
      filteredProducts = products;
     }else{
      filteredProducts = products.where((product){
        final queryLower = query.toLowerCase();
        return product.name.toLowerCase().contains(queryLower) ||
               product.brand.toLowerCase().contains(queryLower);
      }).toList();
      logger.d('Search result found: ${filteredProducts.length} items');
      if(filteredProducts.isEmpty){
        logger.d('No results were found for query: $query');
      }
     }
    }catch(e){
      logger.d(e);
    }finally{
      setState(() {
        isLoading = false;
      });
    }
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
                searchProducts(query);
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
                itemCount: filteredProducts.length,
                itemBuilder: (context, index){
                  return ProductsFavorite(
                    product: filteredProducts[index],
                    image: '$baseUrl${filteredProducts[index].image1}', 
                    name: filteredProducts[index].name,
                    description: filteredProducts[index].description,
                    popularity: filteredProducts[index].popularity.toString(), 
                    price: filteredProducts[index].price.toString()
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