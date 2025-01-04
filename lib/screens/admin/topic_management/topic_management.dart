import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_cubit.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_state.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';
import 'package:viovid/screens/admin/topic_management/components/add_topic_dialog.dart';
import 'package:viovid/screens/admin/topic_management/components/topic_item.dart';

class TopicManagementScreen extends StatefulWidget {
  const TopicManagementScreen({super.key});

  @override
  State<TopicManagementScreen> createState() => _TopicManagementScreenState();
}

class _TopicManagementScreenState extends State<TopicManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TopicManagementCubit>().getTopicList();
  }

  void updateOrder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex--;
    }

    print("oldIndex = $oldIndex");
    print("newIndex = $newIndex");

    context.read<TopicManagementCubit>().reorderTopic(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopicManagementCubit, TopicManagementState>(
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
        if (state.topics != null) {
          return _buildTopicManagement(state.topics!);
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

  Widget _buildTopicManagement(List<TopicDto> topics) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: context.read<TopicManagementCubit>(),
                  child: AddTopicDialog(),
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
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded),
                Text(
                  'Thêm Topic',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: updateOrder,
              children: [
                for (final topic in topics)
                  TopicItem(
                    key: ValueKey(topic.topicId),
                    topic: topic,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
