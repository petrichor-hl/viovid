import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/film_management/cubit/film_management_state.dart';
import 'package:viovid/features/film_management/data/film_management_repository.dart';
import 'package:viovid/features/result_type.dart';

class FilmManagementCubit extends Cubit<FilmManagementState> {
  final FilmManagementRepository topicManagementRepository;

  FilmManagementCubit(this.topicManagementRepository)
      : super(FilmManagementState());

  Future<void> getFilmList({String? searchText}) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicManagementRepository.getFilmList(
      searchText: searchText,
    );
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            films: result.data.items,
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

  Future<void> deleteFilm(String filmId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topicManagementRepository.deleteFilm(filmId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            films: state.films?.where((film) => film.filmId != filmId).toList(),
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
