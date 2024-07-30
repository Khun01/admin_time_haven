import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/profile_image.dart';
import 'package:time_haven/components/search_bar.dart';
import 'package:time_haven/services/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String username = '';

  @override
  void initState(){
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async{
    final fetchedUername = await SharedPreferencesUtil.getUsername();
    setState(() {
      username = fetchedUername ?? 'Username';
    });
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
                  username.toString(),
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
              'Cart',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B3B3B)
              ),
            ),
            
          ],
        ),
      )
    );
  }
}