import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/topic_management/dtos/reorder_topics_dto.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class TopicManagementApiService {
  TopicManagementApiService(this.dio);

  final Dio dio;

  Future<List<TopicDto>> getTopicList() async {
    try {
      return await ApiClient(dio).request<void, List<TopicDto>>(
        url: '/Topic',
        method: ApiMethod.get,
        fromJson: (resultJson) {
          return (resultJson as List)
              .map((topic) => TopicDto.fromJson(topic))
              .toList();
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<TopicDto>> reorderTopic(ReorderTopicsDto reorderTopicsDto) async {
    try {
      return await ApiClient(dio).request<void, List<TopicDto>>(
        url: '/Topic/re-order',
        method: ApiMethod.post,
        payload: reorderTopicsDto,
        fromJson: (resultJson) {
          return (resultJson as List)
              .map((topic) => TopicDto.fromJson(topic))
              .toList();
        },
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
