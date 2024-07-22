import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:time_haven/navigation/mainwrapper.dart';
import 'package:time_haven/screens/LoginRegisterPage/login_page.dart';
import 'package:time_haven/screens/LoginRegisterPage/register_page.dart';
import 'package:time_haven/services/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async{
    String? token = await SharedPreferencesUtil.getToken();
    if(token != null){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const Mainwrapper())
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Color(0xFFE2B34B),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png'
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Explore stylish watches that elevate your look for any occasion.',
                    style: GoogleFonts.nunito(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Discover precision and elegance in every timepiece!',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                ],
              )
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SlideAction(
                    outerColor: const Color(0xFF3B3B3B),
                    innerColor: const Color(0xFFE2B34B),
                    elevation: 10,
                    text: 'Get Started',
                    textStyle: GoogleFonts.nunito(
                      color: const Color(0xFFF4F4F4),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    onSubmit: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoginPage())
                      );
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet?",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: const Color(0xCC3B3B3B),
                        )
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const RegisterPage())
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Register Now',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: const Color(0xFF3B3B3B),
                            )
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}