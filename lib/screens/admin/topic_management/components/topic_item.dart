import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/components/confirm_dialog.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_cubit.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({
    super.key,
    required this.topic,
  });

  final TopicDto topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () => context
          .go('${GoRouterState.of(context).uri}/${topic.topicId}', extra: {
        // 'filmName': selectedFilm.name,
        // 'seasons': selectedFilm.seasons,
      }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              topic.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // context.read<TopicManagementCubit>().deleteTopic(topic.topicId);
              },
              style: ButtonStyle(
                iconColor: WidgetStateColor.resolveWith(
                  (state) {
                    if (state.contains(WidgetState.hovered)) {
                      return Colors.green;
                    }
                    return Colors.black45;
                  },
                ),
              ),
              icon: const Icon(
                Icons.edit_rounded,
              ),
            ),
            const Gap(10),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ConfirmDialog(
                    confirmMessage: 'Bạn có chắc muốn xoá Topic này',
                    onConfirm: () => context
                        .read<TopicManagementCubit>()
                        .deleteTopic(topic.topicId),
                  ),
                );
              },
              style: ButtonStyle(
                iconColor: WidgetStateColor.resolveWith(
                  (state) {
                    if (state.contains(WidgetState.hovered)) {
                      return Colors.red;
                    }
                    return Colors.black45;
                  },
                ),
              ),
              icon: const Icon(
                Icons.delete_rounded,
              ),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}
