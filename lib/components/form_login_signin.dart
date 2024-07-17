import 'package:flutter/material.dart';

class MyFormLoginSignUp extends StatefulWidget{

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? icon;

  const MyFormLoginSignUp({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon
  });

  @override
  MyFormLoginSignUpState createState() => MyFormLoginSignUpState();

}

class MyFormLoginSignUpState extends State<MyFormLoginSignUp>{
  late bool obscureText;

  @override
  void initState(){
    super.initState();
    obscureText = widget.obscureText;
  }
  void _toggleObscureText(){
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
       controller: widget.controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF3B3B3B), width: 2.0)
          ),
          fillColor: Colors.transparent,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          suffixIcon: widget.obscureText ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off
            ),
            onPressed: _toggleObscureText,
          ): null
        ),
        style: const TextStyle(
          fontSize: 14
        ),
    );
  }
}