import 'package:flutter/material.dart';
import 'package:time_haven/models/products.dart';
import 'package:time_haven/services/auth_services.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController controller = TextEditingController();
  bool hasText = false;

  @override
  void initState(){
    super.initState();
    controller.addListener((){
      setState(() {
        hasText = controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x333B3B3B)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(0.0, 10.0),
                  blurRadius: 10.0,
                  spreadRadius: -6.0
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                hintText: 'Search ...',
                hintStyle: const TextStyle(
                  color: Color(0x803B3B3B)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none
                ),
                suffixIcon: hasText ? 
                GestureDetector(
                  onTap: (){
                    controller.clear();
                    widget.onSearch('');
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF3B3B3B),
                  ),
                ): null
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            final query = controller.text.trim();
            if(query.isNotEmpty){
              widget.onSearch(query);
            }else{
              widget.onSearch('');
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0x333B3B3B)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(0.0, 10.0),
                  blurRadius: 10.0,
                  spreadRadius: -6.0
                ),
              ]
            ),
            child: const Icon(
              Icons.search,
              color: Color(0xFF3B3B3B),
            ),
          ),
        ),
      ],
    );
  }
}