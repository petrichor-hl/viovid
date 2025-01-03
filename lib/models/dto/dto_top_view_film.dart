class DtoTopViewFilm {
  final int numberOfViews;
  final String filmId;
  final String name;
  final String posterPath;

  const DtoTopViewFilm({
    required this.numberOfViews,
    required this.filmId,
    required this.name,
    required this.posterPath,
  });

  factory DtoTopViewFilm.fromMap(Map<String, dynamic> map) {
    return DtoTopViewFilm(
      numberOfViews: map['numberOfViews'],
      filmId: map['filmId'],
      name: map['name'],
      posterPath: map['posterPath'],
    );
  }
}
