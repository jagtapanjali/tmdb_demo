class MoviePreview {
  final String id;
  final String title;
  final String? imageUrl;
  final String year;
  final double rating;
  String overview;

  MoviePreview({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.year,
    required this.overview,
    required this.rating,
  });
}
