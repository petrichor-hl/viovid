import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/features/film_management/dtos/create_film_dto.dart';

class EpisodeInput extends StatefulWidget {
  const EpisodeInput({
    super.key,
    required this.episodeIndex,
    required this.createEpisodeDto,
    required this.onDelete,
  });

  final int episodeIndex;
  final CreateEpisodeDto createEpisodeDto;
  final void Function() onDelete;

  @override
  State<EpisodeInput> createState() => _EpisodeInputState();
}

class _EpisodeInputState extends State<EpisodeInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          height: 360, // == Expanded (line 38) rendered Height
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange.shade300,
          ),
          child: Center(
            child: Text(
              'Thông tin\nTập ${widget.episodeIndex + 1}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: _createInputDecoration(
                  'Tiêu đề tập ${widget.episodeIndex + 1}',
                ),
                onChanged: (value) => widget.createEpisodeDto.title = value,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: _createInputDecoration(
                  'Tóm tắt',
                ),
                onChanged: (value) => widget.createEpisodeDto.summary = value,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: _createInputDecoration(
                  'Source',
                ),
                onChanged: (value) => widget.createEpisodeDto.source = value,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: _createInputDecoration(
                  'Thời lượng',
                ),
                onChanged: (value) => widget.createEpisodeDto.duration =
                    int.tryParse(value) ?? -1,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: _createInputDecoration(
                  'StillPath',
                ),
                onChanged: (value) => widget.createEpisodeDto.stillPath = value,
              ),
              Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Được xem miễn phí: ',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    activeTrackColor: const Color(0xFF695CFE),
                    inactiveTrackColor: const Color(0xFFE0E2F8),
                    value: widget.createEpisodeDto.isFree,
                    onChanged: (isActive) => setState(() {
                      widget.createEpisodeDto.isFree = isActive;
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 360, // == Expanded (line 38) rendered Height
          width: 120,
          child: OutlinedButton(
            onPressed: widget.onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: adminPrimaryColor,
              backgroundColor: adminPrimaryColor.withAlpha(20),
              side: const BorderSide(
                color: adminPrimaryColor,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.delete,
              size: 24,
              color: adminPrimaryColor,
            ),
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
