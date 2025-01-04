import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_cubit.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class EditTopicDialog extends StatelessWidget {
  EditTopicDialog({
    super.key,
    required this.topic,
  });

  final TopicDto topic;

  late final _controller = TextEditingController(text: topic.name);

  void handleEditTopic(BuildContext context) async {
    if (_controller.text.isEmpty) {
      return;
    }

    context.read<TopicManagementCubit>().editTopic(
          topic.topicId,
          _controller.text,
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
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chỉnh sửa Topic',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                // color: Colors.white,
              ),
            ),
            const Gap(12),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Nhập tên Topic ở đây',
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
              onEditingComplete: () => handleEditTopic(context),
            ),
            const Gap(20),
            FilledButton(
              onPressed: () => handleEditTopic(context),
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
        ),
      ),
    );
  }
}
