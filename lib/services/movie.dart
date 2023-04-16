import 'package:flutter/material.dart';

import '../model/movie_details.dart';
import '../model/movie_preview.dart';
import '../utils/constants.dart';
import '../widgets/movie_card.dart';
import 'networking.dart';

class MovieModel {
  Future _getData({required String url}) async {
    NetworkHelper networkHelper = NetworkHelper(Uri.parse(url));
    var data = await networkHelper.getData();
    return data;
  }

  Future<List<MovieCard>> getMovies() async {
    List<MovieCard> temp = [];
    var data = await _getData(
      url: '$kThemoviedbURL/popular?api_key=${themoviedbApi}',
    );

    for (var item in data["results"]) {
      temp.add(
        MovieCard(
          moviePreview: MoviePreview(
            // isFavorite:
            //     await isMovieInFavorites(movieID: item["id"].toString()),
            year: (item["release_date"].toString().length > 4)
                ? item["release_date"].toString().substring(0, 4)
                : "",
            imageUrl: "$kThemoviedbImageURL${item["poster_path"]}",
            title: item["title"],
            id: item["id"].toString(),
            rating: item["vote_average"].toDouble(),
            overview: item["overview"],
          ),
          themeColor: Colors.green,
        ),
      );
    }
    return Future.value(temp);
  }

  Future<MovieDetails> getMovieDetails({required String movieID}) async {
    var data = await _getData(
      url:
          '$kThemoviedbURL/$movieID?api_key=${themoviedbApi}&language=en-US',
    );

    List<String> temp = [];
    List<int> genreIdsTemp = [];
    for (var item in data["genres"]) {
      temp.add(item["name"]);
      genreIdsTemp.add(item["id"]);
    }

    return Future.value(
      MovieDetails(
        homepage: data["homepage"],
        backgroundURL:
            "https://image.tmdb.org/t/p/w500${data["backdrop_path"]}",
        title: data["title"],
        year: (data["release_date"].toString().length > 4)
            ? data["release_date"].toString().substring(0, 4)
            : "",
        rating: data["vote_average"].toDouble(),
        genres: Map.fromIterables(temp, genreIdsTemp),
        overview: data["overview"],
      ),
    );
  }

}
