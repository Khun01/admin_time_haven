import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:time_haven/components/icon.dart';
import 'package:time_haven/components/profile_image.dart';
import 'package:time_haven/screens/FirstPage/landing_page.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/favorite_provider.dart';
import 'package:time_haven/services/global.dart';
import 'package:time_haven/services/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? normalizeValue(String? value){
    return (value == null || value == 'null') ? null : value;
  }
  
  void loggedOutUser(BuildContext context) async{
    String token = SharedPreferencesUtil.getToken().toString();
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
        await SharedPreferencesUtil.clearAllData();
        await AuthServices.logout(token);
        // ignore: use_build_context_synchronously
        Provider.of<FavoriteProvider>(context, listen: false).clearFavorites();
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
      body: FutureBuilder(
        future: Future.wait([
          SharedPreferencesUtil.getUsername(),
          SharedPreferencesUtil.getEmail(),
          SharedPreferencesUtil.getAddress(),
          SharedPreferencesUtil.getPhoneNumber(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData){
            final data = snapshot.data!;
            final username = data[0] as String?;
            final email = data[1] as String?;
            final address = normalizeValue(data[2] as String?);
            final phoneNumber = normalizeValue(data[3] as String?);

            if(address == 'null'){
              
            }

            logger.d('The address and number is: $address, $phoneNumber');

            return Container(
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
                      const ProfileImage(imagePath: 'assets/images/facebook.png'),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            username ?? 'Username',
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3B3B3B)
                            ),
                          ),
                          Text(
                            email ?? 'Email',
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
                    text2: address ?? 'Add or remove Address',
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
                    text2: phoneNumber ?? 'Add or remove your Contact Number',
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
            );
          }else{
            return const Center(child: Text('No data available'));
          }
        }
      ),
    );
  }
}