import 'package:viovid/features/topic_management/dtos/simple_film.dart';

class FilmManagementState {
  final bool isLoading;
  final List<SimpleFilm>? films;
  final String errorMessage;

  FilmManagementState({
    this.isLoading = false,
    this.films,
    this.errorMessage = "",
  });

  FilmManagementState copyWith({
    bool? isLoading,
    List<SimpleFilm>? films,
    String? errorMessage,
  }) {
    return FilmManagementState(
      isLoading: isLoading ?? this.isLoading,
      films: films ?? this.films,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
