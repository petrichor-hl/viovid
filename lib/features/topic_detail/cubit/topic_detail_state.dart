import 'package:viovid/features/topic_management/dtos/topic_detail_dto.dart';

class TopicDetailState {
  final bool isLoading;
  final TopicDetailDto? topicDetail;
  final String errorMessage;

  TopicDetailState({
    this.isLoading = false,
    this.topicDetail,
    this.errorMessage = "",
  });

  TopicDetailState copyWith({
    bool? isLoading,
    TopicDetailDto? topicDetail,
    String? errorMessage,
  }) {
    return TopicDetailState(
      isLoading: isLoading ?? this.isLoading,
      topicDetail: topicDetail ?? this.topicDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
