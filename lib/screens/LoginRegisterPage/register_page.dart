import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/form_login_signin.dart';
import 'package:time_haven/components/my_button.dart';
import 'package:time_haven/components/squaretile.dart';
import 'package:time_haven/screens/LoginRegisterPage/login_page.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/global.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confrimPassword = TextEditingController();
  bool agreedToTerms = false;

  void registerUserIn(BuildContext context) async{
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

    bool emailValid = RegExp(r"^[a-zA-Z0-9-.a-zA-Z0-9.!#$%'*+-/=?^_`{|}~]+@[a-zA-Z0-0]+\.[a-zA-Z]+").hasMatch(email.text);
    if(username.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty && confrimPassword.text.isNotEmpty){
      if(!agreedToTerms){
        if(context.mounted){ 
          String errorMessage = "You must agree to the terms and conditions";
          toast(context, errorMessage);
          Navigator.of(context).pop();
        }
      }else{
        if(emailValid){
          http.Response response = await AuthServices.register(username.text, email.text, password.text);
          if(password.text == confrimPassword.text){
            if(response.statusCode == 200){
              if(context.mounted){
                Navigator.of(context).pop();
                toast(context, 'Registered Successfully');
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginPage())
                );
              }
            }else{
              if(context.mounted){
                Navigator.of(context).pop();
                String errorMessage = 'Email is already Taken';
                toast(context, errorMessage);
              }
            }
          }else{
            if(context.mounted){
              Navigator.of(context).pop();
              String errorMessage = "Password and Confirm Password doesn't match";
              toast(context, errorMessage);
            }
          }
        }else{
          Navigator.of(context).pop();
          toast(context, 'Email not valid');
          Navigator.of(context).pop();
        }
      }
    }else{
      if(context.mounted){
        String errorMessage = "Please put your information";
        toast(context, errorMessage);
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
                        'Create Account',
                        style: GoogleFonts.nunito(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF4F4F4)
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          'Please fill in the form to continue',
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
                  MyFormLoginSignUp(
                    controller: username, 
                    hintText: 'Username', 
                    obscureText: false,
                    icon: Icons.person,
                  ),
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
                  const SizedBox(height: 10),
                  MyFormLoginSignUp(
                    controller: confrimPassword, 
                    hintText: 'Confrm Password', 
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: agreedToTerms, 
                        activeColor: Colors.black,
                        onChanged: (bool? value){
                          setState(() {
                            agreedToTerms = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'I agree to the terms and conditions',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: const Color(0xCC3B3B3B)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  MyButton(
                    onTap: () {
                      registerUserIn(context);
                    },
                    buttonText: 'Register',
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
                            'Already have an Account?',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: const Color(0xCC3B3B3B),
                              
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            child: Text(
                              'Sign In',
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