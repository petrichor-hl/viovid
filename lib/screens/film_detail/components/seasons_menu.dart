import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/models/season.dart';

class SeasonsMenu extends StatelessWidget {
  const SeasonsMenu({
    super.key,
    required this.currentSeasonIndex,
    required this.seasons,
    required this.onChangedSeason,
  });

  final int currentSeasonIndex;
  final List<Season> seasons;
  final void Function(int seasonIndex) onChangedSeason;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      offset: const Offset(0, 2),
      color: const Color(0xFF333333),
      surfaceTintColor: Colors.transparent,
      itemBuilder: (ctx) => List.generate(
        seasons.length,
        (index) => PopupMenuItem(
          onTap: () => onChangedSeason(index),
          child: Text(
            seasons[index].name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      tooltip: '',
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 24,
        ),
        child: Row(
          children: [
            Text(
              seasons[currentSeasonIndex].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
