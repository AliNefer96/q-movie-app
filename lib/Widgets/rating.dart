import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Rating extends StatelessWidget {
  final double rating;

  const Rating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/star_black_24dp 3.svg',
          color:const Color(0xFFF2CF16),
          width: 16,
          height: 16,
        ),
      const  SizedBox(width: 4),
        Text(
          '${rating.toStringAsFixed(1)}/ 10 IMDb',
          style: const TextStyle(
              color: Color(0xFFE4ECEF), fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
