import 'dart:developer';
import 'package:viovid/features/dashboard_management/data/topic_list/topic_list_api_service.dart';
import 'package:viovid/features/dashboard_management/dtos/browse_topic_dto.dart';
import 'package:viovid/features/result_type.dart';

class TopicListRepository {
  final TopicListApiService topicListApiService;

  TopicListRepository({
    required this.topicListApiService,
  });

  Future<Result<List<BrowseTopicDto>>> getBrowseTopicList() async {
    try {
      return Success(await topicListApiService.getBrowseTopicList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
