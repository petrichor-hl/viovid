import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/config/api.config.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';

class UpdateListTopicDialog extends StatefulWidget {
  const UpdateListTopicDialog({
    super.key,
    required this.selectedTopics,
  });

  final List<TopicDto> selectedTopics;

  @override
  State<UpdateListTopicDialog> createState() => _UpdateListTopicDialogState();
}

class _UpdateListTopicDialogState extends State<UpdateListTopicDialog> {
  Future<List<TopicDto>> _getTopicList() async {
    try {
      return await ApiClient(dio).request<void, List<TopicDto>>(
        url: '/Topic',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((topic) => TopicDto.fromJson(topic))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
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
          future: _getTopicList(),
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

  Widget _buildUpdateListFilmTopicDialog(List<TopicDto> allTopics) {
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
                  'Chỉnh sửa danh sách Topic',
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
              child: ListView(
                shrinkWrap: true,
                children: allTopics
                    .map(
                      (topic) => CheckboxListTile(
                        value: widget.selectedTopics.any(
                          (selectedTopic) =>
                              selectedTopic.topicId == topic.topicId,
                        ),
                        title: Text(topic.name),
                        onChanged: (isChecked) {
                          setState(() {
                            if (isChecked == true) {
                              // Thêm phim vào danh sách nếu được chọn
                              widget.selectedTopics.add(topic);
                            } else {
                              // Xóa phim khỏi danh sách nếu bỏ chọn
                              widget.selectedTopics.removeWhere(
                                (selectedTopic) =>
                                    selectedTopic.topicId == topic.topicId,
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
              onPressed: () => context.pop(),
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
