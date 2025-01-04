import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/components/confirm_dialog.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/film_management/cubit/film_management_cubit.dart';
import 'package:viovid/features/film_management/cubit/film_management_state.dart';
import 'package:viovid/features/topic_management/dtos/simple_film.dart';

class FilmManagementScreen extends StatefulWidget {
  const FilmManagementScreen({super.key});

  @override
  State<FilmManagementScreen> createState() => _FilmManagementScreenState();
}

class _FilmManagementScreenState extends State<FilmManagementScreen> {
  final TextEditingController _controller = TextEditingController();

  void handleSearch() async {
    context
        .read<FilmManagementCubit>()
        .getFilmList(searchText: _controller.text);
  }

  @override
  void initState() {
    super.initState();
    context.read<FilmManagementCubit>().getFilmList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilmManagementCubit, FilmManagementState>(
      listenWhen: (previous, current) => current.errorMessage.isNotEmpty,
      listener: (ctx, state) {
        if (state.errorMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => ErrorDialog(errorMessage: state.errorMessage),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return _buildInProgressWidget();
        }
        if (state.films != null) {
          return _buildFilmManagement(state.films!);
        }
        if (state.errorMessage.isNotEmpty) {
          return _buildFailureWidget(state.errorMessage);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildInProgressWidget() {
    return const Column(
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
    );
  }

  Widget _buildFailureWidget(String errorMessage) {
    return Center(
      child: Padding(
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
      ),
    );
  }

  Widget _buildFilmManagement(List<SimpleFilm> films) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () => context.push('/admin/film-management/add'),
                style: IconButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF695CFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Thêm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm ...',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    border: MaterialStateOutlineInputBorder.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.focused)) {
                          return const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Color(0xFF695CFE), width: 2),
                          );
                        } else if (states.contains(WidgetState.hovered)) {
                          return OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                                color: const Color(0xFF695CFE).withOpacity(0.3),
                                width: 1),
                          );
                        }
                        return const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(color: Colors.black),
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                  onEditingComplete: handleSearch,
                ),
              ),
              const Gap(8),
              IconButton(
                onPressed: handleSearch,
                style: IconButton.styleFrom(
                  fixedSize: const Size(80, 48),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF695CFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.search_rounded,
                  size: 28,
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(
            child: films.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Danh sách Phim rỗng!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 225,
                      childAspectRatio: 3 / 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    children: List.generate(
                      films.length,
                      (index) => DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: films[index].posterPath,
                                height: 275,
                                width: 225,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              child: Row(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        films[index].name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (ctx) => ConfirmDialog(
                                        confirmMessage:
                                            'Bạn có chắc muốn xoá Phim này không',
                                        onConfirm: () {
                                          context
                                              .read<FilmManagementCubit>()
                                              .deleteFilm(
                                                films[index].filmId,
                                              );
                                        },
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      iconColor: WidgetStateColor.resolveWith(
                                        (state) {
                                          if (state
                                              .contains(WidgetState.hovered)) {
                                            return Colors.red;
                                          }
                                          return Colors.black45;
                                        },
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
