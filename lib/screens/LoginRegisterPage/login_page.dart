import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:time_haven/components/form_login_signin.dart';
import 'package:time_haven/components/my_button.dart';
import 'package:time_haven/components/squaretile.dart';
import 'package:time_haven/navigation/mainwrapper.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/global.dart';
import 'package:time_haven/services/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final email = TextEditingController();
  final password = TextEditingController();

  void loggedUserIn(BuildContext context) async{
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      }
    );
    if(email.text.isNotEmpty && password.text.isNotEmpty){
      http.Response response = await AuthServices.login(email.text, password.text);
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body);
        var userMap = responseData['user'];
        String user = (userMap is Map<String, dynamic>) ? jsonEncode(userMap) : userMap.toString();
        String token = responseData['token'];
        if(token.isNotEmpty){
          await SharedPreferencesUtil.saveUserData(user, token);
          if(context.mounted){
            FocusScope.of(context).unfocus();
            toast(context, 'Logged in Successfully');
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Mainwrapper())
            );
          }
        }else{
          if(context.mounted){
            toast(context, 'Token is missing and empty');
            Navigator.of(context).pop();
          }
        }
      }else{
        if(context.mounted){
          String errorMessage = "The email and password doesn't match our records";
          toast(context, errorMessage);
          Navigator.of(context).pop();
        }
      }
    }else{
      if(context.mounted){
        toast(context, 'Enter your email and password');
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF3B3B3B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
                )
              ),
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 10),
              alignment: Alignment.topLeft,
              child: Stack(
                children: [
                  Positioned(
                    left: -15,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFF4F4F4)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Welcome',
                        style: GoogleFonts.nunito(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF4F4F4)
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          'Please sign in your Account',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xCCF4F4F4)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: GoogleFonts.nunito(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3B3B3B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  MyFormLoginSignUp(
                    controller: email, 
                    hintText: 'Email', 
                    obscureText: false,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  MyFormLoginSignUp(
                    controller: password, 
                    hintText: 'Password', 
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20.0),
                  MyButton(
                    onTap: () {
                      loggedUserIn(context);
                    },
                    buttonText: 'Login',
                  ),
                  const SizedBox(height: 30.0),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or Continue With',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: const Color(0xCC3B3B3B)
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(imagePath: 'assets/images/google.png'),
                          SizedBox(width: 15.0),
                          SquareTile(imagePath: 'assets/images/facebook.png'),
                          SizedBox(width: 15.0),
                          SquareTile(imagePath: 'assets/images/apple.png'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not registered yet?',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: const Color(0xCC3B3B3B),
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            child: Text(
                              'Register Now',
                              style: GoogleFonts.nunito(
                                color: const Color(0xFF3B3B3B),
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const LoginPage())
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}