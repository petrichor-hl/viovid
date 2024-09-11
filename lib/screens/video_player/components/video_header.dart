import 'package:flutter/material.dart';

class VideoHeader extends StatelessWidget {
  const VideoHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      child: Row(
        children: [
          // Không đồng bộ với route stack của trình duyệt
          // IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_rounded,
          //   ),
          //   onPressed: () {
          //     context.pop();
          //   },
          //   style: IconButton.styleFrom(
          //     iconSize: 40,
          //     foregroundColor: Colors.white,
          //   ),
          // ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // const Gap(56),
        ],
      ),
    );
  }
}
