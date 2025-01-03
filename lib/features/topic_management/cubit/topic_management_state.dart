import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class TopicManagementState {
  final bool isLoading;
  final List<TopicDto>? topics;
  final String errorMessage;

  TopicManagementState({
    this.isLoading = false,
    this.topics,
    this.errorMessage = "",
  });

  TopicManagementState copyWith({
    bool? isLoading,
    List<TopicDto>? topics,
    String? errorMessage,
  }) {
    return TopicManagementState(
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
