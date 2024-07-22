import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:time_haven/products/products_card_popular.dart';
import 'package:time_haven/products/products_card_product.dart';
import 'package:time_haven/products/products_new_arrival.dart';
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

  final PageController pageController = PageController();
  int activePage = 0;

  late List<Products> products = [];
  bool isLoading = true;

  String? username;

  @override
  void initState(){
    super.initState();
    loadUserData();
    getProducts();
    infinite();
  }

  Future<void> infinite() async{
    WidgetsBinding.instance.addPostFrameCallback((_){  
      if(products.isNotEmpty){
        final initialPage = products.length * 1000;
        pageController.jumpToPage(initialPage);
      }
    });
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

  Future<bool> onWillPop(BuildContext context) async{
    return (await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Do you want to quit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      )
    )) ?? false;
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: SearchBarWidget(
                    onSearch: (query){
                          
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: Row(
                    children: [
                      Text(
                        'Popular',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3B3B3B)
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See all',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE2B34B)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: isLoading ? const Center(child: CircularProgressIndicator()):
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 160,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: null,
                          itemBuilder: (context, index){
                            final productIndex = index % products.length;
                            final product = products[productIndex];
                            return ProductsCard(
                              image1: '$baseUrl${product.image1}', 
                              brand: product.brand, 
                              name: product.name,
                              popularity: product.popularity.toString(), 
                              price: product.price.toString()
                            );
                          }
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: pageController, 
                        count: products.isNotEmpty ? (products.length > 5 ? 5 : products.length) : 1,
                        effect: const WormEffect(
                          activeDotColor: Color(0xFF3B3B3B),
                          dotHeight: 7,
                          dotWidth: 7,
                        ),
                      ),
                    ],
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: Row(
                    children: [
                      Text(
                        'Products',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3B3B3B)
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See all',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE2B34B)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 215,
                    child: Container(
                      child: isLoading ? const Center(child: CircularProgressIndicator()) :
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: () async{
                              
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                              width: 150,
                              child: ProductsCardProduct(
                                products: products[index],
                                image: '$baseUrl${products[index].image1}',
                                brand: products[index].brand,
                                name: products[index].name,
                                popularity: products[index].popularity.toString(),
                                price: products[index].price.toString(),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'New Arrival',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3B3B3B)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 120,
                    child: Container(
                      child: isLoading ? const Center(child: CircularProgressIndicator()) :
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index){
                          return Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 15),
                            width: 290,
                            child: ProductsNewArrival(
                              products: products[index],
                              image: '$baseUrl${products[index].image1}',
                              name: products[index].name,
                              description: products[index].description,
                              price: products[index].price.toString(),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}