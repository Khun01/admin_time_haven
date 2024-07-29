import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Notification',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B3B3B)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}