import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/Widgets/movie_card.dart';
import 'package:movie_app/models/movie.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  late MovieProvider _movieProvider;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_movieProvider.isOffline) {
        _showOfflineSnackbar();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<MovieProvider>(context);
    provider.addListener(() {
      if (provider.isOffline) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _showOfflineSnackbar();
        });
      }
    });
  }

  void _showOfflineSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      elevation: 1000,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "You're offline, showing cached movies",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_movieProvider.isLoading &&
        _movieProvider.hasMore) {
      _movieProvider.fetchMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 0, 0),
          child: SvgPicture.asset(
            'assets/icons/foreground.svg',
            width: 28,
            height: 28,
            color: const Color(0xFFEC983E),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 0, 20),
            child: SizedBox(
              height: 28,
              child: Text(
                _selectedIndex == 0 ? 'Popular' : 'Favourites',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE4ECEF)),
              ),
            ),
          ),
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, provider, child) {
                List<Movie> moviesToShow =
                    _selectedIndex == 0 ? provider.movies : provider.favourites;
                if (moviesToShow.isEmpty && provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.hasMore && _selectedIndex == 0
                      ? moviesToShow.length + 1
                      : moviesToShow.length,
                  itemBuilder: (context, index) {
                    if (index >= moviesToShow.length && _selectedIndex == 0) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final movie = moviesToShow[index];
                    final List<String> genreNames =
                        provider.getGenreNames(movie.genreIds);

                    return MovieCard(
                      title: movie.title,
                      imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      rating: movie.rating,
                      genres: genreNames,
                      onTap: () {
                        _createRoute(movie.id, genreNames);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailScreen(
                              movieId: movie.id,
                              genreNames: genreNames,
                            ),
                          ),
                        );
                      },
                      isFavourite: provider.isFavourite(movie),
                      onFavouriteToggle: () {
                        provider.toggleFavourite(movie);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          double itemWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              SizedBox(
                height: 60,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.black,
                  items: [
                    BottomNavigationBarItem(
                      icon: _buildNavBarItem(
                          'assets/icons/movie_black_24dp 1.svg', 'Movies', 0),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildNavBarItem(
                          'assets/icons/favourite.svg', 'Favourites', 1),
                      label: '',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color(0xFFEC9B3E),
                  unselectedItemColor: const Color(0xFFE4ECEF),
                  onTap: _onItemTapped,
                ),
              ),
              Positioned(
                top: 0,
                left: _selectedIndex * itemWidth + (itemWidth - 110) / 2,
                child: Container(
                  height: 2.0,
                  color: const Color(0xFFEC9B3E),
                  width: 110.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavBarItem(String assetPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 24,
            height: 24,
            color: isSelected ? const Color(0xFFEC9B3E) : const Color(0xFFE4ECEF),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFEC9B3E) : const Color(0xFFE4ECEF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute(int movieId, List<String> genreNames) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetailScreen(
        movieId: movieId,
        genreNames: genreNames,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
