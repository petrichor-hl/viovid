import 'package:viovid/base/common_variables.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/episode.dart';
import 'package:viovid/models/film.dart';
import 'package:viovid/models/genre.dart';
import 'package:viovid/models/review_film.dart';
import 'package:viovid/models/season.dart';

class SelectedFilmRepo {
  late Film selectedFilm;

  Future<Film> fetchFilm(String filmId) async {
    final filmInfo = await supabase
        .from('film')
        .select(
          'name, release_date, vote_average, vote_count, overview, backdrop_path, poster_path, content_rating, trailer',
        )
        .eq('id', filmId)
        .single();

    // print('filmData = $filmInfo');

    selectedFilm = Film(
      id: filmId,
      name: filmInfo['name'],
      releaseDate: DateTime.parse(filmInfo['release_date']),
      voteAverage: filmInfo['vote_average'],
      voteCount: filmInfo['vote_count'],
      overview: filmInfo['overview'],
      backdropPath: filmInfo['backdrop_path'],
      posterPath: filmInfo['poster_path'],
      contentRating: filmInfo['content_rating'],
      trailer: filmInfo['trailer'],
      genres: [],
      seasons: [],
      reviews: [],
    );

    // print('backdrop_path = ${_film!['backdrop_path']}');
    final List<dynamic> genresData = await supabase.from('film_genre').select('genre(*)').eq('film_id', filmId);

    for (var genreRow in genresData) {
      selectedFilm.genres.add(
        Genre(
          genreId: genreRow['genre']['id'],
          name: genreRow['genre']['name'],
        ),
      );
    }

    // print(_film.genres.length);

    final List<dynamic> seasonsData =
        await supabase.from('season').select('id, name, episode(*)').eq('film_id', filmId).order('id', ascending: true).order('order', referencedTable: 'episode', ascending: true);

    for (var seasonRow in seasonsData) {
      final season = Season(
        seasonId: seasonRow['id'],
        name: seasonRow['name'],
        episodes: [],
      );

      final List<dynamic> episodesData = seasonRow['episode'];
      // print(episodesData);

      for (final episodeRow in episodesData) {
        season.episodes.add(
          Episode(
            episodeId: episodeRow['id'],
            order: episodeRow['order'],
            stillPath: episodeRow['still_path'],
            title: episodeRow['title'],
            runtime: episodeRow['runtime'],
            subtitle: episodeRow['subtitle'],
            linkEpisode: episodeRow['link'],
            isFree: episodeRow['is_free'],
          ),
        );
      }

      selectedFilm.seasons.add(season);
    }
    // print(_film.seasons.length);

    final List<dynamic> reviewsData = await supabase.from('review').select('user_id, star, content, created_at, profile(full_name, avatar_url)').eq('film_id', filmId);

    // print(reviewsData);

    for (var element in reviewsData) {
      selectedFilm.reviews.add(
        ReviewFilm(
          userId: element['user_id'],
          hoTen: element['profile']['full_name'],
          avatarUrl: element['profile']['avatar_url'],
          star: element['star'],
          content: element['content'],
          createAt: vnDateFormat.parse(element['created_at']),
        ),
      );
    }

    selectedFilm.reviews.sort((a, b) => b.createAt.compareTo(a.createAt));

    return selectedFilm;
  }
}
