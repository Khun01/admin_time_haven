import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconText extends StatelessWidget {

  final IconData icon;
  final String text1;
  final String? text2;
  final Color iconColor;
  final VoidCallback onTap;
  
  const IconText({
    super.key,
    required this.icon,
    required this.text1,
    this.text2,
    this.iconColor = const Color(0xFFE2B34B),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: GoogleFonts.nunito(
                    color: const Color(0xCC3B3B3B),
                    fontSize: 14,
                  ),
                ),
                if(text2 != null && text2!.isNotEmpty)...[
                  Text(
                    text2!,
                    style: GoogleFonts.nunito(
                      color: const Color(0x803B3B3B),
                      fontSize: 10,
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}