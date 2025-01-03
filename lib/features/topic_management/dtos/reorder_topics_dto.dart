class ReorderTopicsDto {
  final int oldIndex;
  final int newIndex;

  ReorderTopicsDto({
    required this.oldIndex,
    required this.newIndex,
  });

  Map<String, dynamic> toJson() => {
        "oldIndex": oldIndex,
        "newIndex": newIndex,
      };
}
