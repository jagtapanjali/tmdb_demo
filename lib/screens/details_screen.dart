import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model/movie_details.dart';
import '../services/movie.dart';
import '../utils/constants.dart';
import '../utils/star_calculator.dart';
import '../widgets/custom_loading_spin_kit_ring.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  const DetailsScreen({super.key, required this.id});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();

  Future<MovieDetails> getMovieDetails() async {
    MovieModel movieModel = MovieModel();
    MovieDetails temp = await movieModel.getMovieDetails(movieID: id);
    return temp;
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  MovieDetails? movieDetails;
  List<Widget>? stars;

  @override
  void initState() {
    super.initState();
    () async {
      MovieDetails temp = await widget.getMovieDetails();
      List<Widget> temp2 = getStars(rating: temp.rating, starSize: 15);

      setState(() {
        movieDetails = temp;
        stars = temp2;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (stars == null)
          ? CustomLoadingSpinKitRing()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  shadowColor: Colors.transparent.withOpacity(0.1),
                  elevation: 0,
                  backgroundColor: kPrimaryColor,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 400.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    //title: const Text(kDetailsScreenTitleText),
                    background: SafeArea(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SafeArea(
                          child: SizedBox(
                            height: 22,
                            child: CustomLoadingSpinKitRing(),
                          ),
                        ),
                        imageUrl: movieDetails!.backgroundURL,
                        errorWidget: (context, url, error) => SafeArea(
                          child: SizedBox(
                            height: 22,
                            child: CustomLoadingSpinKitRing(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Wrap(
                              children: [
                                Text(
                                  "${movieDetails!.title} ",
                                  style: kDetailScreenBoldTitle,
                                ),
                                Text(
                                  (movieDetails!.year == "")
                                      ? ""
                                      : "(${movieDetails!.year})",
                                  style: kDetailScreenRegularTitle,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(children: stars!),
                          ),
                        ],
                      ),
                      if (movieDetails!.overview != "")
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 1,
                                    left: 1,
                                    bottom: 1,
                                  ),
                                  child: Text(kStoryLineTitleText,
                                      style: kSmallTitleTextStyle),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 1, left: 1, top: 1, bottom: 4),
                                    child: Text(
                                      movieDetails!.overview,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFC9C9C9)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
