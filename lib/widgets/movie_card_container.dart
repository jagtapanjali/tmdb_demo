import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import 'movie_card.dart';

class MovieCardContainer extends StatelessWidget {
  final List<MovieCard> movieCards;

  MovieCardContainer({
    required this.movieCards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //movie_card_container
      child: Padding(
        padding: EdgeInsets.only(right: 2.w, left: 2.w),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: movieCards.isEmpty
              ? const Text(k404Text)
            : Wrap(children: movieCards),
          ),
        ),
      ),
    );
  }
}
