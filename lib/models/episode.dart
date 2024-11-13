class Episode {
  const Episode({
    required this.episodeId,
    required this.order,
    required this.stillPath,
    required this.title,
    required this.runtime,
    required this.subtitle,
    required this.linkEpisode,
    required this.isFree,
  });

  final String episodeId;
  final int order;
  final String stillPath;
  final String title;
  final int runtime;
  final String subtitle;
  final String linkEpisode;
  final bool isFree;
}
