import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/result_type.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_state.dart';
import 'package:viovid/features/topic_management/data/topic_management_repository.dart';

class TopicManagementCubit extends Cubit<TopicManagementState> {
  final TopicManagementRepository topicManagementRepository;

  TopicManagementCubit(this.topicManagementRepository)
      : super(TopicManagementState());

  Future<void> getTopicList() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicManagementRepository.getTopicList();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topics: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> reorderTopic(int oldIndex, int newIndex) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result =
        await topicManagementRepository.reorderTopic(oldIndex, newIndex);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topics: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> addNewTopic(String topicName) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicManagementRepository.addNewTopic(topicName);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topics: [...?state.topics, result.data],
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> deleteTopic(String topicId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicManagementRepository.deleteTopic(topicId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topics: state.topics
                ?.where((topic) => topic.topicId != topicId)
                .toList(),
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }
}
