import 'package:flutter/material.dart';

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({
    super.key,
    required this.onPress,
  });

  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.outlined(
          onPressed: onPress,
          icon: const Icon(Icons.menu_rounded),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'System Admin',
                  // style: TextStyle(fontSize: 18),
                  maxLines: 1,
                ),
                Text('admin@viovid.com', maxLines: 1)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
