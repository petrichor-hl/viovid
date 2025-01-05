import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/dashboard_management/dtos/top_view_film_dto.dart';

class TopFilmListService {
  TopFilmListService(this.dio);

  final Dio dio;

  Future<List<TopViewFilmDto>> getTopViewFilms(int num) async {
    try {
      return await ApiClient(dio).request<void, List<TopViewFilmDto>>(
        url: '/Dashboard/top-views?Count=$num',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((account) => TopViewFilmDto.fromMap(account))
            .toList(),
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
