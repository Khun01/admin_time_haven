import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_haven/components/comment_dialog.dart';
import 'package:time_haven/components/favorite_icon.dart';
import 'package:time_haven/components/product_detailes_images.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/global.dart';
import 'package:time_haven/services/shared_preferences.dart';

class ProductDetails extends StatefulWidget {

  final Products product;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? image5;
  final String brand;
  final String name;
  final double popularity;
  final double price;
  final String description;

  const ProductDetails({
    super.key,
    required this.product,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
    required this.brand, 
    required this.name, 
    required this.popularity, 
    required this.price,
    required this.description,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String displayImage = '';
  String? userId = '';

  @override
  void initState(){
    super.initState();
    displayImage = widget.image1 ?? '';
  }

  Future<void> loadUserData() async{
    final fetchedUserId = await SharedPreferencesUtil.getUserId();
    setState(() {
      userId = fetchedUserId ?? 'Id';
    });
  }

  void updateDisplayImage(String? imageUrl){
    setState(() {
      displayImage = imageUrl ?? '';
    });
  }

  void _showCommentBottomSheet(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50))
      ),
      builder: (BuildContext context){
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: CommentDialog(product: widget.product),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double popularityValue = double.tryParse(widget.popularity.toString()) ?? 0;
    if(userId == null){
      return const Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
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
                  'Product Details',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B3B3B)
                  ),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Image.network(
                  displayImage,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 20,
                child: FavoriteIcon(product: widget.product)
              )
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(0.0, 10.0),
                    blurRadius: 10.0,
                    spreadRadius: -6.0
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.brand,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B3B3b)
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.price.toString()} PHP',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B3B3b)
                          ),
                        )
                      ],
                    ),
                    Text(
                      widget.name,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xCC3B3B3b)
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index){
                            if(index < popularityValue.floor()){
                              return const Icon(Icons.star, color: Color(0xFFFFD872), size: 15);
                            }
                            return const Icon(Icons.star_outline, color: Color(0xFFFFD872), size: 15);
                          }),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '(${widget.popularity})',
                          style: GoogleFonts.nunito(
                            color: const Color(0xCC3B3B3B),
                            fontWeight: FontWeight.w700,
                            fontSize: 10
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Pictures',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B3B3b)
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ProductDetailesImages(
                          imageurl: widget.image1.toString(),
                          onTap: () => updateDisplayImage(widget.image1),
                        ),
                        const SizedBox(width: 10),
                        ProductDetailesImages(
                          imageurl: widget.image2.toString(),
                          onTap: () => updateDisplayImage(widget.image2),
                        ),
                        const SizedBox(width: 10),
                        ProductDetailesImages(
                          imageurl: widget.image3.toString(),
                          onTap: () => updateDisplayImage(widget.image3),
                        ),
                        const SizedBox(width: 10),
                        ProductDetailesImages(
                          imageurl: widget.image4.toString(),
                          onTap: () => updateDisplayImage(widget.image4),
                        ),
                        const SizedBox(width: 10),
                        ProductDetailesImages(
                          imageurl: widget.image5.toString(),
                          onTap: () => updateDisplayImage(widget.image5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Details',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B3B3b)
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.description,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: const Color(0xFF3B3B3B)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showCommentBottomSheet();
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFAFAFAF),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.comment,
                                    size: 20,
                                    color: Color(0xFF3B3B3B),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Comment',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: const Color(0xCC3B3B3B)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: (){
                            toast(context, 'Buy Now');
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2B34B),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 20,
                                  color: Color(0xFF3B3B3B),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Buy now',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xCC3B3B3B),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}