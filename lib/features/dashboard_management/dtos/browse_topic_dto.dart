import 'package:viovid/features/topic_management/dtos/simple_film.dart';

class BrowseTopicDto {
  String topicId;
  String name;
  List<SimpleFilm> films;

  BrowseTopicDto({
    required this.topicId,
    required this.name,
    required this.films,
  });

  factory BrowseTopicDto.fromJson(Map<String, dynamic> json) {
    return BrowseTopicDto(
      topicId: json['topicId'],
      name: json['name'],
      films: (json['films'] as List)
          .map((film) => SimpleFilm.fromJson(film))
          .toList(),
    );
  }
}
