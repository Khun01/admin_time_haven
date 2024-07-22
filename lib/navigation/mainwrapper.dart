import 'package:flutter/material.dart';
import 'package:time_haven/screens/HomeFavoriteCartProfilePage/favorite_page.dart';
import 'package:time_haven/screens/HomeFavoriteCartProfilePage/home_page.dart';

class Mainwrapper extends StatefulWidget {
  const Mainwrapper({super.key});

  @override
  State<Mainwrapper> createState() => _MainwrapperState();
}

class _MainwrapperState extends State<Mainwrapper> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            const HomePage(),
            const FavoritePage(),
            Container(color: Colors.blue),
            Container(color: Colors.green),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3)

            )
          ]
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color(0xFFE2B34B),
          unselectedItemColor: const Color(0xFFAFAFAF),
          unselectedLabelStyle: const TextStyle(
            color: Color(0xFFAFAFAF)
          ),
          selectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: selectedIndex == 0 ? const Icon(Icons.home) : const Icon(Icons.home_outlined)
            ),
            BottomNavigationBarItem(
              label: 'Favorite',
              icon: selectedIndex == 1 ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border)
            ),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: selectedIndex == 2 ? const Icon(Icons.shopping_cart) : const Icon(Icons.shopping_cart_outlined)
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: selectedIndex == 3 ? const Icon(Icons.person) : const Icon(Icons.person_outline)
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (int index){
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}