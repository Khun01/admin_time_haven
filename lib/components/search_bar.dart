import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String query = '';

  void onQueryChanged(String newQuery){
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF3B3B3B))
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF3B3B3B))
                ),
                hintText: 'Search ...',
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF3B3B3B))
            ),
            padding: const EdgeInsets.all(15),
            child: const Icon(Icons.search, color: Color(0xFF3B3B3B)),
          ),
        )
      ],
    );
  }
}