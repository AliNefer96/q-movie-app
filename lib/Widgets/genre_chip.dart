import 'package:flutter/material.dart';

class GenreChip extends StatelessWidget {
  final List<String> genreNames;

  const GenreChip({super.key, required this.genreNames});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFFEC9B3E);
    Color fadedPrimaryColor = primaryColor.withOpacity(0.2);
    return Wrap(
      runSpacing: 4,
      spacing: 4,
      children: genreNames.map((genre) {
        return Container(
          padding:const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: fadedPrimaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            genre,
            style: const TextStyle(
                color: Color(0xFFE4ECEF), fontSize: 11, fontWeight: FontWeight.w400),
          ),
        );
      }).toList(),
    );
  }
}
