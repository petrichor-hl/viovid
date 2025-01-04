import 'dart:developer';

import 'package:viovid/features/result_type.dart';
import 'package:viovid/features/topic_detail/data/topic_detail_api_service.dart';
import 'package:viovid/features/topic_management/dtos/topic_detail_dto.dart';

class TopicDetailRepository {
  final TopicDetailApiService topicDetailApiService;

  TopicDetailRepository({
    required this.topicDetailApiService,
  });

  Future<Result<TopicDetailDto>> getTopicDetail(String topicId) async {
    try {
      return Success(
        await topicDetailApiService.getTopicDetail(topicId),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<TopicDetailDto>> updateListFilm(
    String topicId,
    List<String> filmIds,
  ) async {
    try {
      return Success(
        await topicDetailApiService.updateListFilm(topicId, filmIds),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> deleteFilmInTopic(
    String topicId,
    String filmId,
  ) async {
    try {
      return Success(
        await topicDetailApiService.deleteFilmInTopic(topicId, filmId),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
