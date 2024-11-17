import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/bloc/repositories/selected_film_repo.dart';
import 'package:viovid/models/film.dart';

class EditFilm extends StatefulWidget {
  const EditFilm({
    super.key,
    required this.filmId,
  });

  final String filmId;

  @override
  State<EditFilm> createState() => _EditFilmState();
}

class _EditFilmState extends State<EditFilm> {
  late final Film selectedFilm;

  late final _futureFilm = _fetchFilm('');
  Future<void> _fetchFilm(String searchText) async {
    await context.read<SelectedFilmRepo>().fetchFilm(widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureFilm,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Có lỗi xảy ra khi truy vấn thông tin phim',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Column(
          children: [
            Text(widget.filmId),
          ],
        );
      },
    );
  }
}
