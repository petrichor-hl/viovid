import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/features/film_management/dtos/create_film_dto.dart';
import 'package:viovid/screens/admin/film_management/create_film/components/episode_input.dart';

class SeasonInput extends StatefulWidget {
  const SeasonInput({
    super.key,
    required this.seasonIndex,
    required this.createSeasonData,
    required this.onDelete,
  });

  final int seasonIndex;
  final CreateSeasonDto createSeasonData;
  final void Function() onDelete;

  @override
  State<SeasonInput> createState() => _SeasonInputState();
}

class _SeasonInputState extends State<SeasonInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.black),
                decoration: _createInputDecoration(
                  'Tiêu đề Mùa ${widget.seasonIndex + 1}',
                ),
                onChanged: (value) => widget.createSeasonData.name = value,
              ),
            ),
            FilledButton(
              onPressed: widget.onDelete,
              style: FilledButton.styleFrom(
                fixedSize: const Size(120, 48),
                foregroundColor: Colors.white,
                backgroundColor: adminPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xoá mùa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        ...List.generate(
          widget.createSeasonData.episodes.length,
          (episodeIndex) {
            return EpisodeInput(
              key: ObjectKey(widget.createSeasonData.episodes[episodeIndex]),
              episodeIndex: episodeIndex,
              createEpisodeDto: widget.createSeasonData.episodes[episodeIndex],
              onDelete: () => setState(() {
                widget.createSeasonData.episodes.removeAt(episodeIndex);
              }),
            );
          },
        ),
        OutlinedButton(
          onPressed: () => setState(() {
            widget.createSeasonData.episodes.add(
              CreateEpisodeDto.init(),
            );
          }),
          style: OutlinedButton.styleFrom(
            foregroundColor: adminPrimaryColor,
            backgroundColor: adminPrimaryColor.withAlpha(20),
            side: const BorderSide(
              color: adminPrimaryColor,
              width: 1,
            ),
          ),
          child: const Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: adminPrimaryColor,
              ),
              Text(
                'Thêm tập',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  InputDecoration _createInputDecoration(String hintText) {
    return InputDecoration(
      labelText: hintText,
      floatingLabelStyle: const TextStyle(color: adminPrimaryColor),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.black54,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 14,
      ),
    );
  }
}
