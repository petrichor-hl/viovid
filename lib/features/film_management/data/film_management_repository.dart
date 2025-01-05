import 'dart:developer';

import 'package:viovid/features/film_management/data/film_management_api_service.dart';
import 'package:viovid/features/result_type.dart';
import 'package:viovid/features/topic_management/dtos/simple_film.dart';
import 'package:viovid/models/paging.dart';

class FilmManagementRepository {
  final FilmManagementApiService topicManagementApiService;

  FilmManagementRepository({
    required this.topicManagementApiService,
  });

  Future<Result<Paging<SimpleFilm>>> getFilmList({String? searchText}) async {
    try {
      return Success(
        await topicManagementApiService.getFilmList(searchText: searchText),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> deleteFilm(String filmId) async {
    try {
      return Success(
        await topicManagementApiService.deleteFilm(filmId),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
