import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/genre.dart';
import '../models/movie.dart';

class ApiService {
  final Dio _dio;
  final String bearer;

  ApiService({required this.bearer})
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          headers: {'Authorization': 'Bearer $bearer'},
        ));

  Future<List<Genre>> fetchGenres() async {
    final response = await _dio.get('/genre/movie/list?language=en-US');
    if (response.statusCode == 200) {
      List genres = response.data['genres'];
      return genres.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> fetchPopularMovies(int page) async {
    final response = await _dio.get('/movie/popular', queryParameters: {
      'language': 'en-US',
      'page': page,
    });
    if (response.statusCode == 200) {
      List movies = response.data['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

 Future<Movie> fetchMovieDetails(int movieId) async {
  try {
    final response = await _dio.get('/movie/$movieId?language=en-US');
    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    } else {
      throw Exception('Failed to load movie details: ${response.statusMessage}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching movie details: $e');
    }
    rethrow;  
  }
}
}
