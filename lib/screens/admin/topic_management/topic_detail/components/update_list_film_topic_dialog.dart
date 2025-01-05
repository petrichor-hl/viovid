import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/config/api.config.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/topic_detail/cubit/topic_detail_cubit.dart';
import 'package:viovid/features/topic_management/dtos/simple_film.dart';
import 'package:viovid/models/paging.dart';

class UpdateListFilmTopicDialog extends StatefulWidget {
  const UpdateListFilmTopicDialog({super.key});

  @override
  State<UpdateListFilmTopicDialog> createState() =>
      _UpdateListFilmTopicDialogState();
}

class _UpdateListFilmTopicDialogState extends State<UpdateListFilmTopicDialog> {
  late final _topicDetail = context.read<TopicDetailCubit>().state.topicDetail!;

  Future<List<SimpleFilm>> _fetchAllFilms() async {
    try {
      final result = await ApiClient(dio).request<void, Paging<SimpleFilm>>(
        url: '/Film',
        method: ApiMethod.get,
        queryParameters: {
          "pageIndex": 0,
          "pageSize": 40,
        },
        fromJson: (resultJson) => Paging.fromJson(
          resultJson,
          (filmJson) => SimpleFilm.fromJson(filmJson),
        ),
      );

      return result.items;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  void _handleUpdateListFilm(List<SimpleFilm> selectedFilms) {
    final updateListFilmId = selectedFilms.map((film) => film.filmId).toList();

    context.read<TopicDetailCubit>().updateListFilm(
          _topicDetail.topicId,
          updateListFilmId,
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: FutureBuilder(
          future: _fetchAllFilms(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildInProgressWidget();
            }

            if (snapshot.hasError) {
              return _buildFailureWidget(snapshot.error.toString());
            }

            if (snapshot.hasData) {
              // print('snapshot.data = ${snapshot.data}');
              return _buildUpdateListFilmTopicDialog(snapshot.data!);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInProgressWidget() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 14,
      children: [
        CircularProgressIndicator(),
        Text(
          'Đang xử lý ...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFailureWidget(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUpdateListFilmTopicDialog(List<SimpleFilm> allFilms) {
    final selectedFilms = _topicDetail.films;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 20,
              children: [
                const Text(
                  'Chỉnh sửa danh sách Phim',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    // color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                )
              ],
            ),
            const Divider(height: 30),
            Flexible(
              // If you want to hide scroll indicator
              // child: ScrollConfiguration(
              //   behavior: const ScrollBehavior().copyWith(scrollbars: false),
              child: ListView(
                children: allFilms
                    .map(
                      (film) => CheckboxListTile(
                        value: selectedFilms.any(
                          (topicFilm) => topicFilm.filmId == film.filmId,
                        ),
                        title: Text(film.name),
                        onChanged: (isChecked) {
                          setState(() {
                            if (isChecked == true) {
                              // Thêm phim vào danh sách nếu được chọn
                              selectedFilms.add(film);
                            } else {
                              // Xóa phim khỏi danh sách nếu bỏ chọn
                              selectedFilms.removeWhere(
                                (topicFilm) => topicFilm.filmId == film.filmId,
                              );
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
                // ),
              ),
            ),
            const Divider(height: 30),
            FilledButton(
              onPressed: () => _handleUpdateListFilm(selectedFilms),
              style: FilledButton.styleFrom(
                fixedSize: const Size.fromHeight(48),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF695CFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
