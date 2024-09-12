import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/helpers/db_helper.dart';
import 'package:movie_app/helpers/http_helper.dart';
import '../models/genre.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final ApiService apiService;
  final DatabaseHelper dbHelper = DatabaseHelper();
  final Connectivity _connectivity = Connectivity();
  List<Genre> _genres = [];
  List<Movie> _movies = [];
  List<Movie> _favourites = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isOffline = false;
  

  List<Genre> get genres => _genres;
  List<Movie> get movies => _movies;
  List<Movie> get favourites => _favourites;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  bool get isOffline => _isOffline;

  MovieProvider({required this.apiService});

  Future<void> initialize() async {
    await fetchGenres();
    await loadCachedMovies();
    await loadCachedFavourites(); 
    await fetchMovies(); 
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _isOffline = (result == ConnectivityResult.none);
      notifyListeners();
    });
  }

  Future<void> fetchGenres() async {
    try {
      _genres = await apiService.fetchGenres();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching genres: $e');
      }
    }
  }

  Future<void> loadCachedMovies() async {
    _movies = await dbHelper.getMovies();
    notifyListeners();
  }

  Future<void> loadCachedFavourites() async {
    _favourites = await dbHelper.getFavourites();
    notifyListeners();
  }

  Future<void> fetchMovies() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    if (_isOffline) {
      if (kDebugMode) {
        print("User is offline, showing cached movies");
      }
      _movies = await dbHelper.getMovies();
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      List<Movie> fetchedMovies =
          await apiService.fetchPopularMovies(_currentPage);
      if (fetchedMovies.isEmpty) {
        _hasMore = false;
      } else {
        _movies.addAll(fetchedMovies);
        await dbHelper
            .insertMovies(fetchedMovies); 
        _currentPage++;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching movies: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  List<String> getGenreNames(List<int> genreIds) {
    return _genres
        .where((genre) => genreIds.contains(genre.id))
        .map((genre) => genre.name)
        .toList();
  }

  
  bool isFavourite(Movie movie) {
    return _favourites.any((fav) => fav.id == movie.id);
  }

  
  Future<void> toggleFavourite(Movie movie) async {
    if (isFavourite(movie)) {
      _favourites.removeWhere((fav) => fav.id == movie.id);
      await dbHelper.removeFavourite(movie.id);
    } else {
      _favourites.add(movie);
      await dbHelper.insertFavourite(movie); 
    }
    notifyListeners();
  }
}
