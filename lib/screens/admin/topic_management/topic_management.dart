import 'package:flutter/material.dart';
import 'package:viovid/main.dart';

class TopicManagementScreen extends StatefulWidget {
  const TopicManagementScreen({super.key});

  @override
  State<TopicManagementScreen> createState() => _TopicManagementScreenState();
}

class _TopicManagementScreenState extends State<TopicManagementScreen> {
  late List<Map<String, dynamic>> _topics;
  late final _futureTopics = _fetchTopics();
  Future<void> _fetchTopics() async {
    _topics = await supabase.from('topic').select('id, name').order('order', ascending: true);
  }

  void updateOrder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex--;
    }

    setState(() {
      final item = _topics.removeAt(oldIndex);
      _topics.insert(newIndex, item);
    });

    for (int i = 0; i < _topics.length; ++i) {
      await supabase.from('topic').update({'order': i}).eq('id', _topics[i]['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureTopics,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Có lỗi xảy ra khi truy vấn thông tin phim',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ReorderableListView(
          onReorder: updateOrder,
          padding: const EdgeInsets.all(16),
          children: [
            for (final topic in _topics)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 4),
                key: ValueKey(topic['id']),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  topic['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
