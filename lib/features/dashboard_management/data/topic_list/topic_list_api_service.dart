import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/dashboard_management/dtos/browse_topic_dto.dart';

class TopicListApiService {
  TopicListApiService(this.dio);

  final Dio dio;

  Future<List<BrowseTopicDto>> getBrowseTopicList() async {
    try {
      return await ApiClient(dio).request<void, List<BrowseTopicDto>>(
        url: '/Topic/browse',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((topic) => BrowseTopicDto.fromJson(topic))
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
