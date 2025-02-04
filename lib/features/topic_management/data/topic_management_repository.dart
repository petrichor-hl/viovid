import 'dart:developer';

import 'package:viovid/features/result_type.dart';
import 'package:viovid/features/topic_management/data/topic_management_api_service.dart';
import 'package:viovid/features/topic_management/dtos/reorder_topics_dto.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class TopicManagementRepository {
  final TopicManagementApiService topicManagementApiService;

  TopicManagementRepository({
    required this.topicManagementApiService,
  });

  Future<Result<List<TopicDto>>> getTopicList() async {
    try {
      return Success(await topicManagementApiService.getTopicList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<List<TopicDto>>> reorderTopic(
    int oldIndex,
    int newIndex,
  ) async {
    try {
      return Success(
        await topicManagementApiService.reorderTopic(
          ReorderTopicsDto(
            oldIndex: oldIndex,
            newIndex: newIndex,
          ),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<TopicDto>> addNewTopic(String topicName) async {
    try {
      return Success(
        await topicManagementApiService.addNewTopic(topicName),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> editTopic(
    String editedTopicId,
    String editedTopicName,
  ) async {
    try {
      return Success(
        await topicManagementApiService.editTopic(
            editedTopicId, editedTopicName),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> deleteTopic(String topicId) async {
    try {
      return Success(
        await topicManagementApiService.deleteTopic(topicId),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
