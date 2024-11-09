import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/episode.dart';
import 'package:viovid/models/poster.dart';
import 'package:viovid/screens/film_detail/components/episode_item.dart';
import 'package:viovid/screens/film_detail/components/grid_films.dart';
import 'package:viovid/screens/film_detail/components/grid_persons.dart';
import 'package:viovid/screens/film_detail/components/grid_shimmer.dart';
import 'package:viovid/screens/film_detail/components/review_input.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({
    super.key,
    required this.filmId,
    required this.isMovie,
    required this.episodes,
  });

  final String filmId;
  final bool isMovie;
  final List<Episode> episodes;

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> with TickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;

  // late final _listEpisodes = ListEpisodes(widget.episode);

  final _gridShimmer = const GridShimmer();

  final List<Poster> _recommendFilms = [];
  late final _futureRecommendFilms = _fetchRecommendFilms();

  late final List<dynamic> _castData;
  late final _futureCastData = _fetchCastData();

  late final List<dynamic> _crewData;
  late final _futureCrewData = _fetchCrewData();

  Future<void> _fetchRecommendFilms() async {
    String type = widget.isMovie ? 'movie' : 'tv';
    String url = "https://api.themoviedb.org/3/$type/${widget.filmId}/recommendations?api_key=$tmdbApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse the response JSON
      // print('Response: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> results = data['results'];

      for (var i = 0; i < results.length; ++i) {
        if (results[i]['poster_path'] == null) {
          continue;
        }
        _recommendFilms.add(
          Poster(
            filmId: results[i]['id'].toString(),
            posterPath: results[i]['poster_path'],
          ),
        );
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _fetchCastData() async {
    _castData = await supabase.from('cast').select('role: character, person(id, name, profile_path, popularity)').eq('film_id', widget.filmId);

    _castData.sort((a, b) => b['person']['popularity'].compareTo(a['person']['popularity']));

    // String casts = '';
    // for (var element in _castData) {
    //   casts += element['person']['name'] + ', ';
    // }

    // print('casts = ' + casts);

    // String characters = '';
    // for (var element in _castData) {
    //   characters += element['role'] + ', ';
    // }

    // print('characters = $characters');
  }

  Future<void> _fetchCrewData() async {
    _crewData = await supabase.from('crew').select('role: job, person(id, name, profile_path, popularity, gender)').eq('film_id', widget.filmId);

    _crewData.sort((a, b) => b['person']['popularity'].compareTo(a['person']['popularity']));

    // String crews = '';
    // for (var element in _crewData) {
    //   crews += element['person']['name'] + ', ';
    // }

    // print('crews = ' + crews);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4 + (widget.isMovie ? 0 : 1),
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          labelColor: Colors.white,
          unselectedLabelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          indicatorColor: primaryColor,
          splashBorderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.white.withOpacity(0.2);
            }
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withOpacity(0.2);
            }
            return Colors.transparent;
          }),
          tabs: [
            if (!widget.isMovie)
              const Tab(
                text: 'Tập phim',
              ),
            const Tab(
              text: 'Diễn viên',
            ),
            const Tab(
              text: 'Đội ngũ',
            ),
            const Tab(
              text: 'Đề xuất',
            ),
            const Tab(
              text: 'Review',
            ),
          ],
        ),
        const Gap(20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: switch (_tabIndex + (widget.isMovie ? 1 : 0)) {
            0 => Column(
                children: widget.episodes.map((episode) => EpisodeItem(episode: episode)).toList(),
              ),
            1 => FutureBuilder(
                future: _futureCastData,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _gridShimmer;
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Truy xuất thông tin Diễn viên thất bại',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }

                  return GridPersons(personsData: _castData);
                },
              ),
            2 => FutureBuilder(
                future: _futureCrewData,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _gridShimmer;
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Truy xuất thông tin Đội ngũ thất bại',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }

                  return GridPersons(
                    personsData: _crewData,
                    isCast: false,
                  );
                },
              ),
            3 => FutureBuilder(
                future: _futureRecommendFilms,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _gridShimmer;
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Truy xuất thông tin Đề xuất thất bại',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }

                  return GridFilms(
                    posters: _recommendFilms,
                    canClick: false,
                  );
                },
              ),
            4 => const Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReviewInput()
                  // FutureBuilder(
                  //   future: _futureRecommendFilms,
                  //   builder: (ctx, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return _gridShimmer;
                  //     }

                  //     if (snapshot.hasError) {
                  //       return const Text(
                  //         'Truy xuất thông tin Đề xuất thất bại',
                  //         style: TextStyle(color: Colors.white),
                  //         textAlign: TextAlign.center,
                  //       );
                  //     }

                  //     return GridFilms(
                  //       posters: _recommendFilms,
                  //       canClick: false,
                  //     );
                  //   },
                  // ),
                ],
              ),
            _ => null,
          },
        ),
      ],
    );
  }
}
