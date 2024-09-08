import 'package:viovid/models/episode.dart';

class Season {
  String seasonId;
  String name;
  List<Episode> episodes;

  Season({
    required this.seasonId,
    required this.name,
    required this.episodes,
  });
}
