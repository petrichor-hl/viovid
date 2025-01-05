import 'package:viovid/features/dashboard_management/dtos/top_view_film_dto.dart';

class TopFilmListState {
  final bool isLoading;
  final List<TopViewFilmDto>? topViewFilms;
  final String errorMessage;

  TopFilmListState({
    this.isLoading = false,
    this.topViewFilms,
    this.errorMessage = "",
  });

  TopFilmListState copyWith({
    bool? isLoading,
    List<TopViewFilmDto>? topViewFilms,
    String? errorMessage,
  }) {
    return TopFilmListState(
      isLoading: isLoading ?? this.isLoading,
      topViewFilms: topViewFilms ?? this.topViewFilms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
