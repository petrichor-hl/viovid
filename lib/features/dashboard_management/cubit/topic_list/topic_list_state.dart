import 'package:viovid/features/dashboard_management/dtos/browse_topic_dto.dart';

class TopicListState {
  final bool isLoading;
  final List<BrowseTopicDto>? topics;
  final String errorMessage;

  TopicListState({
    this.isLoading = false,
    this.topics,
    this.errorMessage = "",
  });

  TopicListState copyWith({
    bool? isLoading,
    List<BrowseTopicDto>? topics,
    String? errorMessage,
  }) {
    return TopicListState(
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
