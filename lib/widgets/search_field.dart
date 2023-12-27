import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key, required this.searchController, required this.onChanged});

  final void Function(String)? onChanged;

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextField(
        onChanged: onChanged,
        controller: searchController,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(top: 3),
            constraints: BoxConstraints(maxHeight: 40),
            hintText: "Search",
            border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            filled: true,
            fillColor: Color.fromARGB(17, 255, 255, 255)),
      ),
    );
  }
}
