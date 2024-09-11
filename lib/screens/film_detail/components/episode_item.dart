import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/models/episode.dart';

class EpisodeItem extends StatelessWidget {
  const EpisodeItem({required this.episode, super.key});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final selectedFilm = context.read<SelectedFilmRepo>().selectedFilm;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () {
          context.go(
            '${GoRouterState.of(context).uri}/episode/${episode.episodeId}/watching',
            extra: {
              'filmName': selectedFilm.name,
              'seasons': selectedFilm.seasons,
            },
          );
        },
        child: Row(
          children: [
            Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF333333),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://www.themoviedb.org/t/p/w454_and_h254_bestv2/${episode.stillPath}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              width: 227,
              height: 127,
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const Gap(24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Text(
                    episode.subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            Text(
              '${episode.runtime} phút',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
