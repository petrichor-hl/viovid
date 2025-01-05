import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/topic_management/dtos/simple_film.dart';
import 'package:viovid/models/paging.dart';

class FilmManagementApiService {
  FilmManagementApiService(this.dio);

  final Dio dio;

  Future<Paging<SimpleFilm>> getFilmList({String? searchText}) async {
    try {
      return await ApiClient(dio).request<void, Paging<SimpleFilm>>(
        url: '/Film',
        queryParameters: {
          "searchText": searchText,
          "pageIndex": 0,
          "pageSize": 40,
        },
        method: ApiMethod.get,
        fromJson: (resultJson) => Paging.fromJson(
            resultJson, (filmJson) => SimpleFilm.fromJson(filmJson)),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> deleteFilm(String filmId) async {
    try {
      return await ApiClient(dio).request<void, String>(
        url: '/Film/$filmId',
        method: ApiMethod.delete,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
