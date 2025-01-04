import 'package:viovid/features/topic_management/dtos/simple_film.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class TopicDetailDto extends TopicDto {
  List<SimpleFilm> films;

  TopicDetailDto({
    required super.topicId,
    required super.name,
    required this.films,
  });

  factory TopicDetailDto.fromJson(Map<String, dynamic> json) {
    return TopicDetailDto(
      topicId: json['topicId'],
      name: json['name'],
      films: (json['films'] as List)
          .map((film) => SimpleFilm.fromJson(film))
          .toList(),
    );
  }
}
