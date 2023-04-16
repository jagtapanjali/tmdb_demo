import 'package:flutter/material.dart';

import '../services/movie.dart';
import '../utils/constants.dart';
import '../widgets/custom_loading_spin_kit_ring.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_card_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<MovieCard>? _movieCards;
  final List<MovieCard> _searchResult = [];
  TextEditingController searchController = TextEditingController();
  String searchText = "";
  bool isSearchSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    MovieModel movieModel = MovieModel();
    _movieCards =
        await movieModel.getMovies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: (_movieCards == null)
          ? CustomLoadingSpinKitRing()
          : (_movieCards!.length == 0)
              ? const Center(child: Text(k404Text))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: !isSearchSelected,
                            child: const Text(
                              kHomeScreenTitleText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                              visible: !isSearchSelected,
                              child: const Spacer()),
                          GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    isSearchSelected = !isSearchSelected;
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.search,
                                size: 26,
                              )),
                          Visibility(
                            visible: isSearchSelected,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1),
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Focus(
                                onFocusChange: (value) {
                                  if (!value) {
                                    if (mounted) {
                                      setState(() {
                                        searchText = "";
                                        onSearchTextChanged('');
                                      });
                                    }
                                  }
                                },
                                child: Center(
                                  child: TextField(
                                    controller: searchController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    cursorColor: Colors.white,
                                    decoration: const InputDecoration(
                                      hintText: "Search Battery By Id",
                                      hintStyle: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          searchText = value;
                                          onSearchTextChanged(searchText);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isSearchSelected,
                            child: GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      isSearchSelected = false;
                                      searchController.clear();
                                      onSearchTextChanged('');
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.green,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: MovieCardContainer(
                        movieCards: isSearchSelected
                            ? _searchResult.isNotEmpty
                                ? _searchResult
                                : searchText.isEmpty
                                    ? _movieCards!
                                    : []
                            : _movieCards!,
                      ),
                    ),
                  ],
                ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      _movieCards!.forEach((card) {
        if (card.moviePreview.title.toLowerCase().contains(text.toLowerCase())) _searchResult.add(card);
      });
    });
  }
}
