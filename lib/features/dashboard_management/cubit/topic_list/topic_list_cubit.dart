import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/dashboard_management/cubit/topic_list/topic_list_state.dart';
import 'package:viovid/features/dashboard_management/data/topic_list/topic_list_repository.dart';
import 'package:viovid/features/result_type.dart';

class TopicListCubit extends Cubit<TopicListState> {
  final TopicListRepository topicManagementRepository;

  TopicListCubit(this.topicManagementRepository) : super(TopicListState());

  Future<void> getBrowseTopicList() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicManagementRepository.getBrowseTopicList();
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
}
