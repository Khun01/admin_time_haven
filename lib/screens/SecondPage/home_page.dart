import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:time_haven/screens/ThirdPage/product_details.dart';
import 'package:time_haven/cards/popular_card.dart';
import 'package:time_haven/cards/product_card.dart';
import 'package:time_haven/cards/new_arrival_card.dart';
import 'package:time_haven/components/profile_image.dart';
import 'package:time_haven/components/search_bar.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/screens/ThirdPage/notification_page.dart';
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
  List<Products> products = [];
  bool isLoading = true;

  String username = '';

  @override
  void initState(){
    super.initState();
    getProducts();
    infinite();
    loadUserData();
  }

  Future<void> loadUserData() async{
    final fetchedUername = await SharedPreferencesUtil.getUsername();
    setState(() {
      username = fetchedUername ?? 'Username';
    });
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

  void searchProducts(String query) async{
    setState(() {
      isLoading = true;
    });
    try{
      List<Products> product = await AuthServices.searchProducts(query);
      if(product.isNotEmpty){
        logger.d('Search Result found: ${product.length} items');
      }else{
        logger.d('No results were found');
      }
       setState(() {
        products = product;
      });
    }catch(e){
      logger.d(e);
    }finally{
      setState(() {
        isLoading = false;
      });
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
    final popularProduct = products.where((product) => product.popularity >= 4.5).toList();
    final newArrivalProduct = products.where((product) => product.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () => onWillPop(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    const ProfileImage(imagePath: 'assets/images/facebook.png'),
                    const SizedBox(width: 25),
                    Text(
                      username.toString(),
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B3B3B)
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const NotificationPage())
                          );
                        },
                        child: const Icon(
                          Icons.notifications, size: 35
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                child: SearchBarWidget(
                  onSearch: (query){
                    searchProducts(query);
                  }
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
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
                child: isLoading ? const Center(child: CircularProgressIndicator()) :
                Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: products.where((product) => product.popularity >= 4.5).length,
                        itemBuilder: (context, index){
                          final product = popularProduct[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    product: products[index],
                                    image1: '$baseUrl${product.image1}',
                                    image2: '$baseUrl${product.image2}',
                                    image3: '$baseUrl${product.image3}',
                                    image4: '$baseUrl${product.image4}',
                                    image5: '$baseUrl${product.image5}',
                                    brand: product.brand,
                                    name: product.name,
                                    popularity: product.popularity,
                                    price: product.price,
                                    description: product.description,
                                  )
                                )
                              );
                            },
                            child: ProductsCardPopular(
                              image1: '$baseUrl${product.image1}', 
                              brand: product.brand, 
                              name: product.name, 
                              popularity: product.popularity.toString(), 
                              price: product.price.toString(), 
                            ),
                          );
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: pageController, 
                      count: products.where((product) => product.popularity >= 4.5).length,
                      effect: const WormEffect(
                        activeDotColor: Color(0xFF3B3B3B),
                        dotHeight: 7,
                        dotWidth: 7,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
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
                  height: 225,
                  child: Container(
                    child: isLoading ? const Center(child: CircularProgressIndicator()) :
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  product: products[index],
                                  image1: '$baseUrl${products[index].image1}',
                                  image2: '$baseUrl${products[index].image2}',
                                  image3: '$baseUrl${products[index].image3}',
                                  image4: '$baseUrl${products[index].image4}',
                                  image5: '$baseUrl${products[index].image5}',
                                  brand: products[index].brand,
                                  name: products[index].name,
                                  popularity: products[index].popularity,
                                  price: products[index].price,
                                  description: products[index].description,
                                )
                              )
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
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
                  height: 130,
                  child: isLoading ? const Center(child: CircularProgressIndicator()) :
                  newArrivalProduct.isEmpty ? Center(child: Text('Coming Soon', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF3B3B3B)))):
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newArrivalProduct.length,
                    itemBuilder: (context, index){
                      final product = newArrivalProduct[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                product: product,
                                image1: '$baseUrl${product.image1}',
                                image2: '$baseUrl${product.image2}',
                                image3: '$baseUrl${product.image3}',
                                image4: '$baseUrl${product.image4}',
                                image5: '$baseUrl${product.image5}',
                                brand: product.brand,
                                name: product.name,
                                popularity: product.popularity,
                                price: product.price,
                                description: product.description,
                              )
                            )
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 15),
                          width: 291,
                          child: ProductsNewArrival(
                            product: product,
                            image: '$baseUrl${product.image1}',
                            name: product.name,
                            description: product.description,
                            price: product.price.toString(),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}