class TopViewFilmDto {
  final int numberOfViews;
  final String filmId;
  final String name;
  final String posterPath;

  const TopViewFilmDto({
    required this.numberOfViews,
    required this.filmId,
    required this.name,
    required this.posterPath,
  });

  factory TopViewFilmDto.fromMap(Map<String, dynamic> map) {
    return TopViewFilmDto(
      numberOfViews: map['numberOfViews'],
      filmId: map['filmId'],
      name: map['name'],
      posterPath: map['posterPath'],
    );
  }
}
