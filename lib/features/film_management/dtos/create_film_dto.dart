class CreateFilmDto {
  String name;
  String overview;
  String posterPath;
  String backdropPath;
  String contentRating;
  String releaseDate;
  List<CreateSeasonDto> seasons;
  List<String> genreIds;
  List<String> topicIds;
  List<CreateCastDto> casts;
  List<CreateCrewDto> crews;

  CreateFilmDto({
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.contentRating,
    required this.releaseDate,
    required this.seasons,
    required this.genreIds,
    required this.topicIds,
    required this.casts,
    required this.crews,
  });

  CreateFilmDto.init()
      : name = '',
        overview = '',
        posterPath = '',
        backdropPath = '',
        contentRating = '',
        releaseDate = '',
        seasons = [
          CreateSeasonDto.init(),
        ],
        genreIds = [],
        topicIds = [],
        casts = [],
        crews = [];

  Map<String, dynamic> toJson() => {
        "name": name,
        "overview": overview,
        "posterPath": posterPath,
        "backdropPath": backdropPath,
        "contentRating": contentRating,
        // "releaseDate":
        //     "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "releaseDate": releaseDate,
        "seasons": seasons.map((x) => x.toJson()).toList(),
        "genreIds": genreIds,
        "topicIds": topicIds,
        "casts": casts.map((cast) => cast.toJson()).toList(),
        "crews": crews.map((crew) => crew.toJson()).toList(),
      };
}

class CreateCastDto {
  String personId;
  String character;

  CreateCastDto({
    required this.personId,
    required this.character,
  });

  Map<String, dynamic> toJson() => {
        "personId": personId,
        "character": character,
      };
}

class CreateCrewDto {
  String personId;
  String role;

  CreateCrewDto({
    required this.personId,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "personId": personId,
        "role": role,
      };
}

class CreateSeasonDto {
  String name;
  List<CreateEpisodeDto> episodes;

  CreateSeasonDto({
    required this.name,
    required this.episodes,
  });

  CreateSeasonDto.init()
      : name = '',
        episodes = [
          CreateEpisodeDto.init(),
        ];

  Map<String, dynamic> toJson() => {
        "name": name,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
      };
}

class CreateEpisodeDto {
  String title;
  String summary;
  String source;
  int duration;
  String stillPath;
  bool isFree;

  CreateEpisodeDto({
    required this.title,
    required this.summary,
    required this.source,
    required this.duration,
    required this.stillPath,
    required this.isFree,
  });

  CreateEpisodeDto.init({
    this.title = '',
    this.summary = '',
    this.source = '',
    this.duration = -1,
    this.stillPath = '',
    this.isFree = false,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "summary": summary,
        "source": source,
        "duration": duration,
        "stillPath": stillPath,
        "isFree": isFree,
      };
}
