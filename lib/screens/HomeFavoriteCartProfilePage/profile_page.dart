import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/icon.dart';
import 'package:time_haven/components/profile_image.dart';
import 'package:time_haven/screens/LoginRegisterPage/landing_page.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/global.dart';
import 'package:time_haven/services/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? image;
  String? username;
  String? email;
  String? address;
  String? number;

  Future<void> loadUserData() async{
    String? userJson = await SharedPreferencesUtil.getUser();
    if(userJson != null){
      var userMap = jsonDecode(userJson);
      image = userMap['profile'];
      username = userMap['name'];
      email = userMap['email'];
      address = userMap['address'];
      number = userMap['phone_number'];
    }
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    loadUserData();
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
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if(shouldLogout == true){
      if(context.mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage())
        );
        toast(context, 'Logged out successfully');
        await SharedPreferencesUtil.removeToken();
        logger.d("Token Removed");
      } 
    }else{
      logger.d("Logging out unsuccessful");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Profile',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B3B3B)
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                ProfileImage(imagePath: image ?? 'assets/images/facebook.png'),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      username ?? 'Username is not Available',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B3B3B)
                      ),
                    ),
                    Text(
                      email ?? 'Email is not Available',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: const Color(0x803B3B3B)
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'ACCOUNT',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0x803B3B3B)
              ),
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                toast(
                  context, 
                  'Napindot na'
                );
              },
              icon: Icons.person,
              text1: 'Edit Profile',
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                
              },
              icon: Icons.location_on,
              text1: 'Address',
              text2: address ?? 'Add or remove you address',
              iconColor: const Color(0xFFEC8585),
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                
              },
              icon: Icons.payment,
              text1: 'Payment Method',
              text2: '3 cards are available',
              iconColor: const Color(0xFF85BBEC),
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                
              },
              icon: Icons.contacts,
              text1: 'Contact Number',
              text2: number ?? 'Put your contact number',
              iconColor: const Color(0xFF44CACA),
            ),
            const SizedBox(height: 25),
            Text(
              'SUPPORT',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0x803B3B3B)
              ),
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                
              },
              icon: Icons.phone,
              text1: 'Contact Us',
              iconColor: const Color(0xFF5C62EF),
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                
              },
              icon: Icons.menu_book,
              text1: 'Terms and Conditions',
              iconColor: const Color(0xFFCB9C33),
            ),
            const SizedBox(height: 25),
            Text(
              'SUPPORT',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0x803B3B3B)
              ),
            ),
            const SizedBox(height: 15),
            IconText(
              onTap: () {
                loggedOutUser(context);
              },
              icon: Icons.logout,
              text1: 'Logout',
              iconColor: const Color(0xFFF24E1E),
            ),
          ],
        ),
      ),
    );
  }
}