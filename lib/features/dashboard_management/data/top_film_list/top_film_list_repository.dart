import 'dart:developer';
import 'package:viovid/features/dashboard_management/data/top_film_list/top_film_list_api_service.dart';
import 'package:viovid/features/dashboard_management/dtos/top_view_film_dto.dart';
import 'package:viovid/features/result_type.dart';

class TopFilmListRepository {
  final TopFilmListService topFlimsListService;

  TopFilmListRepository({
    required this.topFlimsListService,
  });

  Future<Result<List<TopViewFilmDto>>> getTopViewFilms(int year) async {
    try {
      return Success(await topFlimsListService.getTopViewFilms(year));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
