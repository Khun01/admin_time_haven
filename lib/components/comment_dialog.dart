import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/cards/comment_card.dart';
import 'package:time_haven/models/comment.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';
import 'package:time_haven/services/global.dart';

class CommentDialog extends StatefulWidget {
  final Products product;

  const CommentDialog({
    super.key,
    required this.product
  });

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  List<Comment> comments = [];
  bool isLoading = true;
  final commentController = TextEditingController();
  bool isSending = false;

  @override
  void initState(){
    super.initState();
    getComments();
  }

  Future<void> getComments() async{
    try{
      comments = await AuthServices.fetchComments(widget.product.id);
      setState(() {
        isLoading = false;
      });
      logger.d('Fetched comments: $comments');
    }catch(e){
      logger.e('Error fetching comments: $e');
    }
  }

  Future<void> sendComment() async{
    final commentText = commentController.text;
    if(commentText.isEmpty){
      toast(
        context, 
        'Please put your comment first'
      );
      return;
    }
    setState(() {
      isSending = true;
    });
    try{
      await AuthServices.storeComment(widget.product.id, commentText);
      await getComments();
      toast(
        // ignore: use_build_context_synchronously
        context, 
        'Comment sent successfully'
      );
      commentController.clear();
    }catch(e){
      toast(
        // ignore: use_build_context_synchronously
        context, 
        'Failed to send your comment: $e'
      );
    }finally{
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.comment,  color: Color(0xFF3B3B3B), size: 20),
                const SizedBox(width: 15),
                Text(
                  'Comments',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xCC3B3B3B)
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            Expanded(
              child: isLoading ? const Center(child: CircularProgressIndicator()) :
              ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return CommentCard(
                    profile: '$baseUrl${comment.profile}',
                    name: comment.name,
                    comment: comment.comment,
                  );
                },
              ),
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFAFAFAF),
                borderRadius: BorderRadius.circular(10)
              ),
              child: TextField(
                controller: commentController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Comment',
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 12,
                    color: const Color(0xCC3B3B3B)
                  ),
                  prefixIcon: const Icon(
                    Icons.comment,
                    size: 20,
                    color: Color(0xFF3B3B3B),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: sendComment,
                    child: isSending ? const SizedBox (
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )
                    ) :
                    const Icon(
                      Icons.send,
                      size: 20,
                      color: Color(0xFF3B3B3B),
                    ),
                  ),
                ),
                style: GoogleFonts.nunito(
                  fontSize: 12
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}