import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/result_type.dart';
import 'package:viovid/features/topic_detail/cubit/topic_detail_state.dart';
import 'package:viovid/features/topic_detail/data/topic_detail_repository.dart';
import 'package:viovid/features/topic_management/dtos/topic_detail_dto.dart';

class TopicDetailCubit extends Cubit<TopicDetailState> {
  final TopicDetailRepository topicDetailRepository;

  TopicDetailCubit(this.topicDetailRepository) : super(TopicDetailState());

  Future<void> getTopicDetail(
    String topicId,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicDetailRepository.getTopicDetail(topicId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topicDetail: result.data,
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

  Future<void> updateListFilm(
    String topicId,
    List<String> filmIds,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicDetailRepository.updateListFilm(topicId, filmIds);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topicDetail: result.data,
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

  Future<void> deleteFilmInTopic(
    String topicId,
    String deleteFilmId,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicDetailRepository.deleteFilmInTopic(
      topicId,
      deleteFilmId,
    );
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topicDetail: TopicDetailDto(
              topicId: topicId,
              name: state.topicDetail!.name,
              films: state.topicDetail!.films
                  .where((film) => film.filmId != deleteFilmId)
                  .toList(),
            ),
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
