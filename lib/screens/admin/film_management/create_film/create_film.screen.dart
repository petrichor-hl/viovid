import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/config/api.config.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/film_management/dtos/create_film_dto.dart';
import 'package:viovid/screens/admin/film_management/create_film/components/genre_input.dart';
import 'package:viovid/screens/admin/film_management/create_film/components/season_input.dart';
import 'package:viovid/screens/admin/film_management/create_film/components/topic_input.dart';

class CreateFilmScreen extends StatefulWidget {
  const CreateFilmScreen({super.key});

  @override
  State<CreateFilmScreen> createState() => _CreateFilmScreenState();
}

class _CreateFilmScreenState extends State<CreateFilmScreen> {
  //
  final _createFilmData = CreateFilmDto.init();
  bool _isLoading = false;

  void handleCreateFilm() async {
    // print(jsonEncode(_createFilmData));
    try {
      setState(() {
        _isLoading = true;
      });

      if (DateTime.tryParse(_createFilmData.releaseDate) == null) {
        showDialog(
          context: context,
          builder: (ctx) => const ErrorDialog(
            errorMessage: 'Ngày phát hành không đúng định dạng\nYYYY/MM/DD',
          ),
        );
        return;
      }

      for (var season in _createFilmData.seasons) {
        for (int episodeIndex = 0;
            episodeIndex < season.episodes.length;
            episodeIndex++) {
          if (season.episodes[episodeIndex].duration == -1) {
            showDialog(
              context: context,
              builder: (ctx) => ErrorDialog(
                errorMessage:
                    'Thời lượng tập phim thứ ${episodeIndex + 1}\nkhông hợp lệ',
              ),
            );
            return;
          }
        }
      }

      await ApiClient(dio).request<void, dynamic>(
        url: '/Film',
        method: ApiMethod.post,
        payload: _createFilmData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Tạo Phim mới thành công.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
            width: 300,
          ),
        );
        context.pop('ABCXYZ');
      }
    } catch (error) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => ErrorDialog(
            errorMessage: error.toString(),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'THÊM PHIM MỚI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    // color: Colors.white,
                  ),
                ),
                const Gap(20),
                _buildCommonFilmInfoForm(),
                const Divider(
                  thickness: 2,
                  color: Color(0xFFE0E2F8),
                  height: 40,
                ),
                _buildSeasonInfoForm(),
                const Divider(
                  thickness: 2,
                  color: Color(0xFFE0E2F8),
                  height: 40,
                ),
                GenreInput(
                  genreIds: _createFilmData.genreIds,
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xFFE0E2F8),
                  height: 40,
                ),
                TopicInput(
                  topicIds: _createFilmData.topicIds,
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xFFE0E2F8),
                  height: 40,
                ),
                const Gap(20),
                FilledButton(
                  onPressed: handleCreateFilm,
                  style: FilledButton.styleFrom(
                    fixedSize: const Size.fromHeight(48),
                    foregroundColor: Colors.white,
                    backgroundColor: adminPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tạo phim',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            width: double.infinity,
            color: Colors.white54,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Gap(14),
                Text(
                  'Đang xử lý ...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(50),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildCommonFilmInfoForm() {
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFE0E2F8),
                image: _createFilmData.backdropPath.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(_createFilmData.backdropPath),
                      )
                    : null,
              ),
              width: double.infinity,
              child: const AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                  child: Text(
                    'Backdrop',
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: 32,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 40,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 8,
                    color: Colors.white,
                  ),
                  color: const Color(0xFFE0E2F8),
                  image: _createFilmData.posterPath.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_createFilmData.posterPath),
                        )
                      : null,
                ),
                width: 220,
                child: const AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Center(
                    child: Text(
                      'Poster',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'I. Thông tin chung',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: _createInputDecoration('Tên phim'),
          onChanged: (value) => _createFilmData.name = value,
        ),
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: _createInputDecoration('Tổng quan'),
          onChanged: (value) => _createFilmData.overview = value,
        ),
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: _createInputDecoration('Poster'),
          onChanged: (value) => _createFilmData.posterPath = value,
          onEditingComplete: () => setState(() {}),
        ),
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: _createInputDecoration('Backdrop'),
          onChanged: (value) => _createFilmData.backdropPath = value,
          onEditingComplete: () => setState(() {}),
        ),
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: _createInputDecoration('Content Rating'),
          onChanged: (value) => _createFilmData.contentRating = value,
        ),
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: _createInputDecoration('Ngày phát hành: YYYY/MM/DD'),
          onChanged: (value) => _createFilmData.releaseDate = value,
        ),
      ],
    );
  }

  Widget _buildSeasonInfoForm() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'II. Mùa phim',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        ...List.generate(
          _createFilmData.seasons.length,
          (seasonIndex) => SeasonInput(
            key: ObjectKey(_createFilmData.seasons[seasonIndex]),
            seasonIndex: seasonIndex,
            createSeasonData: _createFilmData.seasons[seasonIndex],
            onDelete: () => setState(() {
              _createFilmData.seasons.removeAt(seasonIndex);
            }),
          ),
        ),
        OutlinedButton(
          onPressed: () => setState(() {
            _createFilmData.seasons.add(
              CreateSeasonDto.init(),
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
                'Thêm mùa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
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
