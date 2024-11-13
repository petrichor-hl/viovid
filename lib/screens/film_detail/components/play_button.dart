import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/models/episode.dart';
import 'package:viovid/screens/film_detail/components/promote_dialog.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required this.episode,
  });

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: const Icon(
        Icons.play_arrow_rounded,
        size: 32,
      ),
      onPressed: () {
        if (isNormalUser && !episode.isFree) {
          showDialog(context: context, builder: (ctx) => const PromoteDialog());
        } else {
          final selectedFilm = context.read<SelectedFilmRepo>().selectedFilm;
          context.go(
            '${GoRouterState.of(context).uri}/episode/${episode.episodeId}/watching',
            extra: {
              'filmName': selectedFilm.name,
              'seasons': selectedFilm.seasons,
            },
          );
        }
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
