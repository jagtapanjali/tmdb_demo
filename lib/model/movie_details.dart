class MovieDetails {
  final String homepage;
  final String title;
  final String year;
  final double rating;
  final Map<String, int> genres;

  final String overview;
  final String backgroundURL;

  MovieDetails({
    required this.homepage,
    required this.title,
    required this.year,
    required this.rating,
    required this.genres,
    required this.overview,
    required this.backgroundURL,
  });

}
