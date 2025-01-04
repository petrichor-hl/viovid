class SimpleFilm {
  String filmId;
  String name;
  String posterPath;

  SimpleFilm({
    required this.filmId,
    required this.name,
    required this.posterPath,
  });

  factory SimpleFilm.fromJson(Map<String, dynamic> json) {
    return SimpleFilm(
      filmId: json['filmId'],
      name: json['name'],
      posterPath: json['posterPath'],
    );
  }
}
