import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/components/confirm_dialog.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/topic_detail/cubit/topic_detail_cubit.dart';
import 'package:viovid/features/topic_detail/cubit/topic_detail_state.dart';
import 'package:viovid/features/topic_management/dtos/topic_detail_dto.dart';
import 'package:viovid/screens/admin/topic_management/topic_detail/components/update_list_film_topic_dialog.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({
    super.key,
    required this.topicId,
  });

  final String topicId;

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TopicDetailCubit>().getTopicDetail(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopicDetailCubit, TopicDetailState>(
      listenWhen: (previous, current) => current.errorMessage.isNotEmpty,
      listener: (ctx, state) {
        if (state.errorMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => ErrorDialog(errorMessage: state.errorMessage),
          );
        }
      },
      builder: (ctx, state) {
        if (state.isLoading) {
          return _buildInProgressWidget();
        }
        if (state.topicDetail != null) {
          return _buildTopicDetail(context, state.topicDetail!);
        }
        if (state.errorMessage.isNotEmpty) {
          return _buildFailureWidget(state.errorMessage);
        }
        if (state.topicDetail == null) {
          return _buildFailureWidget('Không tìm thấy Topic');
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

  Widget _buildTopicDetail(BuildContext context, TopicDetailDto topicDetail) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: Text(
                  topicDetail.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    // color: Colors.white,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => BlocProvider.value(
                      value: context.read<TopicDetailCubit>(),
                      child: const UpdateListFilmTopicDialog(),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF695CFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_rounded),
                    Text(
                      'Chỉnh sửa Danh sách Phim',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: topicDetail.films.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Topic ${topicDetail.name} chưa có Phim nào!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                      topicDetail.films.length,
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
                                imageUrl: topicDetail.films[index].posterPath,
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
                                        topicDetail.films[index].name,
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
                                            'Bạn có chắc muốn xoá Phim này\nkhỏi Topic ${topicDetail.name} không',
                                        onConfirm: () {
                                          context
                                              .read<TopicDetailCubit>()
                                              .deleteFilmInTopic(
                                                topicDetail.topicId,
                                                topicDetail.films[index].filmId,
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
          ),
        ],
      ),
    );
  }
}
