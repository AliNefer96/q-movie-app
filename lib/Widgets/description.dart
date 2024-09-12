import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String description;

  const Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const  SizedBox(
          height: 20,
          child:  Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE4ECEF),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Color(0xFFE4ECEF),
          ),
        ),
      ],
    );
  }
}
