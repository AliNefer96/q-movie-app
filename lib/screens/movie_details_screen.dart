import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/Widgets/description.dart';
import 'package:movie_app/Widgets/genre_chip.dart';
import 'package:movie_app/Widgets/rating.dart';
import 'package:movie_app/helpers/http_helper.dart';
import 'package:movie_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  final List<String> genreNames;

  const MovieDetailScreen({super.key, required this.movieId, required this.genreNames});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieFuture;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    final bearerToken = Provider.of<AuthProvider>(context, listen: false).bearerToken;
    _apiService = ApiService(bearer: bearerToken);
    _movieFuture = _apiService.fetchMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Stack(
            children: [
              FutureBuilder<Movie>(
                future: _movieFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('Movie not found'));
                  }

                  final movie = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            // ignore: unnecessary_null_comparison
                            movie.posterPath != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    width: double.infinity,
                                    height: 400,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 400,
                                    color: Colors.grey,
                                    child: const Center(child: Text('No Image')),
                                  ),
                            Positioned(
                              top: 28,
                              left: 20,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_right_alt_black_24dp 1.svg',
                                  width: 24,
                                  height: 24,
                                  color: const Color(0xFFE4ECEF),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          transform: Matrix4.translationValues(0, -40, 0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 24,
                                      child: Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFE4ECEF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      movieProvider.toggleFavourite(movie);
                                    },
                                    icon: SvgPicture.asset(
                                      movieProvider.isFavourite(movie)
                                          ? 'assets/icons/bookmark_added_black_24dp 1.svg'
                                          : 'assets/icons/bookmark_border_black_24dp 3.svg',
                                      color: movieProvider.isFavourite(movie)
                                          ? const Color(0xFFEC9B3E)
                                          : const Color(0xFFE4ECEF),
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Rating(rating: movie.rating),
                              const SizedBox(height: 16),
                              GenreChip(genreNames: widget.genreNames),
                              const SizedBox(height: 40),
                              Description(description: movie.overview)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
