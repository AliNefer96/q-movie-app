class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<int> genreIds;
  final String releaseDate;
  final double rating;

  Movie(
      {required this.id,
      required this.title,
      required this.overview,
      required this.posterPath,
      required this.genreIds,
      required this.releaseDate,
      required this.rating});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title',
      overview: json['overview'] ?? 'No overview',
      posterPath: json['poster_path'],
      rating: (json['vote_average'] ?? 0.0).toDouble(),
      releaseDate: json['release_date'] ?? 'Unknown',
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}
