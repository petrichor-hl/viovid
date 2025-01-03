import 'package:viovid/features/topic_management/dtos/simple_film.dart';

class TopicDto {
  String topicId;
  String name;
  List<SimpleFilm> films;

  TopicDto({
    required this.topicId,
    required this.name,
    required this.films,
  });

  factory TopicDto.fromJson(Map<String, dynamic> json) {
    return TopicDto(
      topicId: json['topicId'],
      name: json['name'],
      films: (json['films'] as List)
          .map((film) => SimpleFilm.fromJson(film))
          .toList(),
    );
  }
}
