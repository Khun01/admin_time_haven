import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentCard extends StatelessWidget {
  final String? profile;
  final String name;
  final String comment;

  const CommentCard({
    super.key,
    required this.profile,
    required this.name,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFAFAFAF),
            child: (profile != null && profile!.isNotEmpty && profile != 'null') ? 
            ClipOval(
              child: Image.network(
                profile!,
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace){
                  return const Icon(
                    Icons.person,
                    size: 44,
                    color: Color(0xCC3B3B3B),
                  );
                },
              ),
            ) : 
            const Icon(
              Icons.person,
              size: 44,
              color: Color(0xCC3B3B3B),
            )
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B3B3B)
                  ),
                ),
                Text(
                  comment,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: const Color(0xFF3B3B3B)
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}