import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/topic_management/dtos/topic_detail_dto.dart';

class TopicDetailApiService {
  TopicDetailApiService(this.dio);

  final Dio dio;

  Future<TopicDetailDto> getTopicDetail(String topicId) async {
    try {
      return await ApiClient(dio).request<void, TopicDetailDto>(
        url: '/Topic/$topicId',
        method: ApiMethod.get,
        fromJson: (resultJson) => TopicDetailDto.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<TopicDetailDto> updateListFilm(
    String topicId,
    List<String> filmIds,
  ) async {
    try {
      return await ApiClient(dio).request<void, TopicDetailDto>(
        url: '/Topic/$topicId/update-list-film',
        method: ApiMethod.put,
        payload: {
          "filmIds": filmIds,
        },
        fromJson: (resultJson) => TopicDetailDto.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> deleteFilmInTopic(String topicId, String filmId) async {
    try {
      return await ApiClient(dio).request<void, String>(
        url: '/Topic/$topicId/delete-film/$filmId',
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
