class TopicDto {
  String topicId;
  String name;

  TopicDto({
    required this.topicId,
    required this.name,
  });

  factory TopicDto.fromJson(Map<String, dynamic> json) {
    return TopicDto(
      topicId: json['topicId'],
      name: json['name'],
    );
  }
}
