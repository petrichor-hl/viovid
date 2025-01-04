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
        fromJson: (resultJson) => (resultJson as List)
            .map((topic) => TopicDto.fromJson(topic))
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

  Future<List<TopicDto>> reorderTopic(ReorderTopicsDto reorderTopicsDto) async {
    try {
      return await ApiClient(dio).request<void, List<TopicDto>>(
        url: '/Topic/re-order',
        method: ApiMethod.post,
        payload: reorderTopicsDto,
        fromJson: (resultJson) => (resultJson as List)
            .map((topic) => TopicDto.fromJson(topic))
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

  Future<TopicDto> addNewTopic(String topicName) async {
    try {
      return await ApiClient(dio).request<void, TopicDto>(
        url: '/Topic',
        method: ApiMethod.post,
        payload: {
          "name": topicName,
        },
        fromJson: (resultJson) => TopicDto.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<bool> editTopic(String editedTopicId, String editedTopicName) async {
    try {
      return await ApiClient(dio).request<void, bool>(
        url: '/Topic/$editedTopicId',
        method: ApiMethod.put,
        payload: {
          "name": editedTopicName,
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

  Future<String> deleteTopic(String topicId) async {
    try {
      return await ApiClient(dio).request<void, String>(
        url: '/Topic/$topicId',
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
