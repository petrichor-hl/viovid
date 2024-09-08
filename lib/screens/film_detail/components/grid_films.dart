import 'package:flutter/material.dart';
import 'package:viovid/models/poster.dart';

class GridFilms extends StatelessWidget {
  const GridFilms({
    super.key,
    required this.posters,
    this.canClick = true,
  });

  final List<Poster> posters;
  final bool canClick;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 225,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: List.generate(
        posters.length,
        (index) {
          // final filmId = posters[index].filmId;
          return GestureDetector(
            onTap: canClick ? () {} : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://image.tmdb.org/t/p/w440_and_h660_face/${posters[index].posterPath}',
              ),
            ),
          );
        },
      ),
    );
  }
}
