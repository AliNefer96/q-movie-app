import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/Widgets/genre_chip.dart';
import 'package:movie_app/Widgets/rating.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final List<String> genres;
  final VoidCallback onTap;
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.genres,
    required this.onTap,
    required this.isFavourite,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageUrl.isNotEmpty
                          ? ClipRect(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 100, height: 100, color: Colors.grey),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  color: Color(0xFFE4ECEF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Rating(rating: rating),
                            const SizedBox(height: 12),
                            GenreChip(genreNames: genres),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              child: IconButton(
                icon: SvgPicture.asset(
                  isFavourite
                      ? 'assets/icons/bookmark_added_black_24dp 1.svg'
                      : 'assets/icons/bookmark_border_black_24dp 3.svg',
                  color: isFavourite
                      ? const Color(0xFFEC9B3E)
                      : const Color(0xFFE4ECEF),
                  width: 24,
                  height: 24,
                ),
                onPressed: onFavouriteToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
