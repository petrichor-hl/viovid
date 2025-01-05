import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/features/film_management/dtos/genre_dto.dart';
import 'package:viovid/screens/admin/film_management/create_film/components/update_list_genre_dialog.dart';

class GenreInput extends StatefulWidget {
  const GenreInput({
    super.key,
    required this.genreIds,
  });

  final List<String> genreIds;

  @override
  State<GenreInput> createState() => _GenreInputState();
}

class _GenreInputState extends State<GenreInput> {
  //
  Color _borderColors = Colors.black26;
  //
  final List<GenreDto> _selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'III. Thể loại',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) => UpdateListGenreDialog(
                selectedGenres: _selectedGenres,
              ),
            );

            setState(() {
              widget.genreIds.clear();
              widget.genreIds.addAll(_selectedGenres.map((genre) => genre.id));
            });
          },
          child: MouseRegion(
            onEnter: (event) => setState(() {
              _borderColors = const Color(0xFF695CFE).withOpacity(0.3);
            }),
            onExit: (event) => setState(() {
              _borderColors = Colors.black26;
            }),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 58,
                minWidth: double.infinity,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: _borderColors,
                ),
              ),
              child: _selectedGenres.isEmpty
                  ? const Center(
                      child: Text(
                        'Chọn thể loại',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 8.0, // Khoảng cách giữa các Chip
                      runSpacing: 8.0, // Khoảng cách giữa các hàng
                      children: _selectedGenres.map((genre) {
                        return Chip(
                          label: Text(
                            genre.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: adminPrimaryColor,
                          onDeleted: () {
                            setState(() {
                              _selectedGenres.remove(genre);
                            });
                          },
                          side: BorderSide.none,
                          deleteIconColor: Colors.white,
                        );
                      }).toList(),
                    ),
            ),
          ),
        )
      ],
    );
  }
}
