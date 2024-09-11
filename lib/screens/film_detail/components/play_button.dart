import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/season.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.filmName,
    required this.seasons,
    required this.firstEpisodeIdToPlay,
  });

  final String? filmName;
  final List<Season>? seasons;
  final String firstEpisodeIdToPlay;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: const Icon(
        Icons.play_arrow_rounded,
        size: 32,
      ),
      onPressed: () {
        context.go(
          '${GoRouterState.of(context).uri}/episode/$firstEpisodeIdToPlay/watching',
          extra: {
            'filmName': filmName,
            'seasons': seasons,
          },
        );
      },
      label: const Text(
        'Phát',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 30, 16),
      ),
    );
  }
}
