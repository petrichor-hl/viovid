import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_cubit.dart';
import 'package:viovid/features/topic_management/cubit/topic_management_state.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

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
    return ReorderableListView(
      onReorder: updateOrder,
      padding: const EdgeInsets.all(16),
      children: [
        for (final topic in topics)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 4),
            key: ValueKey(topic.topicId),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              topic.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
