import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/dashboard_management/cubit/top_film_list/top_film_list_state.dart';
import 'package:viovid/features/dashboard_management/data/top_film_list/top_film_list_repository.dart';
import 'package:viovid/features/result_type.dart';

class TopFilmListCubit extends Cubit<TopFilmListState> {
  final TopFilmListRepository topFilmListRepository;

  TopFilmListCubit(this.topFilmListRepository) : super(TopFilmListState());

  Future<void> getUserRegist(int num) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await topFilmListRepository.getTopViewFilms(num);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            topViewFilms: result.data,
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
