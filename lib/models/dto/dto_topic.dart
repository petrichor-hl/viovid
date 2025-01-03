import 'package:viovid/models/dto/dto_film.dart';

class DtoTopic {
  String name;
  List<DtoFilms>? films;

  DtoTopic({
    required this.name,
    this.films,
  });
}
