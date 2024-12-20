import 'dart:ui' as dart_ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/extension.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/screens/film_detail/components/bottom_tab.dart';
import 'package:viovid/screens/film_detail/components/play_button.dart';
import 'package:viovid/screens/film_detail/components/seasons_menu.dart';

class FilmDetail extends StatefulWidget {
  const FilmDetail({
    super.key,
    required this.filmId,
  });

  final String filmId;

  @override
  State<FilmDetail> createState() => _FilmDetailState();
}

class _FilmDetailState extends State<FilmDetail> {
  bool _isExpandOverview = false;

  int _currentSeasonIndex = 0;

  late final _futureMovie = _fetchMovie();
  Future<void> _fetchMovie() async {
    await context.read<SelectedFilmRepo>().fetchFilm(widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    // print('film_detail build');

    return Scaffold(
      body: FutureBuilder(
        future: _futureMovie,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Có lỗi xảy ra khi truy vấn thông tin phim',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // print('film_detail - FutureBuilder - build');

          final selectedFilm = context.read<SelectedFilmRepo>().selectedFilm;
          final isMovie = selectedFilm.seasons[0].name == '';

          double voteAverage = 0;
          if (selectedFilm.reviews.isNotEmpty) {
            voteAverage = selectedFilm.reviews.fold(0, (previousValue, review) => previousValue + review.star) / selectedFilm.reviews.length;

            // print(voteAverage);
          }

          final textPainter = TextPainter(
            text: TextSpan(
              text: selectedFilm.overview,
              style: const TextStyle(color: Colors.white),
            ),
            maxLines: 4,
            textDirection: dart_ui.TextDirection.ltr,
          )..layout(minWidth: 0, maxWidth: MediaQuery.sizeOf(context).width);
          final isOverflowed = textPainter.didExceedMaxLines;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              'https://image.tmdb.org/t/p/original/${selectedFilm.backdropPath}',
                            ),
                            fit: BoxFit.cover),
                      ),
                      width: double.infinity,
                      height: 9 / 16 * MediaQuery.sizeOf(context).width,
                    ),
                    // Layer Gradient 1
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Layer Gradient 2
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: [0, 0.5],
                            begin: Alignment.bottomLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                    /* Content Rating */
                    Positioned(
                      bottom: 360,
                      right: 0,
                      width: 90,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF696A6A).withOpacity(0.7),
                          border: const Border(
                            left: BorderSide(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Text(
                          selectedFilm.contentRating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    /* Film's Info */
                    Positioned(
                      bottom: 20,
                      left: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedFilm.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(2.0, 4.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(24),

                          /* Nếu Film được chọn là movie, thì nó không có Season */
                          isMovie
                              ? PlayButton(
                                  episode: selectedFilm.seasons[0].episodes[0],
                                )
                              : SeasonsMenu(
                                  currentSeasonIndex: _currentSeasonIndex,
                                  seasons: selectedFilm.seasons,
                                  onChangedSeason: (seasonIndex) => setState(
                                    () {
                                      _currentSeasonIndex = seasonIndex;
                                    },
                                  ),
                                ),
                          const Gap(24),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                voteAverage == 0 ? 'Chưa có đánh giá' : 'Điểm: ${(voteAverage * 2).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(40),
                              Ink(
                                height: 28,
                                width: 2,
                                color: Colors.white,
                              ),
                              const Gap(40),
                              Text(
                                'Phát hành:   ${selectedFilm.releaseDate.toVnFormat()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          const Text(
                            'Thể loại: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              selectedFilm.genres.length,
                              (index) {
                                bool isHover = false;
                                return StatefulBuilder(
                                  builder: (ctx, setStateGenre) {
                                    return TapRegion(
                                      onTapInside: (event) {},
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onEnter: (_) => setStateGenre(() => isHover = true),
                                        onExit: (_) => setStateGenre(() => isHover = false),
                                        child: Text(
                                          selectedFilm.genres[index].name + (index == selectedFilm.genres.length - 1 ? '' : ', '),
                                          style: TextStyle(
                                            color: const Color(0xFFBEBEBE),
                                            decoration: isHover ? TextDecoration.underline : null,
                                            decorationColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedFilm.overview,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: _isExpandOverview ? 100 : 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      const Gap(4),
                      if (isOverflowed)
                        InkWell(
                          onTap: () => setState(() {
                            _isExpandOverview = !_isExpandOverview;
                          }),
                          child: Text(
                            _isExpandOverview ? 'Ẩn bớt' : 'Xem thêm',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                          ),
                        ),
                      const Gap(4),
                      BottomTab(
                        filmId: selectedFilm.id,
                        isMovie: isMovie,
                        episodes: selectedFilm.seasons[_currentSeasonIndex].episodes,
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
