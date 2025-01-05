import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/features/topic_management/dtos/topic_dto.dart';
import 'package:viovid/screens/admin/film_management/create_film/components/update_list_topic_dialog.dart';

class TopicInput extends StatefulWidget {
  const TopicInput({
    super.key,
    required this.topicIds,
  });

  final List<String> topicIds;

  @override
  State<TopicInput> createState() => _TopicInputState();
}

class _TopicInputState extends State<TopicInput> {
  //
  Color _borderColors = Colors.black26;
  //
  final List<TopicDto> _selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'IV. Topic',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (ctx) => UpdateListTopicDialog(
                selectedTopics: _selectedTopics,
              ),
            );

            setState(() {
              widget.topicIds.clear();
              widget.topicIds.addAll(
                _selectedTopics.map((topic) => topic.topicId),
              );
            });
          },
          child: MouseRegion(
            onEnter: (event) => setState(() {
              _borderColors = const Color(0xFF695CFE).withOpacity(0.3);
            }),
            onExit: (event) => setState(() {
              _borderColors = Colors.black26;
            }),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 58,
                minWidth: double.infinity,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: _borderColors,
                ),
              ),
              child: _selectedTopics.isEmpty
                  ? const Center(
                      child: Text(
                        'Chọn Topic',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 8.0, // Khoảng cách giữa các Chip
                      runSpacing: 8.0, // Khoảng cách giữa các hàng
                      children: _selectedTopics.map((topic) {
                        return Chip(
                          label: Text(
                            topic.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: adminPrimaryColor,
                          onDeleted: () {
                            setState(() {
                              _selectedTopics.remove(topic);
                            });
                          },
                          side: BorderSide.none,
                          deleteIconColor: Colors.white,
                        );
                      }).toList(),
                    ),
            ),
          ),
        )
      ],
    );
  }
}
